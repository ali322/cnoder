import "package:flutter/foundation.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/topic.dart";
import "../model/root_state.dart";

class TopicViewModel {
  final Topic topic;
  final bool isLoading;

  TopicViewModel({@required this.topic, @required this.isLoading});

  static TopicViewModel fromStore(Store<RootState> store) {
    return new TopicViewModel(
      topic: store.state.topic,
      isLoading: store.state.isLoading
    );
  }
}