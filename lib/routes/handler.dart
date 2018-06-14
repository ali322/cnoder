import "package:fluro/fluro.dart";
import "package:flutter/material.dart";
import "../widget/topics.dart";

var handlers = {
  '/': new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new Topics();
  })
};

var notFoundHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('not found');
});
