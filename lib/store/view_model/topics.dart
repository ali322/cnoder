import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../root_state.dart";

typedef void FetchTopics({int currentPage, String category, Function afterFetched});
typedef void ResetTopics({@required String category, @required Function afterFetched});
typedef void SwitchCategory({@required String category});

void _noop() {}

class TopicsViewModel {
  final Map topicsOfCategory;
  final bool isLoading;
  final FetchTopics fetchTopics;
  final ResetTopics resetTopics;

  TopicsViewModel({
    @required this.topicsOfCategory, 
    @required this.isLoading, 
    @required this.fetchTopics, 
    @required this.resetTopics
  });

  static TopicsViewModel fromStore(Store<RootState> store) {
    return new TopicsViewModel(
      topicsOfCategory: store.state.topicsOfCategory,
      isLoading: store.state.isLoading,
      fetchTopics: ({int currentPage = 1, String category = '', Function afterFetched = _noop}) {
        store.dispatch(new ToggleLoading(true));
        store.dispatch(new RequestTopics(currentPage: currentPage, category: category, afterFetched: afterFetched));
      },
      resetTopics: ({@required String category, @required Function afterFetched}) {
        store.dispatch(new RequestTopics(currentPage: 1, category: category, afterFetched: afterFetched));
      }
    );
  }
}