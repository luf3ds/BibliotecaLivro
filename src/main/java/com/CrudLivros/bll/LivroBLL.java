package com.crudlivros.bll;

import com.crudlivros.model.Livro;
import tpsemana11.Erro;
import tpsemana11.ALDAL; 

public class LivroBLL {

    public static void validaConsultaDeletar(char digito, Livro _umLivro) {
        Erro.setErro(false);
        if (_umLivro.getTitulo() == null || _umLivro.getTitulo().trim().equals("")) {
            Erro.setErro("O campo Título é obrigatório.");
            return;
        }
        if (digito == 'd') {
            ALDAL.delete(_umLivro);
        } else if (digito == 'c') {
            ALDAL.get(_umLivro);
        }
    }

    public static void validaInserir(Livro _umLivro) {
        Erro.setErro(false);
        if (_umLivro.getTitulo() == null || _umLivro.getTitulo().trim().equals("") || 
            _umLivro.getAutor() == null || _umLivro.getAutor().trim().equals("")) {
            Erro.setErro("Preencha ao menos o Título e o Autor para cadastrar.");
            return;
        }
        ALDAL.set(_umLivro);
    }

    public static void validaAtualizar(Livro _umLivro) {
        Erro.setErro(false);
        if (_umLivro.getTitulo() == null || _umLivro.getTitulo().trim().equals("")) {
            Erro.setErro("O Título é obrigatório para localizar o livro a atualizar.");
            return;
        }
        Livro chave = new Livro();
        chave.setTitulo(_umLivro.getTitulo());
        
        ALDAL.update(_umLivro, chave);
    }
}
