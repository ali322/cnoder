import "package:redux/redux.dart";
import "../action/action.dart";
import "../model/me.dart";

final Reducer<Me> meReducer = new TypedReducer<Me, ResponseMe>(_responseMe);

Me _responseMe(Me state, ResponseMe action) {
  return action.me;
}
