import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store.dart";

class Index extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new IndexState();
    }
}

class IndexState extends State<Index>{
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Index')
        ),
        body: new Center(
          child: new StoreConnector<int, String>(
            converter: (store) => store.state.toString(),
            builder: (BuildContext context, String count) {
              return new Text(count + ' times');
            },
          ),
        ),
        floatingActionButton: new StoreConnector<int, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(Actions.Increment);
          },
          builder: (context, cb) {
            return new FloatingActionButton(
              onPressed: cb,
              tooltip: 'Increment',
              child: new Icon(Icons.add)
            );
          },
        ),
      );
    }
}