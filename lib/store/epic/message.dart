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
          result["data"]["hasnot_read_messages"].forEach((v) {
            notReadMessages.add(new Message.fromJson(v));
          });
          result["data"]["has_read_messages"].forEach((v) {
            readMessages.add(new Message.fromJson(v));
          });
          group["notRead"] = notReadMessages;
          group["read"] = readMessages;
          yield new ResponseMessages(group);
        } catch(err) {
          print(err);
          yield new ResponseMessagesFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> fetchMessageCountEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<RequestMessageCount>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.get("${apis['messageCount']}?accesstoken=${store.state.auth["accessToken"]}");
          Map<String, dynamic> result = json.decode(ret.body);
          yield new ResponseMessageCount(result["data"]);
        } catch(err) {
          print(err);
          yield new ResponseMessageCountFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> markAllAsReadEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartMarkAllAsRead>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['markAllMessage']}", body: {
            'accesstoken': store.state.auth["accessToken"]
          });
          Map<String, dynamic> result = json.decode(ret.body);
          final List<int> ids = [];
          result["marked_msgs"].forEach((v) {
            ids.add(v.id);
          });
          yield new FinishMarkAllAsRead(ids);
        } catch(err) {
          print(err);
          yield new FinishMarkAllAsReadFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}

Stream<dynamic> markAsReadEpic(Stream<dynamic> actions, EpicStore<RootState> store) {
  return new Observable(actions)
    .ofType(new TypeToken<StartMarkAsRead>())
    .flatMap((action) {
      return new Observable(() async* {
        try {
          final ret = await http.post("${apis['markMessage']}/${action.id}", body: {
            'accesstoken': store.state.auth["accessToken"]
          });
          Map<String, dynamic> result = json.decode(ret.body);
          yield new FinishMarkAsRead(result['marked_msg_id']);
        } catch(err) {
          print(err);
          yield new FinishMarkAsReadFailed(err);
        }
        yield new ToggleLoading(false);
      }());
    });
}