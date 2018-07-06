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
  final bool isCollect;
  final List<Reply> replies;

  const Topic({
    this.authorAvatar = "", this.authorName ="", this.id = "", this.title = "", this.tag = "",this.content = "",
    this.createdAt = "", this.lastReplyAt = "", this.visitCount = 0, this.replyCount = 0,
    this.isCollect = false, this.top = false, this.replies = const []
  });

  static Topic cloneWith(Topic topic, {List<Reply> replies, bool isCollect}) {
    return new Topic(
      id: topic.id,
      authorAvatar: topic.authorAvatar,
      authorName: topic.authorName,
      title: topic.title,
      tag: topic.tag,
      content: topic.content,
      createdAt: topic.createdAt,
      lastReplyAt: topic.lastReplyAt,
      replyCount: topic.replyCount,
      visitCount: topic.visitCount,
      top: topic.top,
      isCollect: isCollect ?? topic.isCollect,
      replies: replies ?? topic.replies
    );
  }

  static List<Reply> formatedReplies(map) {
    List<Reply> _replies = [];
    if (map != null) {
      map.forEach((v) {
        _replies.add(new Reply.fromJson(v));
      });
    }
    return _replies;
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
    this.isCollect = map["is_collect"],
    this.replies = formatedReplies(map['replies']);
}

class Reply{
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String createdAt;
  final bool liked;
  final int ups;

  const Reply({
    this.id = "", this.authorName = "", this.authorAvatar = "", this.content = "", this.createdAt = "", this.liked = false, this.ups = 0
  });

  Reply.fromJson(final Map map):
    this.id = map["id"],
    this.authorName = map["author"]["loginname"],
    this.authorAvatar = map["author"]["avatar_url"],
    this.content = map["content"],
    this.createdAt = fromNow(map["create_at"]),
    this.liked = false,
    this.ups = map["ups"]?.length;

  static Reply cloneWith(Reply reply, [bool liked]) {
    return new Reply(
      id: reply.id,
      authorName: reply.authorName,
      authorAvatar: reply.authorAvatar,
      content: reply.content,
      createdAt: reply.createdAt,
      liked: liked ?? reply.liked,
      ups: liked == null ? reply.ups : (liked ? reply.ups + 1 : reply.ups - 1)
    );
  }
}