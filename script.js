// Ação principal: Submeter o formulário
document.getElementById('formulario-livro').addEventListener('submit', function(evento) {
    evento.preventDefault();

    // 1. Captação dos dados preenchidos
    const valorCodigo = document.getElementById('campo-codigo').value;
    const valorTitulo = document.getElementById('campo-titulo').value;
    const valorAutor = document.getElementById('campo-autor').value;
    const valorAno = document.getElementById('campo-ano').value;
    const valorEditora = document.getElementById('campo-editora').value;
    const valorLocalizacao = document.getElementById('campo-localizacao').value;

    // 2. Alerta confirmando o salvamento
    alert("Livro Salvo com Sucesso!");

    // 3. Estrutura do card idêntica ao design (com as classes de estilo criadas)
    const modeloCartaoCriado = `
        <div class="cartao-livro painel-de-vidro">
            <div class="cabecalho-cartao">
                <h3>${valorTitulo}</h3>
                <span class="tag-codigo">${valorCodigo}</span>
            </div>
            <div class="detalhes-cartao">
                <p>Autor: ${valorAutor}</p>
                <p>Ano: ${valorAno}</p>
                <p>Editora: ${valorEditora}</p>
                <p>Localização: ${valorLocalizacao}</p>
            </div>
            <div class="acoes-cartao">
                <span>[Editar]</span>
                <span class="botao-excluir">[Excluir]</span>
            </div>
        </div>
    `;

    // 4. Renderiza o card no painel da direita (alterado para +=)
    const espacoResultados = document.getElementById('area-de-resultados');
    espacoResultados.innerHTML += modeloCartaoCriado; 

    document.getElementById('formulario-livro').reset();
});


document.getElementById('botao-limpar').addEventListener('click', function() {
    document.getElementById('formulario-livro').reset();
});


document.getElementById('area-de-resultados').addEventListener('click', function(evento) {
    if (evento.target.classList.contains('botao-excluir')) {  
        if(confirm("Tem a certeza que deseja excluir este livro?")) {
            const cartaoLivro = evento.target.closest('.cartao-livro');
            if (cartaoLivro) {
                cartaoLivro.remove();
            }
        }
    }
});