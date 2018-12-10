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
  storage: FlutterStorage(key: 'cnoder'),
  serializer: JsonSerializer<RootState>(RootState.fromJson),
  debug: true,
  shouldSave: (Store<RootState> store, dynamic action) {
    if (action is FinishLogin || action is Logout) { 
      return true;
    }
    return false;
  }
);

Future<Store<RootState>> loadStore() async{
  final initialState = await persistor.load();

  final store = new Store<RootState>(rootReducer,
    initialState: initialState ?? new RootState(), 
    middleware: [
      new LoggingMiddleware.printer(), 
      new EpicMiddleware(epic),
      persistor.createMiddleware()
    ]
  );
  return store;
}

