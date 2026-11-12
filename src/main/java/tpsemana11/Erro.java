package tpsemana11;

public final class Erro {
    private static boolean erro;
    private static String mens;

    private Erro() {}

    public static void setErro(boolean valor) {
        erro = valor;
        if (!valor) mens = null;
    }

    public static void setErro(String mensagem) {
        erro = true;
        mens = mensagem;
    }

    public static boolean getErro() { return erro; }
    public static String getMens() { return mens; }
}
