import "package:redux/redux.dart";

enum Actions {Increment}

int counterReducer(int state, dynamic action) {
  switch(action) {
    case Actions.Increment:
      return state + 1;
      break;
    default:
      return state;
  }
}

var store = new Store<int>(counterReducer, initialState: 0);