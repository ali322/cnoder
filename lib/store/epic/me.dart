import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../root_state.dart";
import "../model/me.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> fetchMeEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestMe>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.get('${apis["user"]}/${action.username}');
          Map<String, dynamic> result = json.decode(ret.body);
          Me me = new Me.fromJson(result["data"]);
          yield new ResponseMe(me);
        } catch(err) {
          print(err);
          yield new ResponseMeFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}