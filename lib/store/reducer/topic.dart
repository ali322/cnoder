import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/topic.dart";

final Reducer<List<Topic>> topicReducer = combineReducers<List<Topic>>(
    [new TypedReducer<List<Topic>, ResponseTopics>(_responseTopics)]);

List<Topic> _responseTopics(List<Topic> state, ResponseTopics action) {
  List<Topic> topics = [];
  action.topics.forEach((v) {
    topics.add(new Topic.fromJson(v));
  });
  print('topicReducer');
  print(topics);
  return topics;
}

