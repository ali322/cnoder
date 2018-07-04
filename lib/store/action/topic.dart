import "../model/topic.dart";
import "package:flutter/foundation.dart";

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
  final Error err;

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
  final Error err;

  ResponseTopicFailed(this.err) : super.empty();
}

class ClearTopic{}

class StartCreateTopic{
  Map<String, String> topic;
  Function afterCreated;

  StartCreateTopic(this.topic, this.afterCreated);
}

class FinishCreateTopic{
  String id;

  FinishCreateTopic(this.id);

  FinishCreateTopic.failed():this("");
}

class FinishCreateTopicFailed extends FinishCreateTopic{
  final Error err;

  FinishCreateTopicFailed(this.err): super.failed();
}

class StartSaveTopic{
  Map<String, String> topic;

  StartSaveTopic(this.topic);
}

class FinishSaveTopic{
  String id;

  FinishSaveTopic(this.id);

  FinishSaveTopic.failed():this("");
}

class FinishSaveTopicFailed extends FinishSaveTopic{
  final Error err;

  FinishSaveTopicFailed(this.err): super.failed();
}

class StartCreateReply{
  String id;
  String content;

  StartCreateReply(this.id, this.content);
}

class FinishCreateReply{
  String id;

  FinishCreateReply(this.id);

  FinishCreateReply.failed():this("");
}

class FinishCreateReplyFailed extends FinishCreateReply{
  final Error err;

  FinishCreateReplyFailed(this.err): super.failed();
}

class StartToggleCollect{
  String id;
  bool status;

  StartToggleCollect(this.id, this.status);
}

class FinishToggleCollect{
  bool success;

  FinishToggleCollect(this.success);

  FinishToggleCollect.failed(): this(false);
}

class FinishToggleCollectFailed extends FinishToggleCollect{
  final Error err;

  FinishToggleCollectFailed(this.err):super.failed();
}

class StartLikeReply{
  String id;

  StartLikeReply(this.id);
}

class FinishLikeReply{
  bool success;
  String action;

  FinishLikeReply(this.success, this.action);

  FinishLikeReply.failed(): this(false, '');
}

class FinishLikeReplyFailed extends FinishLikeReply{
  final Error err;

  FinishLikeReplyFailed(this.err):super.failed();
}