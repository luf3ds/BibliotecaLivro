package tpsemana11;

import com.crudlivros.model.Livro;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public final class ALDAL {
    private static final String TABELA = "TabLivro";
    private ALDAL() {}

    public static void geraTabela(Livro livro) {
        Erro.setErro(false);
        String sql = "CREATE TABLE IF NOT EXISTS " + TABELA + " (" +
                "codigo TEXT, titulo TEXT NOT NULL, autor TEXT, " +
                "editora TEXT, ano TEXT, localizacao TEXT)";
        try {
            AFDAL.executar(sql);
        } catch (SQLException e) {
            Erro.setErro("Erro ao criar tabela: " + e.getMessage());
        }
    }

    public static void set(Livro livro) {
        Erro.setErro(false);
        String sql = "INSERT INTO " + TABELA +
                " (codigo, titulo, autor, editora, ano, localizacao) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            AFDAL.executar(sql, livro.getCodigo(), livro.getTitulo(), livro.getAutor(),
                    livro.getEditora(), livro.getAno(), livro.getLocalizacao());
        } catch (SQLException e) {
            Erro.setErro("Erro ao inserir livro: " + e.getMessage());
        }
    }

    public static void get(Livro livro) {
        Erro.setErro(false);
        String sql = "SELECT codigo, titulo, autor, editora, ano, localizacao FROM " +
                TABELA + " WHERE titulo = ? LIMIT 1";
        try (Connection con = AFDAL.conecta();
             ResultSet rs = AFDAL.consultar(con, sql, livro.getTitulo())) {
            if (rs.next()) preencherLivro(livro, rs);
            else Erro.setErro("Livro não localizado no acervo.");
        } catch (SQLException e) {
            Erro.setErro("Erro ao consultar livro: " + e.getMessage());
        }
    }

    public static List<Livro> listar() {
        Erro.setErro(false);
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT codigo, titulo, autor, editora, ano, localizacao FROM " + TABELA + " ORDER BY titulo";
        try (Connection con = AFDAL.conecta();
             ResultSet rs = AFDAL.consultar(con, sql)) {
            while (rs.next()) {
                Livro livro = new Livro();
                preencherLivro(livro, rs);
                livros.add(livro);
            }
        } catch (SQLException e) {
            Erro.setErro("Erro ao listar livros: " + e.getMessage());
        }
        return livros;
    }

    public static void delete(Livro livro) {
        Erro.setErro(false);
        try {
            int linhas = AFDAL.executar("DELETE FROM " + TABELA + " WHERE titulo = ?", livro.getTitulo());
            if (linhas == 0) Erro.setErro("Nenhum livro encontrado para excluir.");
        } catch (SQLException e) {
            Erro.setErro("Erro ao excluir livro: " + e.getMessage());
        }
    }

    public static void update(Livro dados, Livro chave) {
        Erro.setErro(false);
        String sql = "UPDATE " + TABELA +
                " SET codigo = ?, autor = ?, editora = ?, ano = ?, localizacao = ? WHERE titulo = ?";
        try {
            int linhas = AFDAL.executar(sql, dados.getCodigo(), dados.getAutor(), dados.getEditora(),
                    dados.getAno(), dados.getLocalizacao(), chave.getTitulo());
            if (linhas == 0) Erro.setErro("Nenhum livro encontrado para atualizar.");
        } catch (SQLException e) {
            Erro.setErro("Erro ao atualizar livro: " + e.getMessage());
        }
    }

    private static void preencherLivro(Livro livro, ResultSet rs) throws SQLException {
        livro.setCodigo(rs.getString("codigo"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setEditora(rs.getString("editora"));
        livro.setAno(rs.getString("ano"));
        livro.setLocalizacao(rs.getString("localizacao"));
    }
}
