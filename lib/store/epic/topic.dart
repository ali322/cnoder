import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../model/root_state.dart";
import "../model/topic.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> fetchTopicsEpic(
    Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<RequestTopics>())
      .asyncMap((RequestTopics action) {
    return http.get(apis['topics']).then((ret) {
      Map<String, dynamic> result = json.decode(ret.body);
      List<Topic> topics = [];
      result['data'].forEach((v) {
        topics.add(new Topic.fromJson(v));
      });
      return new ResponseTopics(topics);
    }).catchError((err){
      print(err);
      return new ResponseTopicsFailed(err);
    });
  });
}

Stream<dynamic> fetchTopicEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestTopic>())
    .asyncMap((action) {
      return http.get("${apis['topic']}/${action.id}")
        .then((ret) {
          Map<String, dynamic> result = json.decode(ret.body);
          Topic topic = new Topic.fromJson(result['data']);
          return new ResponseTopic(topic);
        }).catchError((err) {
          return new ResponseTopicFailed(err);
        });
    });
}
