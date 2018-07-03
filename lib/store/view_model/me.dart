import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../root_state.dart";
import "../model/me.dart";

class MeViewModel{
  final Me me;
  final bool isLoading;

  MeViewModel({
    @required this.me, @required this.isLoading 
  });

  static MeViewModel fromStore(Store<RootState> store) {
    return new MeViewModel(
       me: store.state.me,
       isLoading: store.state.isLoading
    );
  }
}