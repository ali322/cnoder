import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/topics.dart";
import "../widget/topics.dart";

class TopicsContainer extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, TopicsViewModel>(
        converter: (Store<RootState> store) => TopicsViewModel.fromStore(store),
        builder: (BuildContext context, TopicsViewModel vm) {
          return new TopicsScene(vm: vm);
        },
      );
    }
}