import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../root_state.dart";
import "../model/message.dart";

class MessagesViewModel{
  final Map<String, List<Message>> messages;
  final bool isLoading;

  MessagesViewModel({
    @required this.messages, 
    @required this.isLoading
  });

  static MessagesViewModel fromStore(Store<RootState> store) {
    return new MessagesViewModel(
       messages: store.state.messages,
       isLoading: store.state.isLoading
    );
  }
}