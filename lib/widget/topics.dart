import "dart:core";
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import 'package:fluro/fluro.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import "../store/model/root_state.dart";
import "../store/model/topic.dart";
import "../store/action/action.dart";
import "../store/view_model/topics.dart";
import "../config/application.dart";

class TopicsScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new TopicsState();
    }
}

void _noop() {}

class TopicsState extends State<TopicsScene> with TickerProviderStateMixin{
  String _category = "";
  RefreshController _controller;

  @override
    void initState() {
      super.initState();
      Application.store.dispatch(new RequestTopics(afterFetched: _noop));
      _controller = new RefreshController();
    }
    @override
      void dispose() {
        super.dispose();
      }
  @override
    Widget build(BuildContext context) {
      return new StoreConnector<RootState, TopicsViewModel>(
        converter: (Store<RootState> store) => TopicsViewModel.fromStore(store),
        builder: (BuildContext context, TopicsViewModel vm) {
          // if (vm.isLoading == false && vm.topicsOfCategory[_category]["list"].length > 0) {
          //   print('sendBack');
          //   _controller.sendBack(false, RefreshStatus.completed);
          // }
          List<DropdownMenuItem> _menuItems = [];
          vm.topicsOfCategory.forEach((k, v) {
            _menuItems.add(new DropdownMenuItem(
              value: k,
              child: new Text(v["label"]),
            ));
          });
          void _onRefresh(bool up) {
            if (!up) {
              if (vm.isLoading) {
                _controller.sendBack(false, RefreshStatus.idle);
                return;
              }
              vm.fetchTopics(
                currentPage: vm.topicsOfCategory[_category]["currentPage"] + 1,
                category: _category,
                afterFetched: () {
                  _controller.sendBack(false, RefreshStatus.idle);
                }
              );
            } else {
              vm.resetTopics(
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
                Application.router.navigateTo(context, '/publish');
              }),
              title: new DropdownButton(
                value: _category,
                onChanged: (value){
                  setState(() {
                    _category = value;
                  });
                  if (vm.topicsOfCategory[_category]["list"].length == 0){
                    vm.fetchTopics(
                      currentPage: 1,
                      category: _category,
                      afterFetched: _noop
                    );
                  }
                },
                items: _menuItems
              )
            ),
            body: new SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              controller: _controller,
              child: new ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vm.topicsOfCategory[_category]["list"].length,
                itemBuilder: (BuildContext context, int i) => _renderRow(context, vm.topicsOfCategory[_category]["list"][i]),
              ),
            )
          );
        }
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
