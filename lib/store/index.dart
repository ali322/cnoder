import "package:redux/redux.dart";
import "package:redux_epics/redux_epics.dart";
import "package:redux_logging/redux_logging.dart";
import "./model/root_state.dart";
import "./reducer/root.dart";
import "./epic/topic.dart";

final epic = combineEpics([fetchTopicsEpic, fetchTopicEpic]);

final store = new Store<RootState>(rootReducer,
    initialState: new RootState(), middleware: [
      // new LoggingMiddleware.printer(), 
      new EpicMiddleware(epic)
    ]);
