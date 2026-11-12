document.addEventListener("DOMContentLoaded", function () {
    const formulario = document.getElementById("formulario-livro");
    const botaoLimpar = document.getElementById("botao-limpar");
    const resultados = document.getElementById("area-de-resultados");

    // O cadastro é processado pelo LivroServlet e persistido no SQLite.
    // Não chamar preventDefault() aqui: o formulário precisa chegar ao servidor.
    if (botaoLimpar && formulario) {
        botaoLimpar.addEventListener("click", function () {
            formulario.reset();
            const acao = formulario.querySelector('button[name="acao"]');
            if (acao) acao.value = "inserir";
        });
    }

    if (resultados) {
        resultados.addEventListener("click", function (evento) {
            const linkExcluir = evento.target.closest('a[href*="acao=deletar"]');
            if (linkExcluir && !window.confirm("Tem certeza de que deseja excluir este livro?")) {
                evento.preventDefault();
            }
        });
    }
});
