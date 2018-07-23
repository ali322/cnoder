import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "../store/root_state.dart";
import "../store/action/action.dart";
import "../widget/reply.dart";

class ReplyContainer extends StatelessWidget{
  final String id;
  final String replyId;
  final String replyTo;

  ReplyContainer({Key key, @required this.id, this.replyTo = '', this.replyId = ''}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, Function>(
        converter: (Store<RootState> store) {
          return (String id, String content, Function afterCreate) {
            store.dispatch(new StartCreateReply(id, content, afterCreate));
          };
        },
        builder: (BuildContext context, Function createReply) {
          return new ReplyScene(createReply: createReply, id: id, replyTo: replyTo, replyId: replyId);
        }
      );
    }
}