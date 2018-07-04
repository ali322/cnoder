import "package:redux/redux.dart";
import "package:redux_epics/redux_epics.dart";
import "package:redux_logging/redux_logging.dart";
import "package:redux_persist/redux_persist.dart";
import "package:redux_persist_flutter/redux_persist_flutter.dart";
import "./action/action.dart";
import "./root_state.dart";
import "./reducer/root.dart";
import "./epic/app.dart";

final epic = combineEpics([
  doLoginEpic, 
  fetchTopicsEpic, fetchTopicEpic, 
  fetchMeEpic,
  fetchCollectsEpic,
  fetchMessagesEpic,
  fetchMessageCountEpic,
  markAllAsReadEpic,
  markAsReadEpic,
  createReplyEpic,
  saveTopicEpic,
  createTopicEpic,
  toggleCollectEpic,
  likeReplyEpic,
]);

final persistor = Persistor<RootState>(
  storage: FlutterStorage('cnoder'),
  decoder: RootState.fromJson,
  debug: true
);

void persistMiddleware(Store store, dynamic action, NextDispatcher next) {
  next(action);
  if (action is FinishLogin || action is Logout) {
    try {
      persistor.save(store);
    } catch (_) {}
  }
}

final store = new Store<RootState>(rootReducer,
  initialState: new RootState(), middleware: [
    new LoggingMiddleware.printer(), 
    new EpicMiddleware(epic),
    persistMiddleware
]);
