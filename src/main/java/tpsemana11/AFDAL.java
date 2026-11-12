package tpsemana11;

import java.sql.*;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class AFDAL {
    private static Connection con;

    public static void conecta(String _bd) {
        // NÃO limpamos o Erro aqui para não sobrescrever erros anteriores
        try {
            Class.forName("org.sqlite.JDBC");
            con = DriverManager.getConnection("jdbc:sqlite:" + _bd);
        } catch (Exception e) {
            Erro.setErro("Erro de conexão: " + e.getMessage());
        }
    }

    public static void desconecta() {
        // IMPORTANTE: NÃO fazemos Erro.setErro(false) aqui!
        // Se houvesse erro no executeSQL, o desconecta apagava o erro.
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (Exception e) {
            Erro.setErro("Erro ao fechar conexão: " + e.getMessage());
        }
    }

    public static void executeSQL(String _sql) {
        try {
            Statement st = con.createStatement();
            int rowsAffected = st.executeUpdate(_sql);
            
            // Se for DELETE ou UPDATE e não afetou nenhuma linha, grava o erro
            String sqlUpper = _sql.trim().toUpperCase();
            if (sqlUpper.startsWith("DELETE") || sqlUpper.startsWith("UPDATE")) {
                if (rowsAffected == 0) {
                    Erro.setErro("Nenhum registro foi encontrado na base de dados para esta operação.");
                }
            }
            st.close();
        } catch(Exception e) {
            Erro.setErro("Erro SQL: " + e.getMessage());
        }
    }

    public static void executeSelect(String _sql, Object obj) {
        ResultSet rs;
        try {
            PreparedStatement st = con.prepareStatement(_sql);
            rs = st.executeQuery();
            if (rs.next()) {
                Field[] f = obj.getClass().getDeclaredFields();
                Method mtd;
                String aux;
                
                for(int i = 0; i < f.length; ++i) {
                    aux = "set" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);
                    try {
                        mtd = obj.getClass().getMethod(aux, new Class[] { f[i].getType() });
                        
                        // Busca o valor na coluna da SQL (ignorando maiúsculas/minúsculas)
                        String valBanco = null;
                        try {
                            valBanco = rs.getString(f[i].getName());
                        } catch(Exception exCol) {
                            // Tenta buscar pelo índice da coluna caso o nome falhe
                            valBanco = rs.getString(i + 1);
                        }
                        
                        mtd.invoke(obj, new Object[] { valBanco != null ? valBanco : "" });
                    } catch(Exception e) {
                        System.out.println("Erro ao mapear campo " + f[i].getName() + ": " + e.getMessage());
                    }
                }
            } else {
                Erro.setErro("Livro não localizado no acervo."); 
            }
            st.close();
        } catch (Exception e) {
            Erro.setErro("Erro na consulta: " + e.getMessage());
        }
    }
}
