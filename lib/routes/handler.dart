import "dart:core";
import "package:fluro/fluro.dart";
import "package:flutter/material.dart";
import "../store/action/action.dart";
import "../config/application.dart";
import "../widget/topics.dart";
import "../widget/topic.dart";

var handlers = {
  '/': new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    Application.store.dispatch(new RequestTopics());
    return new TopicsScene();
  }),
  '/topic/:id': new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      Application.store.dispatch(new RequestTopic(params['id'][0]));
      return new TopicScene();
    }
  ),
};

var notFoundHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('not found');
});
