import "package:flutter/material.dart";

class SplashScene extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new Material(
        color: Colors.white,
        child: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset('image/cnoder_splash.png',fit: BoxFit.fitWidth)
            ]
          ),
        ),
      );
    }
}