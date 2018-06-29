import "package:redux/redux.dart";
import "../action/action.dart";

final Reducer<List> collectsReducer = new TypedReducer<List, ResponseCollects>(_responseCollects);

List _responseCollects(List state, ResponseCollects action) {
  return action.topics;
}