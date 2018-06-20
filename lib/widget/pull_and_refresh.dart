import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

enum _PullIndicatorStatus {drag, armed}

final double maxDragOffset = 40.0;

class PullAndRefresh extends StatefulWidget{
  final Widget child;

  PullAndRefresh({@required this.child});

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return new _PullAndRefresh();
    }
}

class _PullAndRefresh extends State<PullAndRefresh> {
  double _dragOffset;
  _PullIndicatorStatus _status;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _dragOffset = 0.0;
      _status = _PullIndicatorStatus.drag;
    }
    if (notification is ScrollUpdateNotification) {
      _dragOffset -= notification.scrollDelta;
      if (_status == _PullIndicatorStatus.drag) {
        if (notification.metrics.extentBefore == 0.0 && _dragOffset > maxDragOffset) {
          setState(() {
            _status = _PullIndicatorStatus.armed;
          });
          print('onRefresh');
        }
        if (notification.metrics.extentAfter == 0.0 && _dragOffset < -maxDragOffset) {
          setState(() {
            _status = _PullIndicatorStatus.armed;
          });
          print('onLoadMore');
        }
      }
    }
    if (notification is ScrollEndNotification) {
      setState(() {
        _status = null;
      });
      _dragOffset = null;
    }
    return false;
  }

  @override
    Widget build(BuildContext context) {
      return new NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: widget.child
      );
    }
}