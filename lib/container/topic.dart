import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/model/root_state.dart";
import "../store/view_model/topic.dart";
import "../widget/topic.dart";

class TopicContainer extends StatelessWidget{
  final String id;

  TopicContainer({@required this.id});

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new StoreConnector<RootState, TopicViewModel>(
        converter: (Store<RootState> store) => TopicViewModel.fromStore(store),
        builder: (BuildContext context, TopicViewModel vm) {
          return new TopicScene(id: this.id, vm: vm);
        },
      );
    }
}