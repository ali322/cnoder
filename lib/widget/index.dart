import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../container/topics.dart";
import "./collect.dart";
import "./message.dart";
import "./me.dart";

class IndexScene extends StatefulWidget{
  @override
    State<StatefulWidget> createState() {
      return new IndexState();
    }
}

class IndexState extends State<IndexScene> {
  int _tabIndex = 0;

  @override
    Widget build(BuildContext context) {
      List<Widget> pages = [
        new TopicsContainer(),
        new CollectScene(),
        new MessageScene(),
        new MeScene()
      ];
      return new Scaffold(
        bottomNavigationBar: new CupertinoTabBar(
          activeColor: Colors.green,
          backgroundColor: const Color(0xFFF7F7F7),
          currentIndex: _tabIndex,
          onTap: (int i) {
            setState(() {
              _tabIndex = i;
            });
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
          index: _tabIndex,
        )
        
      );
    }
}