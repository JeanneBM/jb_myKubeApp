package pattern;

public final class SpanishWelcome {
    private static final SpanishWelcome INSTANCE = new SpanishWelcome();

    private SpanishWelcome() {}

    public static SpanishWelcome getInstance() {
        return INSTANCE;
    }

    public String message() {
        return "Hola! Mi nombre es Asia. Hasta La Vista!";
    }

    public void showMessage() {
        System.out.println(message());
    }
}
