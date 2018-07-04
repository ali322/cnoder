import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../root_state.dart";
import "../model/topic.dart";

class TopicViewModel{
  final Topic topic;
  final bool isLoading;
  final Function toggleLoading;
  final Function fetchTopic;
  final Function createReply;

  TopicViewModel({
    @required this.topic, 
    @required this.isLoading, 
    @required this.toggleLoading,
    @required this.fetchTopic,
    @required this.createReply
  });

  static TopicViewModel fromStore(Store<RootState> store) {
    return new TopicViewModel(
       topic: store.state.topic,
       isLoading: store.state.isLoading,
       toggleLoading: (bool isLoading) {
         store.dispatch(new ToggleLoading(isLoading));
       },
       fetchTopic: (String id) {
          store.dispatch(new ToggleLoading(true));
          store.dispatch(new RequestTopic(id));
       },
       createReply: (String id, String content) {
         store.dispatch(new StartCreateReply(id, content));
       }
    );
  }
}