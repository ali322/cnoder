import "dart:core";
import "package:flutter/material.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "../store/model/topic.dart";
import "../store/view_model/topic.dart";

class TopicScene extends StatefulWidget{
  final TopicViewModel vm;

  TopicScene({Key key, @required this.vm}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new TopicState();
    }
}

class TopicState extends State<TopicScene> {
  bool _replyVisible = true;
  String _reply = '';

  @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final vm = widget.vm;
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: _renderTitle(context, vm),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.maybePop(context);
          }),
        ),
        body: vm.isLoading ? _renderLoading(context, vm) : _renderDetail(context, vm),
        bottomNavigationBar: _replyVisible ? new Container(
          padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 10.0),
          decoration: const BoxDecoration(
            border: const Border(top: const BorderSide(color: Color(0xFFCCCCCC))),
            color: Color(0xFFF7F7F7)
          ),
          child: new SafeArea(
            bottom: true,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Theme(
                    data: theme.copyWith(primaryColor: Color(0xFFDDDDDD)),
                    child: new TextField(
                      onChanged: (String value) {
                        setState(() {
                          _reply = value;
                        });
                      },
                      decoration: new InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
                        hintStyle: new TextStyle(color: Color(0xFF666666), fontSize: 14.0),
                        hintText: '添加一条新回复'
                      ),
                    ),
                  ),
                ),
                new IconButton(
                  onPressed: () {
                    vm.createReply(vm.topic.id, _reply);
                  },
                  icon: new Icon(Icons.reply, size: 20.0, color: Color(0xFF666666)),
                )
              ],
            )
          ) 
        ) : null,
      );
    }

    Widget _renderTitle(BuildContext context, TopicViewModel vm) {
      final Topic topic = vm.topic;
      if (vm.isLoading) {
        return null;
      }
      return new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
              child: new Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: new Text('${topic.authorName} 发布于 ${topic.createdAt}', style: new TextStyle(color: Colors.white, fontSize: 14.0))
              )
            )
          ]
        ),
      );
    }

    Widget _renderLoading(BuildContext context, TopicViewModel vm) {
      return new Center(
        child: new CircularProgressIndicator(
          strokeWidth: 2.0
        )
      );
    }

    bool _onScrollNotification(ScrollNotification notification) {
      if (notification is ScrollStartNotification) {
        setState(() {
          _replyVisible = false;
        });
      }
      if (notification is ScrollEndNotification) {
        setState(() {
          _replyVisible = true;
        });
      }
      return false;
    }

    Widget _renderDetail(BuildContext context, TopicViewModel vm) {
      final Topic topic = vm.topic;
      return new NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
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
            new Text(reply.createdAt),
          ],
        ),
        trailing: new SizedBox(
          width: 100.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {},
                icon:new Icon(Icons.reply, size: 18.0)
              ),
              new GestureDetector(
                onTap: () {},
                child: new Container(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.thumb_up, size: 15.0),
                      new Text('+${reply.ups}', style: new TextStyle(fontSize: 13.0))
                    ],
                  ),
                )
              )
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