import "package:redux/redux.dart";
import "../action/action.dart";

final Reducer<bool> loadingReducer = combineReducers<bool>([
  new TypedReducer<bool, ToggleLoading>(_toggleLoading),
]);

bool _toggleLoading(bool state, ToggleLoading action) {
  return action.isLoading;
}
