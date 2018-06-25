import "dart:core";
import "package:fluro/fluro.dart";
import "package:redux/redux.dart";
import "package:flutter/material.dart";
import "../store/action/action.dart";
import "../widget/index.dart";
import "../widget/publish.dart";
import "../container/topic.dart";

Map<String, Handler> handlers = {
  '/': new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new IndexScene();
  }),
  '/topic/:id': new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new TopicContainer(id: params['id'][0]);
    }
  ),
  '/publish': new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PublishScene();
  })
};

var notFoundHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('not found');
});
