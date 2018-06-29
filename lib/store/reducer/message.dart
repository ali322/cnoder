import "package:redux/redux.dart";
import "../action/action.dart";

final Reducer<Map> messagesReducer = new TypedReducer<Map, ResponseMessages>(_responseMessages);

Map _responseMessages(Map state, ResponseMessages action) {
  return action.group;
}