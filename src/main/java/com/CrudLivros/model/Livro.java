package com.crudlivros.model;

public class Livro {
    private String codigo;
    private String titulo;
    private String autor;
    private String editora;
    private String ano;
    private String localizacao;

    public Livro() {}

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public String getEditora() { return editora; }
    public void setEditora(String editora) { this.editora = editora; }

    public String getAno() { return ano; }
    public void setAno(String ano) { this.ano = ano; }

    public String getLocalizacao() { return localizacao; }
    public void setLocalizacao(String localizacao) { this.localizacao = localizacao; }
}
