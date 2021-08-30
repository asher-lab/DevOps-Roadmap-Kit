package com.example;

import io.undertow.Undertow;
import io.undertow.server.HttpHandler;
import io.undertow.server.HttpServerExchange;
import io.undertow.util.Headers;

/**
 * Hello world!
 * Returns a simple web page on port 3000.
 */
public class Application {

    public static void main(String[] args) {
        Undertow server = Undertow.builder()
                // Set up the listener - you can change the port/host here
                .addHttpListener(3000, "0.0.0.0")

                .setHandler(exchange -> {
                    // Sets the return Content-Type to text/html
                    exchange.getResponseHeaders()
                            .put(Headers.CONTENT_TYPE, "text/html");

                    // Returns a hard-coded HTML document
                    exchange.getResponseSender()
                            .send("<html>" +
                                    "<body>" +
                                    "<h1>Hello, world!</h1>" +
                                    "</body>" +
                                    "</html>");
                }).build();

        // Boot the web server
        server.start();
    }
}
