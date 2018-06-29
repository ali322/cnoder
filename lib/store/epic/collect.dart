import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../root_state.dart";
import "../model/topic.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> fetchCollectsEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestCollects>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.get('${apis["userCollect"]}/${action.username}');
          Map<String, dynamic> result = json.decode(ret.body);
          List<Topic> topics = [];
          result['data'].forEach((v) {
            topics.add(new Topic.fromJson(v));
          });
          yield new ResponseCollects(topics);
        } catch(err) {
          print(err);
          yield new ResponseCollectsFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}