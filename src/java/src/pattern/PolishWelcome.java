package pattern;

public final class PolishWelcome {
    private static final PolishWelcome INSTANCE = new PolishWelcome();

    private PolishWelcome() {}

    public static PolishWelcome getInstance() {
        return INSTANCE;
    }

    public String message() {
        return "Czesc! Mam na imie Asia. Do zobaczenia!";
    }

    public void showMessage() {
        System.out.println(message());
    }
}
