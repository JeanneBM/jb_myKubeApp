package pattern;

public final class SingletonPatternDemo {
    private SingletonPatternDemo() {}

    public static String messages() {
        return String.join("\n", DeutschWelcome.getInstance().message(),
                PolishWelcome.getInstance().message(), SpanishWelcome.getInstance().message()) + "\n";
    }

    public static void main(String[] args) {
        System.out.print(messages());
    }
}
