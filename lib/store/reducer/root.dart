import "../model/root_state.dart";
import "./loading.dart";
import "./topic.dart";

RootState rootReducer(RootState state, action) {
  return new RootState(
      isLoading: loadingReducer(state.isLoading, action),
      topics: topicsReducer(state.topics, action),
      topic: topicReducer(state.topic, action)  
    );
}
