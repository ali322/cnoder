import "package:flutter/material.dart";
import "package:fluro/fluro.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux_persist_flutter/redux_persist_flutter.dart";
import "./widget/splash.dart";
import "./route/handler.dart";
import "./store/index.dart";

class App extends StatelessWidget {
  final Router router = new Router();

  App() {
    // persistor.load(store);

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
          RouteMatch match = this.router.matchRoute(null, routeSettings.name, routeSettings: routeSettings, transitionType: TransitionType.inFromRight);
          return match.route;
        },
      );
      print('initial route: ${app.initialRoute}');

      return  new StoreProvider(store: store, child: app);

      // return new PersistorGate(
      //   persistor: persistor,
      //   loading: new SplashScene(),
      //   builder: (BuildContext context) {
      //     return new StoreProvider(store: store, child: app);
      //   },
      // );

    }
}