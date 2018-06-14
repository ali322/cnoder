import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import 'package:fluro/fluro.dart';
import "../store/model/root_state.dart";
import "../store/model/topic.dart";
import "../config/application.dart";

class Topics extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('列表')
        ),
        body: new StoreConnector<RootState, List<Topic>>(
          converter: (Store<RootState> store) {
//            return new List<Topic>();
            return store.state.topics;
            // return store.state.topics;
          },
          builder: (BuildContext context, List<Topic> rows) {
            return new ListView.builder(
              itemCount: rows.length,
              itemBuilder: (BuildContext context, int i) => _renderRow(context, rows[i]),
            );
          },
        )
      );
    }

    Widget _renderRow(BuildContext context, Topic row) {
      return new ListTile(
        title: new Text(row.title),
        onTap: () => Application.router.navigateTo(context, '/topic/?id=${row.id}', transition: TransitionType.inFromLeft),
      );
    }
}
