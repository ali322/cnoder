import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "dart:async";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/view_model/topic.dart";
import "../store/action/action.dart";
import "../widget/topic.dart";

class TopicContainer extends StatelessWidget{
  final String id;

  TopicContainer({Key key, @required this.id}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, TopicViewModel>(
        converter: (Store<RootState> store) => TopicViewModel.fromStore(store),
        onInit: (Store store) {
          store.dispatch(new ToggleLoading(true));
          new Future.delayed(new Duration(milliseconds: 100), () {
            store.dispatch(new RequestTopic(id));
          });
        },
        builder: (BuildContext context, TopicViewModel vm) {
          return new TopicScene(vm: vm);
        }
      );
    }
}