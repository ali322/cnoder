import "dart:core";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:cached_network_image/cached_network_image.dart";
import "../store/model/topic.dart";
import "../store/view_model/topics.dart";
import "./persist_tabview.dart";

class TopicsScene extends StatefulWidget{
  final TopicsViewModel vm;

  TopicsScene({Key key, @required this.vm}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new TopicsState();
    }
}

class TopicsState extends State<TopicsScene> with TickerProviderStateMixin{
  RefreshController _refreshController;
  TabController _tabController;
  List<Tab> _tabs;
  VoidCallback _onTabChange;

  @override
  void initState() {
    super.initState();
    final topicsOfCategory = widget.vm.topicsOfCategory;
    _refreshController = new RefreshController();

    _tabs = <Tab>[];
    topicsOfCategory.forEach((k, v) {
      _tabs.add(new Tab(
        text: v["label"]
      ));
    });
    _tabController = new TabController(
      length: _tabs.length,
      vsync: this
    );

    _onTabChange = () {
      final topicsOfCategory = widget.vm.topicsOfCategory;
      final fetchTopics = widget.vm.fetchTopics;
      final currentCategory = topicsOfCategory.keys.toList()[_tabController.index];
      if (topicsOfCategory[currentCategory]['list'].length == 0) {
        fetchTopics(currentPage: 1, category: currentCategory);
      }
    };

    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
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
            placeholder: (BuildContext context,String url) => new Image.asset('asset/image/cnoder_avatar.png'),
            errorWidget: (BuildContext context, String url, Object error) => new Icon(Icons.error),
          )
        )
      ),
      title: new Text(topic.authorName),
      subtitle: new Row(
        children: <Widget>[
          new Text(topic.lastReplyAt)
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

  @override
    Widget build(BuildContext context) {
      bool isLoading = widget.vm.isLoading;
      Map topicsOfCategory = widget.vm.topicsOfCategory;
      FetchTopics fetchTopics = widget.vm.fetchTopics;
      ResetTopics resetTopics = widget.vm.resetTopics;

      final _onRefresh = (String category) {
        return (bool up) {
          if (!up) {
            if (isLoading) {
              _refreshController.sendBack(false, RefreshStatus.idle);
              return;
            }
            fetchTopics(
              currentPage: topicsOfCategory[category]["currentPage"] + 1,
              category: category,
              afterFetched: () {
                _refreshController.sendBack(false, RefreshStatus.idle);
              }
            );
          } else {
            resetTopics(
              category: category,
              afterFetched: () {
                _refreshController.sendBack(true, RefreshStatus.completed);
              }
            );
          }
        };
      };

      List<Widget> _tabViews = [];
      topicsOfCategory.forEach((k, category) {
        bool isFetched = topicsOfCategory[k]["isFetched"];
        _tabViews.add(!isFetched ? _renderLoading(context) : new PersistTabview(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh(k),
            controller: _refreshController,
            child: new ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: topicsOfCategory[k]["list"].length,
              itemBuilder: (BuildContext context, int i) => _renderRow(context, topicsOfCategory[k]["list"][i]),
            ),
          ))
        );
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
        body: new TabBarView(
          controller: _tabController,
          children: _tabViews,
        )
      );
    }
}
