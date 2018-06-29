import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../root_state.dart";
import "../action/action.dart";

void _noop() {}

class IndexViewModel{
  final Map<String, dynamic> auth;
  final int tabIndex;
  final Function selectTab;
  final VoidCallback fetchTopics;
  final VoidCallback fetchCollects;
  final VoidCallback fetchMessages;
  final VoidCallback fetchMe;

  IndexViewModel({
    @required this.tabIndex,
    @required this.selectTab,
    @required this.auth,
    @required this.fetchTopics,
    @required this.fetchCollects,
    @required this.fetchMessages,
    @required this.fetchMe
  });

  static IndexViewModel fromStore(Store<RootState> store) {
    return new IndexViewModel(
      auth: store.state.auth,
      tabIndex: store.state.tabIndex,
      selectTab: (int i) {
        store.dispatch(new SelectTab(i));
      },
      fetchTopics: () {
        store.dispatch(new ToggleLoading(true));
        store.dispatch(new RequestTopics(afterFetched: _noop));
      },
      fetchCollects: () {
        store.dispatch(new ToggleLoading(true));
        store.dispatch(new RequestCollects(store.state.auth["username"]));
      },
      fetchMessages: () {
        store.dispatch(new ToggleLoading(true));
        store.dispatch(new RequestMessages(store.state.auth["accessToken"]));
      },
      fetchMe: () {
        store.dispatch(new ToggleLoading(true));
        store.dispatch(new RequestMe(store.state.auth["username"]));
      }
    );
  }
}