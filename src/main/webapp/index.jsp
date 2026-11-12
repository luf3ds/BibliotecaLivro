<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.crudlivros.model.Livro" %>
<!doctype html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Acervo Digital — Gerenciamento de Livros</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
        <!-- Ligação para o arquivo CSS externo -->
        <link rel="stylesheet" href="css/style.css" />
    </head>
    <body>
        <canvas id="bg-canvas"></canvas>
        <div class="gradient-overlay"></div>

        <% 
            String msg = (String) request.getAttribute("mensagem");
            if (msg == null) msg = "Sistema pronto para busca ou novo cadastro.";
            
            Livro l = (Livro) request.getAttribute("livroEncontrado");
            if (l == null) l = new Livro();
        %>

        <main class="app-container">
            <header class="app-header">
                <div class="header-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                </div>
                <div>
                    <h2>Acervo Bibliográfico</h2>
                    <p class="subtitle">Gestão inteligente e consulta de títulos</p>
                </div>
            </header>

            <div class="message" role="status">
                <span><%= msg %></span>
            </div>

            <form class="crud-form" action="LivroServlet" method="POST" autocomplete="off">
                <div class="form-group full-width">
                    <label for="titulo">Título do Livro <span class="badge">Chave Primária</span></label>
                    <div class="input-wrapper">
                        <input type="text" id="titulo" name="titulo" value="<%= l.getTitulo() != null ? l.getTitulo() : "" %>" placeholder="Ex: Dom Casmurro" />
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="autor">Autor</label>
                    <div class="input-wrapper">
                        <input type="text" id="autor" name="autor" value="<%= l.getAutor() != null ? l.getAutor() : "" %>" placeholder="Ex: Machado de Assis" />
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="editora">Editora</label>
                    <div class="input-wrapper">
                        <input type="text" id="editora" name="editora" value="<%= l.getEditora() != null ? l.getEditora() : "" %>" placeholder="Ex: Companhia das Letras" />
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="ano">Ano</label>
                        <div class="input-wrapper">
                            <input type="text" id="ano" name="ano" value="<%= l.getAno() != null ? l.getAno() : "" %>" placeholder="Ex: 1899" maxlength="4" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="localizacao">Localização</label>
                        <div class="input-wrapper">
                            <input type="text" id="localizacao" name="localizacao" value="<%= l.getLocalizacao() != null ? l.getLocalizacao() : "" %>" placeholder="Ex: Estante B3" />
                        </div>
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" name="acao" value="consultar" class="btn btn-secondary">Consultar</button>
                    <button type="submit" name="acao" value="inserir" class="btn btn-primary">Inserir</button>
                    <button type="submit" name="acao" value="atualizar" class="btn btn-warning">Atualizar</button>
                    <button type="submit" name="acao" value="deletar" class="btn btn-danger">Deletar</button>
                </div>
            </form>
        </main>

        <!-- Ligação para o arquivo JS externo -->
        <script src="js/script.js"></script>
    </body>
</html>
