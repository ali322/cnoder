import "dart:core";
import "package:flutter/material.dart";
import "package:share/share.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:cached_network_image/cached_network_image.dart";
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

enum MenuType {collect, reply}

class TopicState extends State<TopicScene> with SingleTickerProviderStateMixin{
  @override
    Widget build(BuildContext context) {
      final vm = widget.vm;
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: _renderTitle(context, vm),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.of(context).maybePop();
          }),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (BuildContext context) => _renderMoreSheet(context));
              },
              icon: new Icon(Icons.more_horiz, color: Colors.white),
            )
          ],
        ),
        body: new SafeArea(
          bottom: true,
          child: vm.isLoading ? _renderLoading(context, vm) : _renderDetail(context, vm)
        )
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
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10.0),
                child: new Text(topic.title, style: new TextStyle(color: Colors.white, fontSize: 14.0))
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

    Widget _renderDetail(BuildContext context, TopicViewModel vm) {
      final Topic topic = vm.topic;
      return new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            _renderAuthor(context, vm),
            new Container(
              padding: const EdgeInsets.only(bottom:10.0, left: 10.0, right: 10.0),
              alignment: Alignment.centerLeft,
              child: new MarkdownBody(data: topic.content.replaceAll('//dn', 'http://dn')),
            ),
            _renderReplies(context, topic)
          ],
        ),
      );
    }

    Widget _renderAuthor(BuildContext context, TopicViewModel vm) {
      final toggleCollect = vm.toggleCollect;
      final Topic topic = vm.topic;
      return new Builder(
        builder: (BuildContext context) {
          return new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: 30.0,
                    height: 30.0,
                    child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(5.0),
                      child: new CachedNetworkImage(
                        imageUrl: topic.authorAvatar.startsWith('//') ? 'http:${topic.authorAvatar}' : topic.authorAvatar,
                        placeholder: new Image.asset('asset/image/cnoder_avatar.png'),
                        errorWidget: new Icon(Icons.error),
                      )
                    )
                  ),
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(topic.authorName),
                          new Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: new Text(topic.createdAt, style: new TextStyle(color: Color(0xFF666666), fontSize: 14.0)),
                          )
                        ],
                      )
                    ),
                  ),
                  new IconButton(
                    icon: topic.isCollect ? new Icon(Icons.favorite, color: Colors.red)
                      : new Icon(Icons.favorite_border),
                    onPressed: () {
                      if (!vm.isLogined) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: new Text('请先登录')
                        ));
                      } else {
                        toggleCollect(topic.id, !topic.isCollect);
                      }
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.reply),
                    onPressed: () {
                      if (!vm.isLogined) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: new Text('请先登录')
                        ));
                      } else {
                        Navigator.of(context).pushNamed('/reply/${topic.id}');
                      }
                    },
                  )
                ],
              )
            );
        },
      );
    }

    Widget _renderReplies(BuildContext context, Topic topic) {
      List<Widget> children = [];
      List<Reply> replies = topic.replies;
      children.add(new Container(
       height: 20.0,
       decoration: new BoxDecoration(
         color: Color(0xFFDDDDDD)
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
      children.addAll(replies.map((reply) => _renderReply(context, reply, topic)).toList());
      return new Container(
        padding: const EdgeInsets.only(top: 12.0),
        child: new Column(
          children: children
        )
      );
    }

    Widget _renderReply(BuildContext context, Reply reply, Topic topic) {
      final likeReply = widget.vm.likeReply;
      final isLogined = widget.vm.isLogined;
      ListTile title = new ListTile(
        leading: new Container(
          width: 30.0,
          height: 30.0,
          child: new ClipRRect(
            borderRadius: new BorderRadius.circular(5.0),
            child: new CachedNetworkImage(
              imageUrl: reply.authorAvatar.startsWith('//') ? 'http:${reply.authorAvatar}' : reply.authorAvatar,
              placeholder: new Image.asset('asset/image/cnoder_avatar.png'),
              errorWidget: new Icon(Icons.error),
            )
          )
        ),
        title: new Text(reply.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(reply.createdAt),
          ],
        ),
        trailing: new Builder(
          builder: (BuildContext context) {
            return new SizedBox(
              width: 100.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      if (!isLogined) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: new Text('请先登录')
                        ));
                      } else {
                        Navigator.of(context).pushNamed('/reply/${topic.id}/${reply.id}/${reply.authorName}');
                      }
                    },
                    icon:new Icon(Icons.reply, size: 18.0)
                  ),
                  new GestureDetector(
                    onTap: () {
                      if (!isLogined) {
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: new Text('请先登录')
                        ));
                      } else {
                        likeReply(reply.id, !reply.liked);
                      }
                    },
                    child: new Container(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 6.0),
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.thumb_up, size: 15.0, 
                            color: reply.liked ? Colors.black : Theme.of(context).iconTheme.color
                          ),
                          new Text('+${reply.ups}', style: new TextStyle(fontSize: 13.0, 
                            color: reply.liked ? Colors.black : Theme.of(context).iconTheme.color)
                          )
                        ],
                      )
                    )
                  )
                ],
              )
            );
          }
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

    Widget _renderMoreSheet(BuildContext context) {
      final _topic = widget.vm.topic;
      return new SafeArea(
        bottom: true,
        child: Container(
          height : 100.0,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: new GestureDetector(
                      onTap: () {
                        Share.share(_topic.title);
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Icon(Icons.share, size: 40.0),
                            new Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: new Text('分享', style: new TextStyle(fontSize: 14.0)),
                          )
                        ],
                      ),
                    )
                  )
                ],
              )
            ],
          )
        )
      ); 
    }
}