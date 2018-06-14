import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../model/root_state.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> fetchTopicsEpic(
    Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
      .ofType(new TypeToken<RequestTopics>())
      .asyncMap((RequestTopics action) {
    return http.get(apis['topics']).then((ret) {
      Map<String, dynamic> result = json.decode(ret.body);
      return new ResponseTopics(result['data'] as List);
    }).catchError((err){
      print(err);
      return new ResponseTopicsFailed(err);
    });
  });
}
