package com.crudlivros.controller;

import com.crudlivros.bll.LivroBLL;
import com.crudlivros.model.Livro;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import tpsemana11.ALDAL;
import tpsemana11.Erro;

@WebServlet(name = "LivroServlet", urlPatterns = {"/LivroServlet"})
public class LivroServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        ALDAL.geraTabela(new Livro());
        if (Erro.getErro()) {
            getServletContext().log(Erro.getMens());
        }
    }

    private void processar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");

        if (acao == null || acao.trim().isEmpty() || "listar".equals(acao)) {
            listar(request, response, null);
            return;
        }

        Livro livro = new Livro();
        livro.setCodigo(request.getParameter("codigo"));
        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setAno(request.getParameter("ano"));
        livro.setEditora(request.getParameter("editora"));
        livro.setLocalizacao(request.getParameter("localizacao"));

        switch (acao) {
            case "inserir":
                LivroBLL.validaInserir(livro);
                break;
            case "consultar":
                LivroBLL.validaConsultaDeletar('c', livro);
                if (!Erro.getErro()) request.setAttribute("livroEncontrado", livro);
                break;
            case "atualizar":
                LivroBLL.validaAtualizar(livro);
                break;
            case "deletar":
                LivroBLL.validaConsultaDeletar('d', livro);
                break;
            default:
                Erro.setErro("Ação não reconhecida.");
        }

        String mensagem = Erro.getErro() ? Erro.getMens() : mensagemSucesso(acao);
        listar(request, response, mensagem);
    }

    private String mensagemSucesso(String acao) {
        switch (acao) {
            case "inserir": return "Livro inserido com sucesso!";
            case "consultar": return "Livro encontrado com sucesso!";
            case "atualizar": return "Livro atualizado com sucesso!";
            case "deletar": return "Livro excluído com sucesso!";
            default: return null;
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response, String mensagem)
            throws ServletException, IOException {
        List<Livro> lista = ALDAL.listar();
        request.setAttribute("listaLivros", lista);
        if (mensagem != null) request.setAttribute("mensagem", mensagem);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processar(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processar(request, response);
    }
}
