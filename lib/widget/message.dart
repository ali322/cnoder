import "package:flutter/material.dart";
import "../store/view_model/message.dart";

class MessageScene extends StatelessWidget{
  final MessagesViewModel vm;

  MessageScene({Key key, @required this.vm}):super(key: key);


  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        body: new Center(child: new Text('message'))
      );
    }
}