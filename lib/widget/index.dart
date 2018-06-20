import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "./topics.dart";
import "./collect.dart";
import "./message.dart";
import "./me.dart";

class IndexScene extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      List<Widget> pages = [
        new TopicsScene(),
        new CollectScene(),
        new MessageScene(),
        new MeScene()
      ];
      // TODO: implement build
      return new CupertinoTabScaffold(
        tabBar: new CupertinoTabBar(
          backgroundColor: const Color(0xFFF7F7F7),
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
        tabBuilder: (BuildContext context, int i) {
          return new CupertinoTabView(
            builder: (BuildContext context) {
              return pages[i];
            }
          );
        },
      );
    }
}