import "../model/me.dart";

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
  final Error err;

  ResponseMeFailed(this.err) : super.empty();
}