import "package:redux/redux.dart";
import "package:redux_epics/redux_epics.dart";
import "package:redux_logging/redux_logging.dart";
import "./model/root_state.dart";
import "./reducer/root.dart";
import "./epic/fetch_topics.dart";

//final epic = combineEpics([fetchTopicsEpic]);

final store = new Store<RootState>(rootReducer,
    initialState: new RootState(), middleware: [new LoggingMiddleware.printer(), new EpicMiddleware(fetchTopicsEpic)]);
