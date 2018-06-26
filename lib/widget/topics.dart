import "dart:core";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "../store/model/topic.dart";
import "../store/view_model/topics.dart";

class TopicsScene extends StatefulWidget{
  final TopicsViewModel vm;

  TopicsScene({@required this.vm});

  @override
    State<StatefulWidget> createState() {
      return new TopicsState();
    }
}

class TopicsState extends State<TopicsScene> with TickerProviderStateMixin{
  String _category = "";
  RefreshController _controller;

  @override
  void initState() {
    super.initState();
    widget.vm.fetchTopics();
    _controller = new RefreshController();
  }
  @override
  void dispose() {
    super.dispose();
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
      bool isLoading = widget.vm.isLoading;
      Map topicsOfCategory = widget.vm.topicsOfCategory;
      bool isInit = isLoading && topicsOfCategory[_category]['list'].length == 0;

      FetchTopics fetchTopics = widget.vm.fetchTopics;
      ResetTopics resetTopics = widget.vm.resetTopics;

      List<DropdownMenuItem> _menuItems = [];
      topicsOfCategory.forEach((k, v) {
        _menuItems.add(new DropdownMenuItem(
          value: k,
          child: new Text(v["label"]),
        ));
      });
      void _onRefresh(bool up) {
        if (!up) {
          if (isLoading) {
            _controller.sendBack(false, RefreshStatus.idle);
            return;
          }
          fetchTopics(
            currentPage: topicsOfCategory[_category]["currentPage"] + 1,
            category: _category,
            afterFetched: () {
              _controller.sendBack(false, RefreshStatus.idle);
            }
          );
        } else {
          resetTopics(
            category: _category,
            afterFetched: () {
              _controller.sendBack(false, RefreshStatus.completed);
            }
          );
        }
      }

      return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          leading: new IconButton(icon: new Icon(Icons.add), onPressed: (){
            Navigator.of(context).pushNamed('/publish');
          }),
          title: new DropdownButton(
            value: _category,
            onChanged: (value){
              setState(() {
                _category = value;
              });
              if (topicsOfCategory[_category]["list"].length == 0){
                fetchTopics(
                  currentPage: 1,
                  category: _category
                );
              }
            },
            items: _menuItems
          )
        ),
        body: isInit ? _renderLoading(context) : new SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          controller: _controller,
          child: new ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: topicsOfCategory[_category]["list"].length,
            itemBuilder: (BuildContext context, int i) => _renderRow(context, topicsOfCategory[_category]["list"][i]),
          ),
        )
      );
    }

    Widget _renderRow(BuildContext context, Topic topic) {
      ListTile title = new ListTile(
        leading: new SizedBox(
          width: 30.0,
          height: 30.0,
          child: new Image.network(topic.authorAvatar.startsWith('//') ? 'http:${topic.authorAvatar}' : topic.authorAvatar)
        ),
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
        onTap: () => Navigator.of(context).pushNamed('/topic/${topic.id}'),
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
