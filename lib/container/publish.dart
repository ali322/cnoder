import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/action/action.dart";
import "../store/view_model/publish.dart";
import "../widget/publish.dart";

class PublishContainer extends StatelessWidget{
  final String id;

  PublishContainer({Key key, this.id = ''}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, PublishViewModel>(
        converter: (Store<RootState> store) => PublishViewModel.fromStore(store),
        onInit: (Store<RootState> store) {
          if (id.isNotEmpty) {
            store.dispatch(new ToggleLoading(true));
            store.dispatch(new RequestTopic(id));
          } else {
            store.dispatch(new ClearTopic());
          }
        },
        builder: (BuildContext context, PublishViewModel vm) {
          return new PublishScene(vm: vm, id: id);
        }
      );
    }
}
