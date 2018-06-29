import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../store/view_model/index.dart";
import "../container/topics.dart";
import "../container/collect.dart";
import "../container/message.dart";
import "../container/me.dart";
import "../container/base.dart";
import "./login.dart";

class IndexScene extends StatefulWidget{
  final IndexViewModel vm;

  IndexScene({Key key, this.vm}):super(key: key);

  @override
    State<StatefulWidget> createState() {
      return new IndexState();
    }
}

class IndexState extends State<IndexScene> {
  List scenes;

  @override
    void initState() {
      super.initState();
      final int tabIndex = widget.vm.tabIndex;
      final bool isLogined = widget.vm.auth["isLogined"];
      scenes = <Widget>[
        new TopicsContainer(vm: widget.vm),
        isLogined ? new CollectContainer(vm: widget.vm) : new LoginScene(),
        isLogined ? new MessageContainer(vm: widget.vm,) : new LoginScene(),
        isLogined ? new MeContainer(vm: widget.vm,) : new LoginScene()
      ];
      final currentScene = scenes[tabIndex];
      if (currentScene is InitializeContainer) {
        if (currentScene.getInitialized() == false) {
          currentScene.initialize();
          currentScene.setInitialized();
        }
      }
    }

  @override
    Widget build(BuildContext context) {
      final bool isLogined = widget.vm.auth["isLogined"];
      final int tabIndex = widget.vm.tabIndex;
      final Function setTab = widget.vm.selectTab;

      return new Scaffold(
        bottomNavigationBar: new CupertinoTabBar(
          activeColor: Colors.green,
          backgroundColor: const Color(0xFFF7F7F7),
          currentIndex: tabIndex,
          onTap: (int i) {
            final currentScene = scenes[i];
            if (isLogined) {
              if (currentScene is InitializeContainer) {
                if (currentScene.getInitialized() == false) {
                  currentScene.initialize();
                  currentScene.setInitialized();
                }
              }
            }
            setTab(i);
          },
          items: <BottomNavigationBarItem>[
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
        body: new IndexedStack(
          children: scenes,
          index: tabIndex,
        )
        
      );
    }
}