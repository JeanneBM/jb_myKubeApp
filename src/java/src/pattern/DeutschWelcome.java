package pattern;

public final class DeutschWelcome {
    private static final DeutschWelcome INSTANCE = new DeutschWelcome();

    private DeutschWelcome() {}

    public static DeutschWelcome getInstance() {
        return INSTANCE;
    }

    public String message() {
        return "Guten Tag! Ich heiße Asia. Auf Wiedersehen!";
    }

    public void showMessage() {
        System.out.println(message());
    }
}
