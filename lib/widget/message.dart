import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "../store/view_model/message.dart";
import "../store/model/message.dart";

class MessageScene extends StatefulWidget{
  final MessagesViewModel vm;

  MessageScene({Key key, @required this.vm}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new MessageState();
    }
}

class MessageState extends State<MessageScene> with TickerProviderStateMixin{
  TabController _tabController;
  List<Tab> _tabs;

  @override
    void initState() {
      super.initState();
      _tabController = new TabController(
          length: 0,
          vsync: this
        );
    }

  @override
    void didUpdateWidget(MessageScene oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (oldWidget.vm.messages.keys.length != widget.vm.messages.keys.length) {
          _tabController = new TabController(
            length: widget.vm.messages.keys.length,
            vsync: this
          );
      }
    }

  @override
    void dispose() {
      super.dispose();
      _tabController.dispose();
    }

  Widget _renderLoading(BuildContext context) {
      return new Center(
        child: new CircularProgressIndicator(
          strokeWidth: 2.0
        )
      );
    }

  @override
    Widget build(BuildContext context) {
      final messages = widget.vm.messages;
      List<Widget> _renderTabViews() {
        final _tabViews = <Widget>[];
        messages.forEach((k, v) {
          _tabViews.add(new ListView.builder(
            // physics: new NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: v.length,
            itemBuilder: (BuildContext context, int i) => _renderRow(context, v[i]),
          ));
        });
        return _tabViews;
      }

      _tabs = <Tab>[];
      messages.keys.forEach((v) {
        _tabs.add(new Tab(text: v == 'read' ? '已读' : '未读'));
      });
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: null,
          title: new Align(
            alignment: Alignment.bottomCenter,
            child: new TabBar(
              labelColor: Colors.white,
              tabs: _tabs,
              controller: _tabController,
            )
          )
        ),
        body: widget.vm.isLoading ? _renderLoading(context) : new TabBarView(
          controller: _tabController,
          children: _renderTabViews(),
        )
      );
    }

    Widget _renderRow(BuildContext context, Message message) {
      ListTile title = new ListTile(
        leading: new Container(
          width: 30.0,
          height: 30.0,
          child: new ClipRRect(
            borderRadius: new BorderRadius.circular(5.0),
            child: new CachedNetworkImage(
              imageUrl: message.authorAvatar.startsWith('//') ? 'http:${message.authorAvatar}' : message.authorAvatar,
              placeholder: (BuildContext context,String url) => new Image.asset('asset/image/cnoder_avatar.png'),
              errorWidget: (BuildContext context, String url, Object error) => new Icon(Icons.error),
            )
          )
        ),
        title: new Text(message.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(message.replyAt)
          ],
        ),
      );
      return new Column(
        children: <Widget>[
          title,
          new Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: new RichText(
              text: new TextSpan(
                text: '评论了 ',
                style: new TextStyle(color: Colors.lightBlue),
                children: <TextSpan>[
                  new TextSpan(text: message.topicTitle, style: DefaultTextStyle.of(context).style)
                ]
              ),
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: new MarkdownBody(data: message.content),
          ),
        ],
      );
    }
}