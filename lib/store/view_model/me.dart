import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../action/action.dart";
import "../root_state.dart";
import "../model/me.dart";

class MeViewModel{
  final Me me;

  MeViewModel({
    @required this.me, 
  });

  static MeViewModel fromStore(Store<RootState> store) {
    return new MeViewModel(
       me: store.state.me,
    );
  }
}