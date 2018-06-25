import "package:flutter/material.dart";
import "package:fluro/fluro.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../route/handler.dart";
import "../store/index.dart";

class App extends StatelessWidget {
  final Router router = new Router();

  App() {
    router.notFoundHandler = notFoundHandler;
    handlers.forEach((String path,Handler handler) {
      router.define(path, handler: handler);
    });
  }

  @override
    Widget build(BuildContext context) {
      final app = new MaterialApp(
        title: 'CNoder',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.lightGreen
        ),
        onGenerateRoute: (RouteSettings routeSettings) {
          RouteMatch match = this.router.matchRoute(null, routeSettings.name, routeSettings: routeSettings, transitionType: TransitionType.native);
          return match.route;
        },
      );
      print('initial route: ${app.initialRoute}');

      return new StoreProvider(store: store, child: app);
    }
}