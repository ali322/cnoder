import "dart:async";
import "dart:convert";
import "package:redux_epics/redux_epics.dart";
import "package:rxdart/rxdart.dart";
import "package:http/http.dart" as http;
import "../root_state.dart";
import "../model/message.dart";
import "../action/action.dart";
import "../../config/api.dart" show apis;

Stream<dynamic> fetchMessagesEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestMessages>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.get('${apis["messages"]}?accesstoken=${action.accessToken}&mdrender=false');
          Map<String, dynamic> result = json.decode(ret.body);
          Map<String, List<Message>> group = {};
          final List<Message> readMessages = [];
          final List<Message> notReadMessages = [];
          result["data"]["has_read_messages"].forEach((v) {
            readMessages.add(new Message.fromJson(v));
          });
          result["data"]["hasnot_read_messages"].forEach((v) {
            notReadMessages.add(new Message.fromJson(v));
          });
          group["read"] = readMessages;
          group["notRead"] = notReadMessages;
          yield new ResponseMessages(group);
        } catch(err) {
          print(err);
          yield new ResponseMessagesFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}