package tpsemana11;

import java.lang.reflect.*;

public class ALDAL {

    public static void geraTabela(Object obj) {
        Erro.setErro(false);
        Field[] f = obj.getClass().getDeclaredFields();
        String sql = "Create Table If Not Exists Tab" + obj.getClass().getSimpleName() + " (";

        for (int i = 0; i < f.length; ++i) {
            sql += f[i].getName() + " " + (f[i].getType().getSimpleName().equals("String") ? "varchar(60)" : f[i].getType());
            if (i != (f.length - 1)) sql = sql + ", ";
        }
        sql += ")";
        
        AFDAL.conecta("livros.db");
        AFDAL.executeSQL(sql);
        AFDAL.desconecta();
    }

    public static void set(Object obj) {
        Erro.setErro(false);
        Field[] f = obj.getClass().getDeclaredFields();
        String sql = "Insert Into Tab" + obj.getClass().getSimpleName() + " (";
        Method mtd;

        for (int i = 0; i < f.length; ++i) {
            sql += f[i].getName();
            if (i != (f.length - 1)) sql = sql + ", ";
        }
        sql += ") values (";
        for (int i = 0; i < f.length; ++i) {
            try {
                String aux = "get" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);
                mtd = obj.getClass().getMethod(aux);
                Object val = mtd.invoke(obj);
                String valStr = (val != null) ? val.toString() : "";

                if (f[i].getType().getSimpleName().equals("String"))  
                    sql += "'" + valStr + "'";
                else
                    sql += valStr.equals("") ? "null" : valStr;
            } catch (Exception e) {}
            if (i != (f.length - 1)) sql = sql + ", ";
        }
        sql += ")";

        AFDAL.conecta("livros.db");
        AFDAL.executeSQL(sql);
        AFDAL.desconecta();
    }

    public static void delete(Object obj) {
        Erro.setErro(false);
        Field[] f = obj.getClass().getDeclaredFields();
        String sql = "Delete from Tab" + obj.getClass().getSimpleName() + " where ";
        Method mtd;
        String aux1, aux2;
        boolean flag = false;

        for (int i = 0; i < f.length; ++i) {
            try {
                aux1 = "get" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);  
                mtd = obj.getClass().getMethod(aux1);
                Object res = mtd.invoke(obj);
                aux2 = (res != null) ? res.toString() : "";

                if (!aux2.trim().equals("")) {
                    if (flag) sql += " and "; else flag = true;
                    sql += f[i].getName() + " = ";
                    if (f[i].getType().getSimpleName().equals("String"))  
                        sql += "'" + aux2 + "'";
                    else
                        sql += aux2;
                }
            } catch (Exception e) {}
        }

        if (!flag) {
            Erro.setErro("Informe ao menos o Título para realizar a deleção.");
            return;
        }

        AFDAL.conecta("livros.db");
        AFDAL.executeSQL(sql);
        AFDAL.desconecta();
    }

    public static void get(Object obj) {
        Erro.setErro(false);
        Field[] f = obj.getClass().getDeclaredFields();
        String sql = "Select * from Tab" + obj.getClass().getSimpleName() + " where ";
        Method mtd;
        String aux1, aux2;
        boolean flag = false;

        for (int i = 0; i < f.length; ++i) {
            try {
                aux1 = "get" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);  
                mtd = obj.getClass().getMethod(aux1);
                Object res = mtd.invoke(obj);
                aux2 = (res != null) ? res.toString() : "";

                if (!aux2.trim().equals("")) {
                    if (flag) sql += " and "; else flag = true;
                    sql += f[i].getName() + " = ";
                    if (f[i].getType().getSimpleName().equals("String"))  
                        sql += "'" + aux2 + "'";
                    else
                        sql += aux2;
                }
            } catch (Exception e) {}
        }

        if (!flag) {
            Erro.setErro("Informe ao menos o Título para realizar a consulta.");
            return;
        }

        AFDAL.conecta("livros.db");
        AFDAL.executeSelect(sql, obj);
        AFDAL.desconecta();
    }

    public static void update(Object dados, Object chaves) {
        Erro.setErro(false);
        Field[] f = dados.getClass().getDeclaredFields();
        String sql = "Update Tab" + dados.getClass().getSimpleName() + " set ";
        Method mtd;
        String aux1, aux2;
        boolean flag = false;

        for (int i = 0; i < f.length; ++i) {
            try {
                aux1 = "get" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);  
                mtd = dados.getClass().getMethod(aux1);
                Object res = mtd.invoke(dados);
                aux2 = (res != null) ? res.toString() : "";

                if (!aux2.trim().equals("")) {
                    if (flag) sql += ", "; else flag = true;
                    sql += f[i].getName() + " = ";
                    if (f[i].getType().getSimpleName().equals("String"))  
                        sql += "'" + aux2 + "'";
                    else
                        sql += aux2;
                }
            } catch (Exception e) {}
        }

        if (!flag) {
            Erro.setErro("Nenhum dado novo fornecido para atualização.");
            return;
        }

        sql += " where ";
        f = chaves.getClass().getDeclaredFields();
        flag = false;

        for (int i = 0; i < f.length; ++i) {
            try {
                aux1 = "get" + f[i].getName().substring(0, 1).toUpperCase() + f[i].getName().substring(1);  
                mtd = chaves.getClass().getMethod(aux1);
                Object res = mtd.invoke(chaves);
                aux2 = (res != null) ? res.toString() : "";

                if (!aux2.trim().equals("")) {
                    if (flag) sql += " and "; else flag = true;
                    sql += f[i].getName() + " = ";
                    if (f[i].getType().getSimpleName().equals("String"))  
                        sql += "'" + aux2 + "'";
                    else
                        sql += aux2;
                }
            } catch (Exception e) {}
        }

        if (!flag) {
            Erro.setErro("Informe o Título para localizar o registro a atualizar.");
            return;
        }

        AFDAL.conecta("livros.db");
        AFDAL.executeSQL(sql);
        AFDAL.desconecta();
    }
}
