import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import "../store/model/root_state.dart";
import "../store/action/action.dart";

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexState();
  }
}

class IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Index')),
      body: new Center(
        child: new StoreConnector<RootState, bool>(
          converter: (Store<RootState> store) => store.state.isLoading,
          builder: (BuildContext context, bool isLoading) {
            return new Text(isLoading ? 'loading' : 'loaded');
          },
        ),
      ),
      floatingActionButton: new StoreConnector<RootState, VoidCallback>(
        converter: (Store<RootState> store) {
          return () => store.dispatch(ToggleLoading(!store.state.isLoading));
        },
        builder: (context, cb) {
          return new FloatingActionButton(
              onPressed: cb, tooltip: 'Increment', child: new Icon(Icons.add));
        },
      ),
    );
  }
}
