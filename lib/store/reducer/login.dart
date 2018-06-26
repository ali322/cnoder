import "package:redux/redux.dart";
import "../action/action.dart";

final Reducer<Map> loginReducer = combineReducers<Map>([
  new TypedReducer<Map, FinishLogin>(_finishLogin),
  new TypedReducer<Map, FinishLoginFailed>(_finishLoginFailed),
  new TypedReducer<Map, Logout>(_logout)
]);

Map _finishLogin(Map state,FinishLogin action) {
  return <String, dynamic>{
    "accessToken": action.accessToken,
    "username": action.username,
    "avatar": action.avatar,
    "isLogined": true
  };
}

Map _finishLoginFailed(Map state,FinishLogin action) {
  return <String, dynamic>{
    "isLogined": false
  };
}

Map _logout(Map state, Logout action) {
  return <String, dynamic>{
    "isLogined": false,
    "accessToken": null,
    "username": null
  };
}
