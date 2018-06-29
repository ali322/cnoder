import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/me.dart";
import "../store/view_model/index.dart";
import "../widget/me.dart";
import "./base.dart";

bool initialized = false;

class MeContainer extends StatelessWidget implements InitializeContainer{
  final IndexViewModel vm;

  MeContainer({Key key, @required this.vm}):super(key: key);

  void setInitialized() {
    initialized = true;
  }

  bool getInitialized() {
    return initialized;
  }

  void initialize() {
    vm.fetchMe();
  }

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, MeViewModel>(
        converter: (Store<RootState> store) => MeViewModel.fromStore(store),
        builder: (BuildContext context, MeViewModel vm) {
          return new MeScene(vm: vm);
        },
      );
    }
}