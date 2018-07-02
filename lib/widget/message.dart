import "package:flutter/material.dart";
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
    void dispose() {
      super.dispose();
      _tabController.dispose();
    }

  @override
    Widget build(BuildContext context) {
      final messages = widget.vm.messages;
      List<Widget> _renderTabViews() {
        final _tabViews = <Widget>[];
        messages.forEach((k, v) {
          _tabViews.add(new ListView.builder(
            physics: new NeverScrollableScrollPhysics(),
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
      _tabController = new TabController(vsync: this, length: _tabs.length);
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
        body: new TabBarView(
          controller: _tabController,
          children: _renderTabViews(),
        )
      );
    }

    Widget _renderRow(BuildContext context, Message message) {
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new Image.network(message.authorAvatar.startsWith('//') ? 'http:${message.authorAvatar}' : message.authorAvatar)
        ),
        title: new Text(message.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(DateTime.parse(message.replyAt).toString().split('.')[0])
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
            child: new Text(message.content),
          ),
        ],
      );
    }
}