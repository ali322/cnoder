import "../model/message.dart";

class RequestMessages {
  final String accessToken;

  RequestMessages(this.accessToken);
}

class ResponseMessages {
  final Map<String, List<Message>> group;

  ResponseMessages(this.group);

  ResponseMessages.empty() : this({
    "read": [],
    "notRead": []
  });
}

class ResponseMessagesFailed extends ResponseMessages {
  final Error err;

  ResponseMessagesFailed(this.err) : super.empty();
}