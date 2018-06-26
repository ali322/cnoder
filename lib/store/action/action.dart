import "../model/topic.dart";
import "package:flutter/foundation.dart";

class SelectTab{
  final int index;

  SelectTab(this.index);
}

class StartLogin{
  final String accessToken;
  final VoidCallback afterFinished;

  StartLogin(this.accessToken, this.afterFinished);
}

class FinishLogin{
  final String accessToken;
  final String username;
  final String avatar;

  FinishLogin({this.accessToken, this.username, this.avatar});

  FinishLogin.empty(): this(accessToken: '', username: '', avatar: '');
}

class FinishLoginFailed extends FinishLogin{
  final Error err;

  FinishLoginFailed(this.err): super.empty();
}

class Logout{}

class ToggleLoading {
  final bool isLoading;

  ToggleLoading(this.isLoading);
}

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
