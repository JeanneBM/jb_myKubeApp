package pattern;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** Small HTTP adapter for the original singleton greeting demo. */
public final class WelcomeServer {
    private WelcomeServer() {}

    public static HttpServer create(int port, ExecutorService executor) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", port), 16);
        server.setExecutor(executor);
        server.createContext("/", WelcomeServer::handle);
        return server;
    }

    private static void handle(HttpExchange exchange) throws IOException {
        try (exchange) {
            if (!"GET".equals(exchange.getRequestMethod())) {
                exchange.getResponseHeaders().set("Allow", "GET");
                respond(exchange, 405, "Method not allowed\n");
                return;
            }
            switch (exchange.getRequestURI().getPath()) {
                case "/" -> respond(exchange, 200, SingletonPatternDemo.messages());
                case "/healthz" -> respond(exchange, 200, "ok\n");
                default -> respond(exchange, 404, "Not found\n");
            }
        }
    }

    private static void respond(HttpExchange exchange, int status, String message) throws IOException {
        byte[] body = message.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=utf-8");
        exchange.sendResponseHeaders(status, body.length);
        exchange.getResponseBody().write(body);
    }

    public static void main(String[] args) throws IOException {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));
        ExecutorService executor = Executors.newFixedThreadPool(4);
        HttpServer server = create(port, executor);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            server.stop(1);
            executor.shutdown();
        }));
        server.start();
        System.out.println("Welcome server listening on port " + server.getAddress().getPort());
    }
}
