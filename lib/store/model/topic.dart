import "../../common/helper.dart";

class Topic {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String title;
  final String tag;
  final String content;
  final String createdAt;
  final String lastReplyAt;
  final int replyCount;
  final int visitCount;
  final bool top;
  final List replies;

  const Topic({
    this.authorAvatar = "", this.authorName ="", this.id = "", this.title = "", this.tag = "",this.content = "", this.createdAt = "", this.lastReplyAt = "", this.visitCount = 0, this.replyCount = 0, this.top = false, this.replies = const []
  });

  List<Reply> formatedReplies() {
    List<Reply> replies = [];
    this.replies.forEach((v) {
      replies.add(new Reply.fromJson(v));
    });
    return replies;
  }

  Topic.fromJson(final Map map):
    this.id = map["id"],
    this.authorName = map["author"]["loginname"],
    this.authorAvatar = map["author"]["avatar_url"],
    this.title = map["title"],
    this.tag = map["tab"],
    this.content = map["content"],
    this.createdAt = fromNow(map["create_at"]),
    this.lastReplyAt = fromNow(map["last_reply_at"]),
    this.replyCount = map["reply_count"],
    this.visitCount = map["visit_count"],
    this.top = map["top"],
    this.replies = map['replies'];
}

class Reply{
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String createdAt;
  final int ups;

  Reply.fromJson(final Map map):
    this.id = map["id"],
    this.authorName = map["author"]["loginname"],
    this.authorAvatar = map["author"]["avatar_url"],
    this.content = map["content"],
    this.createdAt = fromNow(map["create_at"]),
    this.ups = map["ups"]?.length;
}