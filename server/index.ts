import * as HTTP from "http";
import Prometheus from "prom-client";

const requestCounter = new Prometheus.Counter({
  name: "http_requests_total",
  help: "http_requests_total_help",
});

const index: HTTP.RequestListener = (_, response) => {
  requestCounter.inc();
  response.statusCode = 200;
  response.write(JSON.stringify({ message: "Hello World" }));
  response.end(() => console.info("%s: Request received", new Date()));
};

const metrics: HTTP.RequestListener = (_, response) => {
  response.setHeader("Content-Type", Prometheus.register.contentType);
  response.end(Prometheus.register.metrics());
};

const server = HTTP.createServer((request, response) => {
  if (request.url === "/metrics") {
    metrics(request, response);
  } else {
    index(request, response);
  }
});

const port = process.env.PORT;

server.listen(port).once("listening", () => {
  Prometheus.register.registerMetric(requestCounter);
  console.debug("Server running on port %d", port);
});
