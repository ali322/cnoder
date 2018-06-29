import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/message.dart";
import "../store/view_model/index.dart";
import "../widget/message.dart";
import "./base.dart";

bool initialized = false;

class MessageContainer extends StatelessWidget implements InitializeContainer{
  final IndexViewModel vm;

  MessageContainer({Key key, @required this.vm}):super(key: key);

  void setInitialized() {
    initialized = true;
  }

  bool getInitialized() {
    return initialized;
  }

  void initialize() {
    vm.fetchMessages();
  }

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, MessagesViewModel>(
        converter: (Store<RootState> store) => MessagesViewModel.fromStore(store),
        builder: (BuildContext context, MessagesViewModel vm) {
          return new MessageScene(vm: vm);
        },
      );
    }
}