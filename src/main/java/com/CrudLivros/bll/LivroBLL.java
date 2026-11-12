package com.crudlivros.bll;

import com.crudlivros.model.Livro;
import tpsemana11.ALDAL;
import tpsemana11.Erro;

public final class LivroBLL {
    private LivroBLL() {}

    public static void validaConsultaDeletar(char acao, Livro livro) {
        Erro.setErro(false);
        if (livro.getTitulo() == null || livro.getTitulo().trim().isEmpty()) {
            Erro.setErro("O campo Título é obrigatório.");
            return;
        }
        if (acao == 'd') ALDAL.delete(livro);
        else if (acao == 'c') ALDAL.get(livro);
        else Erro.setErro("Ação de consulta/exclusão inválida.");
    }

    public static void validaInserir(Livro livro) {
        Erro.setErro(false);
        if (vazio(livro.getTitulo()) || vazio(livro.getAutor())) {
            Erro.setErro("Preencha ao menos o Título e o Autor para cadastrar.");
            return;
        }
        ALDAL.set(livro);
    }

    public static void validaAtualizar(Livro livro) {
        Erro.setErro(false);
        if (vazio(livro.getTitulo())) {
            Erro.setErro("O Título é obrigatório para localizar o livro a atualizar.");
            return;
        }
        Livro chave = new Livro();
        chave.setTitulo(livro.getTitulo());
        ALDAL.update(livro, chave);
    }

    private static boolean vazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}
