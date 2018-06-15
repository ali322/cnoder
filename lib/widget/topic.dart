import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import "../store/model/root_state.dart";
import "../store/model/topic.dart";
import "../config/application.dart";

class TopicDetail extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("详情"),
          leading: new BackButton(),
        ),
        body: new StoreConnector<RootState, Topic>(
          converter: (Store<RootState> store)=> store.state.topic,
          builder: (BuildContext context, Topic topic) => _renderTopic(context, topic),
        ),
      );
    }

    Widget _renderTopic(BuildContext context, Topic topic) {
      return new Text(topic.title);
    }
}