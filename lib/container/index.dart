import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/index.dart";
import "../widget/index.dart";

class IndexContainer extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, IndexViewModel>(
        converter: (Store<RootState> store) => IndexViewModel.fromStore(store),
        builder: (BuildContext context, IndexViewModel vm) {
          return new IndexScene(vm: vm);
        },
      );
    }
}