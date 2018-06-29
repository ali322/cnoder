import "../root_state.dart";
import "package:redux_persist/redux_persist.dart";
import "./common.dart";
import "./topic.dart";
import "./login.dart";
import "./me.dart";
import "./collect.dart";
import "./message.dart";

RootState rootReducer(RootState state, action) {
  if (action is PersistLoadedAction<RootState>) {
    return action.state ?? state;
  }
  if (action is PersistErrorAction) {
    print(action.error);
  }
  return new RootState(
    tabIndex: tabReducer(state.tabIndex, action),
    auth:  loginReducer(state.auth, action),
    isLoading: loadingReducer(state.isLoading, action),
    topicsOfCategory: topicsReducer(state.topicsOfCategory, action),
    topic: topicReducer(state.topic, action),
    me: meReducer(state.me, action),
    collects: collectsReducer(state.collects, action),
    messages: messagesReducer(state.messages, action)
  );
}
