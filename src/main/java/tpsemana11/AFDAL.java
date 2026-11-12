package tpsemana11;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class AFDAL {
    private AFDAL() {}

    public static Connection conecta() throws SQLException {
        try {
            Class.forName("org.sqlite.JDBC");
            String home = System.getProperty("user.home");
            Path pasta = Paths.get(home, "BibliotecaLivro");
            Files.createDirectories(pasta);
            Path banco = pasta.resolve("livros.db");
            return DriverManager.getConnection("jdbc:sqlite:" + banco.toAbsolutePath());
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQLite não encontrado. Coloque sqlite-jdbc.jar em WEB-INF/lib.", e);
        } catch (java.io.IOException e) {
            throw new SQLException("Não foi possível criar a pasta do banco de dados.", e);
        }
    }

    public static int executar(String sql, Object... parametros) throws SQLException {
        try (Connection con = conecta();
             PreparedStatement ps = con.prepareStatement(sql)) {
            preencher(ps, parametros);
            return ps.executeUpdate();
        }
    }

    public static ResultSet consultar(Connection con, String sql, Object... parametros) throws SQLException {
        PreparedStatement ps = con.prepareStatement(sql);
        preencher(ps, parametros);
        return ps.executeQuery();
    }

    private static void preencher(PreparedStatement ps, Object... parametros) throws SQLException {
        for (int i = 0; i < parametros.length; i++) {
            ps.setObject(i + 1, parametros[i]);
        }
    }
}
