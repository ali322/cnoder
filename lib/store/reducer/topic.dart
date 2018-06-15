import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/topic.dart";

// final Reducer<List<Topic>> topicsReducer = combineReducers<List<Topic>>(
//   [
final Reducer<List<Topic>> topicsReducer =  new TypedReducer<List<Topic>, ResponseTopics>(_responseTopics);
// ]);

List<Topic> _responseTopics(List<Topic> state, ResponseTopics action) {
  return action.topics;
}

// final Reducer<Topic> topicReducer = combineReducers<Topic>([
final Reducer<Topic> topicReducer = new TypedReducer<Topic, ResponseTopic>(_responseTopic);
// ]);

Topic _responseTopic(Topic state, ResponseTopic action) {
  return action.topic;
}