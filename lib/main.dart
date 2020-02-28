import "package:flutter/material.dart";
import "./app.dart";
import "./store/index.dart";

void main() async {
  final _store = await loadStore();
  runApp(new App(store: _store));
}
