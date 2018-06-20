import "package:flutter/material.dart";

class PublishScene extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
        appBar: new AppBar(
          leading: new BackButton(),
        ),
        body: new Center(child: new Text('publish')),
      );
    }
}