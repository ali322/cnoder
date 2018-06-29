import "./topic.dart";

class Me{
  final String username;
  final String createdAt;
  final String avatar;
  final List recentTopics;
  final List recentReplies;

  const Me({
    this.username = '', this.createdAt = '', this.avatar = '', this.recentTopics = const [], this.recentReplies = const []
  });

  Me.fromJson(Map map):
    this.username = map["loginname"],
    this.avatar = map["avatar_url"],
    this.recentTopics = formatRecent(map["recent_topics"]),
    this.recentReplies = formatRecent(map["recent_replies"]),
    this.createdAt = map["create_at"];

  static List<Map> formatRecent(recent) {
    List<Map> topics = [];
    recent.forEach((v) {
      topics.add({
        "id": v["id"],
        "title": v["title"],
        "authorName": v["author"]["loginname"],
        "authorAvatar": v["author"]["avatar_url"],
        "lastReplyAt": v["last_reply_at"]
      });
    });
    return topics;
  }
}