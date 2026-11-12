package com.crudlivros.controller;

import com.crudlivros.model.Livro;
import com.crudlivros.bll.LivroBLL;
import tpsemana11.Erro;
import tpsemana11.ALDAL;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "LivroServlet", urlPatterns = {"/LivroServlet"})
public class LivroServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        // Garante que a tabela TabLivro exista no arquivo livros.db assim que o sistema liga
        try {
            ALDAL.geraTabela(new Livro());
        } catch (Exception e) {
            System.out.println("Erro ao inicializar tabela: " + e.getMessage());
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        
        Livro livro = new Livro();
        livro.setTitulo(request.getParameter("titulo"));
        livro.setAutor(request.getParameter("autor"));
        livro.setEditora(request.getParameter("editora"));
        livro.setAno(request.getParameter("ano"));
        livro.setLocalizacao(request.getParameter("localizacao"));

        if ("inserir".equals(acao)) {
            LivroBLL.validaInserir(livro);
            if (Erro.getErro()) {
                request.setAttribute("mensagem", Erro.getMens());
            } else {
                request.setAttribute("mensagem", "Livro inserido com sucesso!");
            }
        } else if ("consultar".equals(acao)) {
            LivroBLL.validaConsultaDeletar('c', livro);
            if (Erro.getErro()) {
                request.setAttribute("mensagem", Erro.getMens());
            } else {
                request.setAttribute("mensagem", "Livro encontrado com sucesso!");
                request.setAttribute("livroEncontrado", livro);
            }
        } else if ("atualizar".equals(acao)) {
            LivroBLL.validaAtualizar(livro);
            if (Erro.getErro()) {
                request.setAttribute("mensagem", Erro.getMens());
            } else {
                request.setAttribute("mensagem", "Livro atualizado com sucesso!");
            }
        } else if ("deletar".equals(acao)) {
            LivroBLL.validaConsultaDeletar('d', livro);
            if (Erro.getErro()) {
                request.setAttribute("mensagem", Erro.getMens());
            } else {
                request.setAttribute("mensagem", "Livro deletado com sucesso!");
            }
        }
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
