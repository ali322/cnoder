import "package:meta/meta.dart";
import "./model/topic.dart";
import "./model/me.dart";
import "./model/message.dart";

@immutable
class RootState {
  final int tabIndex;
  final Map<String, dynamic> auth;
  final bool isLoading;
  final List<Topic> topics;
  final Map topicsOfCategory;
  final Topic topic;
  final Me me;
  final List<Topic> collects;
  final Map<String, List<Message>> messages;

  RootState({
    this.auth = const {
      "isLogined": false
    },
    this.tabIndex = 0,
    this.isLoading = false,
    this.topics = const [],
    this.topicsOfCategory = const {
      "": {
        "isFetched": false,
        "label": "全部",
        "currentPage": 1,
        "list": []
      },
      "good": {
        "isFetched": false,
        "label": "精华",
        "currentPage": 1,
        "list": []
      },
      "share": {
        "isFetched": false,
        "label": "分享",
        "currentPage": 1,
        "list": []
      },
      "job": {
        "isFetched": false,
        "label": "招聘",
        "currentPage": 1,
        "list": []
      }
    },
    this.topic = const Topic(),
    this.me = const Me(),
    this.collects = const [],
    this.messages = const {}
  });

  static RootState fromJson(dynamic json) {
    return RootState(
      auth: json['auth']
    );
  }

  dynamic toJson() {
    return {
      'auth': auth
    };
  }
}
