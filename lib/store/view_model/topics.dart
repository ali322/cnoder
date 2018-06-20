import "package:flutter/foundation.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/root_state.dart";

class TopicsViewModel {
  final Map topicsOfCategory;
  final bool isLoading;

  TopicsViewModel({@required this.topicsOfCategory, @required this.isLoading});

  static TopicsViewModel fromStore(Store<RootState> store) {
    return new TopicsViewModel(
      topicsOfCategory: store.state.topicsOfCategory,
      isLoading: store.state.isLoading
    );
  }
}