const String apiHost = 'https://cnodejs.org/api/v1';

const Map<String, String> apis = {
  'topics': '$apiHost/topics',
  'topic': '$apiHost/topic',
  "saveTopic": '$apiHost/topics/update',
  'reply2topic': '$apiHost/topic',
  'addCollect': '$apiHost/topic_collect/collect',
  'delCollect': '$apiHost/topic_collect/de_collect',
  'userCollect': '$apiHost/topic_collect',
  'likeReply': '$apiHost/reply',
  'authorize': '$apiHost/accesstoken',
  'user': '$apiHost/user',
  'messages': '$apiHost/messages',
  'messageCount': '$apiHost/message/count',
  'markAllMessage': '$apiHost/message/mark_all',
  'markMessage': '$apiHost/message/mark_one'
};
