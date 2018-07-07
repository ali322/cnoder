import "../model/topic.dart";
import "package:http/http.dart";

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
  final ClientException err;

  ResponseCollectsFailed(this.err) : super.empty();
}