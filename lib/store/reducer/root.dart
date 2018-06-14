import "../model/root_state.dart";
import "./loading.dart";
import "./topic.dart";

RootState rootReducer(RootState state, action) {
  return new RootState(
      isLoading: loadingReducer(state.isLoading, action),
      topics: topicReducer(state.topics, action));
}
