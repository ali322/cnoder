import "package:flutter/material.dart";
import "../store/view_model/collect.dart";

class CollectScene extends StatelessWidget{
  final CollectViewModel vm;

  CollectScene({Key key, @required this.vm}):super(key: key);


  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        body: new Center(child: new Text('collect')),
      );
    }
}