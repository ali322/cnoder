import "package:flutter/material.dart";
import "../store/view_model/me.dart";

class MeScene extends StatelessWidget{
  final MeViewModel vm;

  MeScene({Key key, @required this.vm}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text('我的', style: new TextStyle(color: Colors.white, fontSize: 14.0))
        ),
        body: new Column(
          children: <Widget>[

          ],
        )
      );
    }

  Widget _renderTitle(BuildContext context) {

  }
}