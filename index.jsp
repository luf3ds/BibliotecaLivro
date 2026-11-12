<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crudlivros.model.Livro" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biblioteca - Adicionar Livro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
</head>
<body>
    <%
        String msg = (String) request.getAttribute("mensagem");

        Livro l = (Livro) request.getAttribute("livroEncontrado");
        boolean emEdicao = (l != null && l.getTitulo() != null && !l.getTitulo().isEmpty());
        if (l == null) l = new Livro();

        List<Livro> listaLivros = (List<Livro>) request.getAttribute("listaLivros");
    %>

    <div class="app-container">
        <!-- Sidebar: Formulário de Adição -->
        <aside class="sidebar painel-de-vidro">
            <h2>Adicione um livro</h2>

            <% if (msg != null && !msg.isEmpty()) { %>
                <p style="font-size: 13px; color: rgba(255, 255, 255, 0.85); margin-bottom: 16px;">
                    <%= msg %>
                </p>
            <% } %>
            
            <form id="formulario-livro" action="<%= request.getContextPath() %>/LivroServlet" method="POST" autocomplete="off">
                <div class="grupo-input">
                    <label for="campo-codigo">Código do Livro</label>
                    <input type="text" id="campo-codigo" name="codigo" value="<%= l.getCodigo() != null ? l.getCodigo() : "" %>" required autocomplete="off">
                </div>
                <div class="grupo-input">
                    <label for="campo-titulo">Título</label>
                    <input type="text" id="campo-titulo" name="titulo" value="<%= l.getTitulo() != null ? l.getTitulo() : "" %>" required autocomplete="off">
                </div>
                <div class="grupo-input">
                    <label for="campo-autor">Autor</label>
                    <input type="text" id="campo-autor" name="autor" value="<%= l.getAutor() != null ? l.getAutor() : "" %>" autocomplete="off">
                </div>
                <div class="grupo-input">
                    <label for="campo-ano">Ano</label>
                    <input type="text" id="campo-ano" name="ano" maxlength="4" value="<%= l.getAno() != null ? l.getAno() : "" %>" autocomplete="off">
                </div>
                <div class="grupo-input">
                    <label for="campo-editora">Editora</label>
                    <input type="text" id="campo-editora" name="editora" value="<%= l.getEditora() != null ? l.getEditora() : "" %>" autocomplete="off">
                </div>
                <div class="grupo-input">
                    <label for="campo-localizacao">Localização</label>
                    <input type="text" id="campo-localizacao" name="localizacao" value="<%= l.getLocalizacao() != null ? l.getLocalizacao() : "" %>" autocomplete="off">
                </div>
                
                <div class="grupo-botoes">
                    <button type="submit" name="acao" value="<%= emEdicao ? "atualizar" : "inserir" %>" class="botao botao-salvar">Salvar</button>
                    <button type="button" class="botao botao-limpar" id="botao-limpar">Limpar</button>
                </div>
            </form>
        </aside>

        <!-- Área Principal: Busca e Cartões -->
        <main class="area-principal">
            <!-- Barra de Busca -->
            <form action="<%= request.getContextPath() %>/LivroServlet" method="GET" class="barra-busca painel-de-vidro">
                <input type="hidden" name="acao" value="consultar">
                <span class="icone-busca">[Lupa]</span>
                <input type="text" name="titulo" placeholder="Consultar..." class="input-busca">
            </form>
            
            <!-- Grid onde os livros salvos vão aparecer -->
            <div id="area-de-resultados" class="grid-livros">
                <% if (listaLivros != null && !listaLivros.isEmpty()) {
                    for (Livro item : listaLivros) { %>
                        <div class="cartao-livro painel-de-vidro">
                            <div class="cabecalho-cartao">
                                <h3><%= item.getTitulo() %></h3>
                                <span class="tag-codigo"><%= item.getCodigo() != null ? item.getCodigo() : "" %></span>
                            </div>
                            <div class="detalhes-cartao">
                                <p>Autor: <%= item.getAutor() != null ? item.getAutor() : "" %></p>
                                <p>Ano: <%= item.getAno() != null ? item.getAno() : "" %></p>
                                <p>Editora: <%= item.getEditora() != null ? item.getEditora() : "" %></p>
                                <p>Localização: <%= item.getLocalizacao() != null ? item.getLocalizacao() : "" %></p>
                            </div>
                            <div class="acoes-cartao">
                                <a href="<%= request.getContextPath() %>/LivroServlet?acao=consultar&titulo=<%= java.net.URLEncoder.encode(item.getTitulo(), "UTF-8") %>" style="color: inherit; text-decoration: none;"><span>[Editar]</span></a>
                                <a href="<%= request.getContextPath() %>/LivroServlet?acao=deletar&titulo=<%= java.net.URLEncoder.encode(item.getTitulo(), "UTF-8") %>" style="color: inherit; text-decoration: none;"><span>[Excluir]</span></a>
                            </div>
                        </div>
                <%  }
                } else if (emEdicao) { %>
                    <div class="cartao-livro painel-de-vidro">
                        <div class="cabecalho-cartao">
                            <h3><%= l.getTitulo() %></h3>
                            <span class="tag-codigo"><%= l.getCodigo() != null ? l.getCodigo() : "" %></span>
                        </div>
                        <div class="detalhes-cartao">
                            <p>Autor: <%= l.getAutor() %></p>
                            <p>Ano: <%= l.getAno() %></p>
                            <p>Editora: <%= l.getEditora() %></p>
                            <p>Localização: <%= l.getLocalizacao() %></p>
                        </div>
                        <div class="acoes-cartao">
                            <a href="<%= request.getContextPath() %>/LivroServlet?acao=consultar&titulo=<%= java.net.URLEncoder.encode(l.getTitulo(), "UTF-8") %>" style="color: inherit; text-decoration: none;"><span>[Editar]</span></a>
                            <a href="<%= request.getContextPath() %>/LivroServlet?acao=deletar&titulo=<%= java.net.URLEncoder.encode(l.getTitulo(), "UTF-8") %>" style="color: inherit; text-decoration: none;"><span>[Excluir]</span></a>
                        </div>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/script.js"></script>
</body>
</html>