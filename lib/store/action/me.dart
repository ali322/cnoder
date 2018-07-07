import "../model/me.dart";
import "package:http/http.dart";

class RequestMe {
  final String username;

  RequestMe(this.username);
}

class ResponseMe {
  final Me me;

  ResponseMe(this.me);

  ResponseMe.empty() : this(new Me());
}

class ResponseMeFailed extends ResponseMe {
  final ClientException err;

  ResponseMeFailed(this.err) : super.empty();
}