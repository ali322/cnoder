import "package:flutter/material.dart";

class RecentRepliesScene extends StatelessWidget{
  final List replies;

  RecentRepliesScene({Key key, this.replies}):super(key: key);

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          elevation: 0.0,
          title: new Text('我的回复', style: new TextStyle(color: Colors.white, fontSize: 18.0)),
          leading: new IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0), onPressed: () {
            Navigator.maybePop(context);
          }),
        ),
        body: new ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: replies.length,
          itemBuilder: (BuildContext context, int i) => _renderRow(context, replies[i])
        )
      );
    }

    Widget _renderRow(BuildContext context, Map item) {
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new Image.network(item["authorAvatar"].startsWith('//') ? 'http:${item["authorAvatar"]}' : item["authorAvatar"])
        ),
        title: new Text(item["authorName"]),
        subtitle: new Row(
          children: <Widget>[
            new Text(item["lastReplyAt"])
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
              child: new Text(item["title"])
            )
          ],
        ),
      );
    }
}