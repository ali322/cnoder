import "package:flutter/foundation.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/root_state.dart";

typedef void FetchTopics({@required int currentPage, @required String category, @required Function afterFetched});
typedef void ResetTopics({@required String category, @required Function afterFetched});
typedef void SwitchCategory({@required String category});

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
      fetchTopics: ({@required int currentPage, @required String category, @required Function afterFetched}) {
        store.dispatch(new RequestTopics(currentPage: currentPage, category: category, afterFetched: afterFetched));
      },
      resetTopics: ({@required String category, @required Function afterFetched}) {
        store.dispatch(new RequestTopics(currentPage: 1, category: category, afterFetched: afterFetched));
      }
    );
  }
}