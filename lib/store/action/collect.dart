import "../model/topic.dart";

class RequestCollects {
  final String username;

  RequestCollects(this.username);
}

class ResponseCollects {
  final List<Topic> topics;

  ResponseCollects(this.topics);

  ResponseCollects.empty() : this([]);
}

class ResponseCollectsFailed extends ResponseCollects {
  final Error err;

  ResponseCollectsFailed(this.err) : super.empty();
}