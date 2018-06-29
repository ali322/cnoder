import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/collect.dart";
import "../store/view_model/index.dart";
import "../widget/collect.dart";
import "./base.dart";

bool initialized = false;

class CollectContainer extends StatelessWidget implements InitializeContainer{
  final IndexViewModel vm;

  CollectContainer({Key key, this.vm}):super(key: key);

  void setInitialized() {
    initialized = true;
  }

  bool getInitialized() {
    return initialized;
  }

  void initialize() {
    vm.fetchCollects();
  }

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, CollectViewModel>(
        converter: (Store<RootState> store) => CollectViewModel.fromStore(store),
        builder: (BuildContext context, CollectViewModel vm) {
          return new CollectScene(vm: vm);
        },
      );
    }
}