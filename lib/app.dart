import "package:flutter/material.dart";
import "package:fluro/fluro.dart";
import "package:flutter_redux/flutter_redux.dart";
import "./route/handler.dart";
import "./store/index.dart";

class App extends StatelessWidget {
  final Router router = new Router();

  App() {
    persistor.load(store);
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
          primarySwatch: Colors.lightGreen,
          iconTheme: new IconThemeData(
            color: Color(0xFF666666)
          ),
          textTheme: new TextTheme(
            body1: new TextStyle(color: Color(0xFF333333), fontSize: 14.0)
          )
        ),
        onGenerateRoute: (RouteSettings routeSettings) {
          RouteMatch match = this.router.matchRoute(null, routeSettings.name, routeSettings: routeSettings, transitionType: TransitionType.inFromRight);
          return match.route;
        },
      );

      return  new StoreProvider(store: store, child: app);
    }
}