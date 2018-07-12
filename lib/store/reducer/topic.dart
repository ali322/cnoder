import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/topic.dart";

final Reducer<Map> topicsReducer = combineReducers([
  new TypedReducer<Map, RequestTopics>(_requestTopics),
  new TypedReducer<Map, ResponseTopics>(_responseTopics)
]);

Map _requestTopics(Map state, RequestTopics action) {
  Map topicsOfTopics = {};
  state.forEach((k, v) {
    final _v = new Map.from(v);
    if (action.category == k) {
      _v["isFetched"] = false;
    }
    topicsOfTopics[k] = _v;
  });
  return topicsOfTopics;
}

Map _responseTopics(Map state, ResponseTopics action) {
  Map topicsOfCategory = {};
  state.forEach((k, v) {
    Map _v = {};
    _v.addAll(v);
    if (k == action.category) {
      List _list = [];
      if (_v['currentPage'] < action.currentPage) {
        _list.addAll(_v["list"]);
        _list.addAll(action.topics);
      } 
      if (action.currentPage == 1) {
        _list.addAll(action.topics);
      }
      _v["isFetched"] = true;
      _v["list"] = _list;
      _v["currentPage"] = action.currentPage;
    }
    topicsOfCategory[k] = _v;
  });
  return topicsOfCategory;
}

final Reducer<Topic> topicReducer = combineReducers<Topic>([
  new TypedReducer<Topic, ClearTopic>(_clearTopic),
  new TypedReducer<Topic, ResponseTopic>(_responseTopic),
  new TypedReducer<Topic, FinishLikeReply>(_likeReply),
  new TypedReducer<Topic, FinishToggleCollect>(_toggleCollect)
]);

Topic _clearTopic(Topic state, ClearTopic action) {
  return new Topic();
}

Topic _responseTopic(Topic state, ResponseTopic action) {
  return action.topic;
}

Topic _likeReply(Topic topic, FinishLikeReply action) {
  List<Reply> _replies = [];
  topic.replies.forEach((reply) {
    Reply _reply = Reply.cloneWith(reply);
    if (action.id == reply.id) {
      _reply = Reply.cloneWith(reply, action.status);
    }
    _replies.add(_reply);
  });
  return Topic.cloneWith(topic, replies: _replies);
}

Topic _toggleCollect(Topic topic, FinishToggleCollect action) {
  return Topic.cloneWith(topic, isCollect: action.status);
}