import "package:flutter/material.dart";
import "package:fluro/fluro.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../config/application.dart";
import "../routes/index.dart";
import "../store/index.dart";

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  AppState() {
    final router = new Router();
    applyRoutes(router);
    Application.router = router;
    Application.store = store;
  }

  @override
  Widget build(BuildContext context) {
    final app = new MaterialApp(
      title: 'CNoder',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primaryColor: const Color(0xFF63CA6C)),
      onGenerateRoute: Application.router.generator,
    );
    print('initial route: ${app.initialRoute}');

    return new StoreProvider(store: store, child: app);
  }
}
