import "../model/topic.dart";

class ToggleLoading {
  final bool isLoading;

  ToggleLoading(this.isLoading);
}

class RequestTopics {}

class ResponseTopics {
  final List<Topic> topics;

  ResponseTopics(this.topics);

  ResponseTopics.empty() : this([]);
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
