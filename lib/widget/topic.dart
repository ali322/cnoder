import "dart:core";
import "package:flutter/material.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "../store/model/topic.dart";
import "../store/view_model/topic.dart";

class TopicScene extends StatelessWidget {
  final TopicViewModel vm;

  TopicScene({Key key, @required this.vm}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          title: new Text("详情"),
          leading: new BackButton(),
        ),
        body: vm.isLoading ? _renderLoading(context, vm) : _renderDetail(context, vm)
      );
    }

    Widget _renderLoading(BuildContext context, TopicViewModel vm) {
      return new Center(
        child: new CircularProgressIndicator(
          strokeWidth: 2.0
        )
      );
    }

    Widget _renderDetail(BuildContext context, TopicViewModel vm) {
      final Topic topic = vm.topic;
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new Image.network(topic.authorAvatar.startsWith('//') ? 'http:${topic.authorAvatar}' : topic.authorAvatar)
        ),
        title: new Text(topic.authorName),
        subtitle: new Row(
          children: <Widget>[
            // new Text(DateTime.parse(topic.lastReplyAt).toString().split('.')[0]),
            new Text('share')
          ],
        ),
        trailing: new Text('${topic.replyCount}/${topic.visitCount}'),
      );
      return new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            title,
            new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new Text(topic.title),
            ),
            new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new MarkdownBody(data: topic.content.replaceAll('//dn', 'http://dn')),
            ),
            _renderReplies(context, topic)
          ],
        ),
      );
    }

    Widget _renderReplies(BuildContext context, Topic topic) {
      List<Widget> children = [];
      List<Reply> replies = topic.formatedReplies();
      children.add(new Container(
       height: 20.0,
       decoration: new BoxDecoration(
         color: Colors.grey
       ),
      ));
      children.add(new Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child:new Row(
          children: <Widget>[
            new Text('${replies.length} 回复', style: new TextStyle(color: Colors.grey, fontSize: 14.0))
          ],
        ))
      );
      children.addAll(replies.map((reply) => _renderReply(context, reply)).toList());
      return new Container(
        padding: const EdgeInsets.only(top: 12.0),
        child: new Column(
          children: children
        )
      );
    }

    Widget _renderReply(BuildContext context, Reply reply) {
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new Image.network(reply.authorAvatar.startsWith('//') ? 'http:${reply.authorAvatar}' : reply.authorAvatar),
        ),
        title: new Text(reply.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(DateTime.parse(reply.createdAt).toString().split('.')[0]),
          ],
        ),
        trailing: new SizedBox(
          width: 120.0,
          child: new Row(
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.reply, size: 20.0),
                onPressed: (){},
              ),
              new IconButton(
                icon: new Icon(Icons.thumb_up, size: 15.0),
                onPressed: (){},
              ),
              new Text('+${reply.ups}', style: new TextStyle(fontSize: 13.0))
            ],
          )
        )
        
      );
      return new Column(
        children: <Widget>[
          title,
          new Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: new MarkdownBody(data: reply.content.replaceAll('//dn', 'http://dn'))
          )
        ],
      );
    }
}