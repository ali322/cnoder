import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../store/view_model/index.dart";
import "../container/topics.dart";
import "./collect.dart";
import "./message.dart";
import "./me.dart";
import "./login.dart";

class IndexScene extends StatelessWidget {
  final IndexViewModel vm;

  IndexScene({Key key, this.vm}):super(key: key);

  @override
    Widget build(BuildContext context) {
      final bool isLogined = vm.auth["isLogined"];
      final int tabIndex = vm.tabIndex;
      final Function selectTab = vm.selectTab;

      List<Widget> pages = [
        new TopicsContainer(),
        new CollectScene(),
        new MessageScene(),
        isLogined ? new MeScene() : new LoginScene()
      ];
      return new Scaffold(
        bottomNavigationBar: new CupertinoTabBar(
          activeColor: Colors.green,
          backgroundColor: const Color(0xFFF7F7F7),
          currentIndex: tabIndex,
          onTap: (int i) {
            selectTab(i);
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
          children: pages,
          index: tabIndex,
        )
        
      );
    }
}