import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "../root_state.dart";
import "../model/topic.dart";

class CollectViewModel{
  final List<Topic> collects;
  final bool isLoading;

  CollectViewModel({
    @required this.collects, 
    @required this.isLoading
  });

  static CollectViewModel fromStore(Store<RootState> store) {
    return new CollectViewModel(
       collects: store.state.collects,
       isLoading: store.state.isLoading
    );
  }
}