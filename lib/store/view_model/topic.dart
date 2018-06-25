import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/root_state.dart";
import "../model/topic.dart";

class TopicViewModel{
  final Topic topic;
  final bool isLoading;
  final Function toggleLoading;

  TopicViewModel({
    @required this.topic, 
    @required this.isLoading, 
    @required this.toggleLoading
  });

  static TopicViewModel fromStore(Store<RootState> store) {
    return new TopicViewModel(
       topic: store.state.topic,
       isLoading: store.state.isLoading,
       toggleLoading: (bool isLoading) {
         store.dispatch(new ToggleLoading(isLoading));
       }
    );
  }
}