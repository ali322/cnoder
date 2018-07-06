import "dart:core";
import "package:flutter/material.dart";
import "package:share/share.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../store/model/topic.dart";
import "../store/view_model/topic.dart";
import "../store/root_state.dart";

class TopicScene extends StatefulWidget{
  final TopicViewModel vm;

  TopicScene({Key key, @required this.vm}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new TopicState();
    }
}

enum MenuType {collect, reply}

class TopicState extends State<TopicScene> {
  bool _replyVisible = true;
  bool _isSubmiting = false;
  FocusNode _replyFocusNode;
  TextEditingController _replyController;
  VoidCallback _onReplyChange;

  @override
    void initState() {
      super.initState();
      _replyFocusNode = new FocusNode();
      _replyController = new TextEditingController();
    }

  @override
    void dispose() {
      super.dispose();
      _replyFocusNode.dispose();
      _replyController.dispose();
    }

  @override
    Widget build(BuildContext context) {
      final vm = widget.vm;
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: _renderTitle(context, vm),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.maybePop(context);
          }),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (BuildContext context) => _renderBottomSheet(context));
                // _bottomSheetController.setState(() {});
              },
              icon: new Icon(Icons.more_horiz, color: Colors.white),
            )
          ],
        ),
        body: vm.isLoading ? _renderLoading(context, vm) : _renderDetail(context, vm),
        bottomNavigationBar: _renderReplyFrame()
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
                child: new Text('${topic.authorName} 发布于 ${topic.createdAt}', style: new TextStyle(color: Colors.white, fontSize: 14.0))
              )
            )
          ]
        ),
      );
    }

    Widget _renderReplyFrame() {
      final theme = Theme.of(context);
      final createReply = widget.vm.createReply;
      final id = widget.vm.topic.id;
      if (_replyVisible) {
        return new Builder(
          builder: (BuildContext context) {
            return new Container(
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
                            controller: _replyController,
                            onChanged: (v) => _replyController.text = v,
                            focusNode: _replyFocusNode,
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
                        onPressed: _isSubmiting ? null : () {
                          setState(() {
                            _isSubmiting = true;
                          });
                          createReply(id, _replyController.text, (bool success, String errMsg) {
                            setState(() {
                              _isSubmiting = false;
                            });
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(success ? '添加回复成功' : errMsg),
                            ));
                          });
                        },
                        icon: new Icon(Icons.reply, size: 20.0, color: Color(0xFF666666)),
                      )
                    ],
                  )
                ) 
              );
          }
        );
      }
      return null;
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
      List<Reply> replies = topic.replies;
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
      final likeReply = widget.vm.likeReply;
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new CachedNetworkImage(
            imageUrl: reply.authorAvatar.startsWith('//') ? 'http:${reply.authorAvatar}' : reply.authorAvatar,
            placeholder: new Image.asset('asset/image/cnoder_avatar.png'),
            errorWidget: new Icon(Icons.error),
          )
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
                onPressed: () {
                  setState(() {
                    _replyController.text = '@${reply.authorName} ';
                  });
                  FocusScope.of(context).requestFocus(_replyFocusNode);
                },
                icon:new Icon(Icons.reply, size: 18.0)
              ),
              new GestureDetector(
                onTap: () {
                  likeReply(reply.id, !reply.liked);
                },
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

    Widget _renderBottomSheet(BuildContext context) {
      final _topic = widget.vm.topic;
      final toggleCollect = widget.vm.toggleCollect;

      return new StoreConnector<RootState, Topic>(
        converter: (Store<RootState> store) => store.state.topic,
        builder: (BuildContext context, Topic _newTopic) {
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
                            toggleCollect(_newTopic.id, !_newTopic.isCollect);
                          },
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _newTopic.isCollect ? new Icon(Icons.favorite, size: 40.0, color: Colors.red)
                              : new Icon(Icons.favorite_border, size: 40.0),
                              new Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: new Text('收藏', style: new TextStyle(fontSize: 14.0)),
                              )
                            ],
                          ),
                        )
                      ),
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
      );
    }
}