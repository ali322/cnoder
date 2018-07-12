import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../store/view_model/me.dart";
import "./recent_replies.dart";
import "./recent_topics.dart";
import "../container/publish.dart";

class MeScene extends StatelessWidget{
  final MeViewModel vm;

  MeScene({Key key, @required this.vm}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        backgroundColor: Color(0xFFDEDEDE),
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text('我的', style: new TextStyle(color: Colors.white, fontSize: 18.0))
        ),
        body:  vm.isLoading ? _renderLoading(context) : new Column(
          children: <Widget>[
            _renderTitle(context),
            new Divider(
              color: Color(0xFFDEDEDE),
            ),
            _renderMenus(context),
            new Divider(
              color: Color(0xFFDEDEDE),
            ),
            _renderLogout(context)
          ],
        )
      );
    }

  Widget _renderLoading(BuildContext context) {
      return new Center(
        child: new CircularProgressIndicator(
          strokeWidth: 2.0
        )
      );
    }

  Widget _renderTitle(BuildContext context) {
    final me = vm.me;
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
      decoration: new BoxDecoration(
        color: Colors.white
      ),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new CircleAvatar(
            radius: 35.0,
            backgroundImage: new CachedNetworkImageProvider(me.avatar),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(me.username, style: new TextStyle(fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: new Text(me.createdAt, style: new TextStyle(fontSize: 14.0, color: Color(0xFFF666666)))
              )
            ],
            ),
          )
        ],
      )
    );
  }

  Widget _renderMenus(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: new BoxDecoration(
        color: Colors.white
      ),
      child: new ListView(
        shrinkWrap: true,
        children: ListTile.divideTiles(
          context: context, 
          tiles: [
            new ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.note_add, color: Color(0xFF999999)),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child:new Text('新建主题')
                  )
                ],
              ),
              trailing: new Icon(Icons.arrow_forward_ios, size: 14.0),
              onTap: () {
                Navigator.of(context).pushNamed('/publish');
              },
            ),
            new ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.description, color: Color(0xFF999999)),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child:new Text('我的主题')
                  )
                ],
              ),
              trailing: new Icon(Icons.arrow_forward_ios, size: 14.0),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new RecentTopicsScene(topics: vm.me.recentTopics);
                  }
                ));
              },
            ),
            new ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.comment, color: Color(0xFF999999)),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child:new Text('我的回复')
                  )
                ],
              ),
              trailing: new Icon(Icons.arrow_forward_ios, size: 14.0),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new RecentRepliesScene(replies: vm.me.recentReplies);
                  }
                ));
              },
            )
          ]).toList()
      )
    );
  }

  Widget _renderLogout(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Container(
            height: 40.0,
            decoration: new BoxDecoration(
              color: Colors.white
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
            child: new Text('退出登陆', style: new TextStyle(fontSize: 16.0))
          )
        )
      ]
    );
  }
}