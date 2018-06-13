import "package:fluro/fluro.dart";
import "handler.dart";

void applyRoutes(Router router) {
  router.notFoundHandler = notFoundHandler;
  handlers.forEach((k,v) {
    router.define(k, handler: v);
  });
}