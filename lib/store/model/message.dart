class Message{
  String id;
  String type;
  String authorName;
  String authorAvatar;
  String topicId;
  String topicTitle;
  String replyAt;
  String content;

  Message.fromJson(Map map):
    this.id = map["id"],
    this.type = map["type"],
    this.authorName = map["author"]["loginname"],
    this.authorAvatar = map["author"]["avatar_url"],
    this.topicId = map["topic"]["id"],
    this.topicTitle = map["topic"]["title"],
    this.replyAt = map["reply"]["create_at"],
    this.content = map["reply"]["content"];
}