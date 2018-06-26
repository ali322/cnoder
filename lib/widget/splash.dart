import "package:flutter/material.dart";

class SplashScene extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new Material(
        color: Colors.lightGreen,
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Splash',
                textDirection: TextDirection.ltr,
                style: new TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold)
              )
            ]
          ),
        ),
      );
    }
}