import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../store/view_model/collect.dart";
import "../store/model/topic.dart";

class CollectScene extends StatelessWidget{
  final CollectViewModel vm;

  CollectScene({Key key, @required this.vm}):super(key: key);


  @override
    Widget build(BuildContext context) {
      final topics = vm.collects;
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text('收藏', style: new TextStyle(color: Colors.white, fontSize: 18.0)),
        ),
        body: vm.isLoading ? _renderLoading(context) : new ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: topics.length,
          itemBuilder: (BuildContext context, int i) => _renderRow(context, topics[i])
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

    Widget _renderRow(BuildContext context, Topic topic) {
      ListTile title = new ListTile(
        leading: new Container(
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
        title: new Text(topic.authorName),
        subtitle: new Row(
          children: <Widget>[
            new Text(topic.lastReplyAt)
          ],
        ),
      );
      return new InkWell(
        child: new Column(
          children: <Widget>[
            title,
            new Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: new Text(topic.title)
            )
          ],
        ),
      );
    }
}