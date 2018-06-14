import "package:meta/meta.dart";
import "./topic.dart";


@immutable
class RootState {
  final bool isLoading;
  final List<Topic> topics;
  final Topic topic;

  RootState({
    this.isLoading = false,
    this.topics = const [],
    this.topic = const Topic()
  });
}
