package pattern;

import com.sun.net.httpserver.HttpServer;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class WelcomeServerTest {
    private static void check(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }

    public static void main(String[] args) throws Exception {
        check(DeutschWelcome.getInstance() == DeutschWelcome.getInstance(), "German singleton");
        check(PolishWelcome.getInstance() == PolishWelcome.getInstance(), "Polish singleton");
        check(SpanishWelcome.getInstance() == SpanishWelcome.getInstance(), "Spanish singleton");
        ExecutorService executor = Executors.newFixedThreadPool(2);
        HttpServer server = WelcomeServer.create(0, executor);
        try {
            server.start();
            HttpClient client = HttpClient.newHttpClient();
            String base = "http://127.0.0.1:" + server.getAddress().getPort();
            var home = client.send(HttpRequest.newBuilder(URI.create(base + "/")).build(),
                    HttpResponse.BodyHandlers.ofString());
            check(home.statusCode() == 200, "Home status");
            check(home.body().equals(SingletonPatternDemo.messages()), "Greetings over HTTP");
            var health = client.send(HttpRequest.newBuilder(URI.create(base + "/healthz")).build(),
                    HttpResponse.BodyHandlers.ofString());
            check(health.statusCode() == 200 && health.body().equals("ok\n"), "Health endpoint");
            var missing = client.send(HttpRequest.newBuilder(URI.create(base + "/missing")).build(),
                    HttpResponse.BodyHandlers.ofString());
            check(missing.statusCode() == 404, "Missing route");
            var post = client.send(HttpRequest.newBuilder(URI.create(base + "/"))
                    .POST(HttpRequest.BodyPublishers.noBody()).build(), HttpResponse.BodyHandlers.ofString());
            check(post.statusCode() == 405, "Unsupported method");
            System.out.println("Java singleton and HTTP tests passed");
        } finally {
            server.stop(0);
            executor.shutdownNow();
        }
    }
}
