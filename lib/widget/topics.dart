import "dart:core";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import 'package:fluro/fluro.dart';
import "../store/model/root_state.dart";
import "../store/model/topic.dart";
import "../config/application.dart";

class TopicsScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return new TopicsState();
    }
}

class TopicsState extends State<TopicsScene> with TickerProviderStateMixin{
  TabController _controller;
  List<Tab> _tabs;
  VoidCallback _onTabChange;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _tabs = [
        new Tab(text: '全部'),
        new Tab(text: '问答'),
        new Tab(text: '分享')
      ];
      _controller = new TabController(length:_tabs.length,vsync: this);
      _onTabChange = () {

      };
      _controller.addListener(_onTabChange);
    }
    @override
      void dispose() {
        // TODO: implement dispose
        super.dispose();
        _controller.removeListener(_onTabChange);
        _controller.dispose();
      }
  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('列表'),
          bottom: new TabBar(
            tabs: _tabs,
            controller: _controller,
          ),
        ),
        body: new StoreConnector<RootState, List<Topic>>(
          converter: (Store<RootState> store) {
//            return new List<Topic>();
            return store.state.topics;
            // return store.state.topics;
          },
          builder: (BuildContext context, List<Topic> rows) {
            return new ListView.builder(
              itemCount: rows.length,
              itemBuilder: (BuildContext context, int i) => _renderRow(context, rows[i]),
            );
          },
        ),
        bottomNavigationBar: new CupertinoTabBar(
          onTap: (int i) {
            print(i);
          },
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('主题'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              title: new Text('收藏')
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.message),
              title: new Text('消息')
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.verified_user),
              title: new Text('我的')
            )
          ],
        ),
      );
    }

    Widget _renderRow(BuildContext context, Topic topic) {
      ListTile title = new ListTile(
        leading: new Image.network(topic.authorAvatar.startsWith('//') ? 'http:${topic.authorAvatar}' : topic.authorAvatar),
        title: new Text(topic.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(DateTime.parse(topic.lastReplyAt).toString().split('.')[0]),
            new Text('share')
          ],
        ),
        trailing: new Text('${topic.replyCount}/${topic.visitCount}'),
      );
      return new InkWell(
        onTap: () => Application.router.navigateTo(context, '/topic/?id=${topic.id}', transition: TransitionType.inFromLeft),
        child: new Column(
          children: <Widget>[
            title,
            new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new Text(topic.title),
            )
          ],
        ),
      );
    }
}
