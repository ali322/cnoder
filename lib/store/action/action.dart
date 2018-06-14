class ToggleLoading {
  final bool isLoading;

  ToggleLoading(this.isLoading);
}

class RequestTopics {}

class ResponseTopics {
  final List topics;

  ResponseTopics(this.topics);
}

class ResponseTopicsFailed {
  final Error err;

  ResponseTopicsFailed(this.err);
}
