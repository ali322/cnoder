import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../root_state.dart";
import "../model/topic.dart";

class PublishViewModel{
  final Function createTopic;
  final Function saveTopic;
  final Topic topic;
  final bool isLoading;

  PublishViewModel({@required this.createTopic, @required this.saveTopic, @required this.topic,@required this.isLoading});

  static PublishViewModel fromStore(Store<RootState> store) {
    return new PublishViewModel(
      createTopic: (Map topic, Function afterCreate) {
        store.dispatch(new StartCreateTopic(topic, afterCreate));
      },
      saveTopic: (Map topic, Function afterSave) {
        store.dispatch(new StartSaveTopic(topic, afterSave));
      },
      topic: store.state.topic,
      isLoading: store.state.isLoading
    );
  }
}