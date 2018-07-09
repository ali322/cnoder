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
  bool _isSubmiting = false;
  FocusNode _replyFocusNode;
  TextEditingController _replyController;

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
      final toggleCollect = vm.toggleCollect;
      return new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new Row(
                children: <Widget>[
                  new SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: new CachedNetworkImage(
                      imageUrl: topic.authorAvatar.startsWith('//') ? 'http:${topic.authorAvatar}' : topic.authorAvatar,
                      placeholder: new Image.asset('asset/image/cnoder_avatar.png'),
                      errorWidget: new Icon(Icons.error),
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
                      toggleCollect(topic.id, !topic.isCollect);
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.reply),
                    onPressed: () {
                      _showReplySheet('');
                    },
                  )
                ],
              )
            ),
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
                  _showReplySheet('@${reply.authorName} ');
                },
                icon:new Icon(Icons.reply, size: 18.0)
              ),
              new GestureDetector(
                onTap: () {
                  likeReply(reply.id, !reply.liked);
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

    void _showReplySheet(String value) {
      setState(() {
        _replyController.text = value;
      });
      showModalBottomSheet(context: context, builder: (BuildContext context) => _renderReplySheet(context));
    }

    Widget _renderReplySheet(BuildContext context) {
      final theme = Theme.of(context);
      final createReply = widget.vm.createReply;
      final id = widget.vm.topic.id;
      return new Builder(
        builder: (BuildContext context) {
          final _focusScope = FocusScope.of(context);
          _focusScope.reparentIfNeeded(_replyFocusNode);
          _focusScope.requestFocus(_replyFocusNode);
          return new SafeArea(
            bottom: true,
            child: new Container(
              padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 10.0),
              decoration: const BoxDecoration(
                border: const Border(top: const BorderSide(color: Color(0xFFCCCCCC))),
                color: Color(0xFFF7F7F7)
              ),
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
                    icon: new Icon(Icons.send, color: Color(0xFF666666)),
                  )
                ],
              )
            ),
          );

        }
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