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

final Reducer<Topic> topicReducer = new TypedReducer<Topic, ResponseTopic>(_responseTopic);

Topic _responseTopic(Topic state, ResponseTopic action) {
  return action.topic;
}