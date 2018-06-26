import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../root_state.dart";
import "../action/action.dart";

class IndexViewModel{
  final Map<String, dynamic> auth;
  final int tabIndex;
  final Function selectTab;

  IndexViewModel({
    @required this.auth,
    @required this.tabIndex,
    @required this.selectTab
  });

  static IndexViewModel fromStore(Store<RootState> store) {
    return new IndexViewModel(
      auth: store.state.auth,
      tabIndex: store.state.tabIndex,
      selectTab: (int i) {
        store.dispatch(new SelectTab(i));
      }
    );
  }
}