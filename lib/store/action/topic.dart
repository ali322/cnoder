import "../model/topic.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart";

class RequestTopics {
  final int currentPage;
  final String category;
  final VoidCallback afterFetched;

  RequestTopics({this.currentPage = 1, this.category = "", @required this.afterFetched});
}

class ResponseTopics {
  final List<Topic> topics;
  final int currentPage;
  final String category;

  ResponseTopics(this.currentPage, this.category, this.topics);

  ResponseTopics.empty() : this(1, "", []);
}

class ResponseTopicsFailed {
  final ClientException err;

  ResponseTopicsFailed(this.err);
}

class RequestTopic {
  final String id;

  RequestTopic(this.id);
}

class ResponseTopic {
  Topic topic;

  ResponseTopic(this.topic);

  ResponseTopic.empty() : this(new Topic());
}

class ResponseTopicFailed extends ResponseTopic {
  final ClientException err;

  ResponseTopicFailed(this.err) : super.empty();
}

class ClearTopic{}

class StartCreateTopic{
  Map<String, String> topic;
  Function afterCreate;

  StartCreateTopic(this.topic, this.afterCreate);
}

class FinishCreateTopic{
  String id;

  FinishCreateTopic(this.id);

  FinishCreateTopic.failed():this("");
}

class FinishCreateTopicFailed extends FinishCreateTopic{
  final ClientException err;

  FinishCreateTopicFailed(this.err): super.failed();
}

class StartSaveTopic{
  Map<String, String> topic;
  Function afterSave;

  StartSaveTopic(this.topic, this.afterSave);
}

class FinishSaveTopic{
  String id;
  
  FinishSaveTopic(this.id);

  FinishSaveTopic.failed():this("");
}

class FinishSaveTopicFailed extends FinishSaveTopic{
  final ClientException err;

  FinishSaveTopicFailed(this.err): super.failed();
}

class StartCreateReply{
  String id;
  String content;
  Function afterCreate;

  StartCreateReply(this.id, this.content, this.afterCreate);
}

class FinishCreateReply{
  String id;

  FinishCreateReply(this.id);

  FinishCreateReply.failed():this("");
}

class FinishCreateReplyFailed extends FinishCreateReply{
  final ClientException err;

  FinishCreateReplyFailed(this.err): super.failed();
}

class StartToggleCollect{
  String id;
  bool status;

  StartToggleCollect(this.id, this.status);
}

class FinishToggleCollect{
  bool status;

  FinishToggleCollect(this.status);

  FinishToggleCollect.failed(): this(false);
}

class FinishToggleCollectFailed extends FinishToggleCollect{
  final ClientException err;

  FinishToggleCollectFailed(this.err):super.failed();
}

class StartLikeReply{
  String id;
  bool status;

  StartLikeReply(this.id, this.status);
}

class FinishLikeReply{
  String id;
  bool status;

  FinishLikeReply(this.id, this.status);

  FinishLikeReply.failed(): this("", false);
}

class FinishLikeReplyFailed extends FinishLikeReply{
  final ClientException err;

  FinishLikeReplyFailed(this.err):super.failed();
}