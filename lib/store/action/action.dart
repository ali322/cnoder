import "../model/topic.dart";
import "package:flutter/foundation.dart";

class ToggleLoading {
  final bool isLoading;

  ToggleLoading(this.isLoading);
}

class RequestTopics {
  final int currentPage;
  final String category;
  final Function afterFetched;

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
