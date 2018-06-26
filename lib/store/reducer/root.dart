import "../root_state.dart";
import "package:redux_persist/redux_persist.dart";
import "./loading.dart";
import "./topic.dart";

RootState rootReducer(RootState state, action) {
  if (action is PersistLoadedAction<RootState>) {
    return action.state ?? state;
  }
  if (action is PersistErrorAction) {
    print(action.error);
  }
  return new RootState(
      isLoading: loadingReducer(state.isLoading, action),
      topicsOfCategory: topicsReducer(state.topicsOfCategory, action),
      topic: topicReducer(state.topic, action)  
    );
}
