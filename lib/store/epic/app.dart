import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../root_state.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> doLoginEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartLogin>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post(apis["authorize"], body: { "accesstoken" : action.accessToken });
          Map<String, dynamic> result = json.decode(ret.body);
          action.afterFinished();
          yield new FinishLogin(accessToken: action.accessToken, username: result["username"], avatar: result["avatar_url"]);
        } catch(err) {
          yield new FinishLoginFailed(err);
        }
      }());
    });
}