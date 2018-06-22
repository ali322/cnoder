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
      .flatMap((action) {
        return new Observable(() async* {
          try {
            final ret = await http.get("${apis['topics']}?page=${action.currentPage}&limit=6&tab=${action.category}&mdrender=false");
            Map<String, dynamic> result = json.decode(ret.body);
            List<Topic> topics = [];
            result['data'].forEach((v) {
              topics.add(new Topic.fromJson(v));
            });
            action.afterFetched();
            yield new ResponseTopics(action.currentPage, action.category, topics);
          } catch(err) {
            print(err);
            yield new ResponseTopicsFailed(err);
          }
          yield new ToggleLoading(false);
        } ());
  });
}

Stream<dynamic> fetchTopicEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestTopic>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.get("${apis['topic']}/${action.id}?mdrender=false");
          Map<String, dynamic> result = json.decode(ret.body);
          Topic topic = new Topic.fromJson(result['data']);
          yield new ResponseTopic(topic);
        } catch(err) {
          print(err);
          yield new ResponseTopicFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}
