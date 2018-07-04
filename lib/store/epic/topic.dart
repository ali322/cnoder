import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../root_state.dart";
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

Stream<dynamic> createTopicEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartCreateTopic>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['topics']}", body: {
            "accesstoken": store.state.auth["accessToken"],
            "title": action.topic["title"],
            "tab": action.topic["tag"],
            "content": action.topic["content"]
          });
          Map<String, dynamic> result = json.decode(ret.body);
          action.afterCreated(result["success"], result["error_msg"]);
          yield new FinishCreateTopic(result["topic_id"]);
        } catch(err) {
          print(err);
          action.afterCreated(false);
          yield new FinishCreateTopicFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> saveTopicEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartSaveTopic>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['saveTopic']}", body: {
            "accesstoken": store.state.auth["accessToken"],
            "topic_id": action.topic["id"],
            "title": action.topic["title"],
            "tab": action.topic["tag"],
            "content": action.topic["content"]
          });
          Map<String, dynamic> result = json.decode(ret.body);
          yield new FinishSaveTopic(result["topic_id"]);
        } catch(err) {
          print(err);
          yield new FinishSaveTopicFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> createReplyEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartCreateReply>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['reply2topic']}/${action.id}/replies", body: {
            "accesstoken": store.state.auth["accessToken"],
            "content": action.content,
          });
          Map<String, dynamic> result = json.decode(ret.body);
          yield new FinishCreateReply(result["reply_id"]);
        } catch(err) {
          print(err);
          yield new FinishCreateReplyFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> toggleCollectEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartToggleCollect>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${action.status ? apis['addCollect'] : apis['delCollect']}", body: {
            "accesstoken": store.state.auth["accessToken"],
            "topic_id": action.id,
          });
          Map<String, dynamic> result = json.decode(ret.body);
          yield new FinishToggleCollect(result['success']);
        } catch(err) {
          print(err);
          yield new FinishToggleCollectFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> likeReplyEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartLikeReply>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['likeReply']}/${action.id}/ups", body: {
            "accesstoken": store.state.auth["accessToken"]
          });
          Map<String, dynamic> result = json.decode(ret.body);
          yield new FinishLikeReply(result["success"], result['action']);
        } catch(err) {
          print(err);
          yield new FinishLikeReplyFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}
