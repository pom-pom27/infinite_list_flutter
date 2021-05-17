part of 'post_cubit.dart';

enum PostStatus { initial, success, failure }

//TODO: make this class abstract

class PostState extends Equatable {
  const PostState({
    this.status = PostStatus.initial,
    this.hasReachedMax = false,
    this.posts = const <Post>[],
  });

  final PostStatus status;
  final bool hasReachedMax;
  final List<Post> posts;

  PostState copyWith(
      {PostStatus? status, bool? hasReachedMax, List<Post>? posts}) {
    return PostState(
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        posts: posts ?? this.posts);
  }

  @override
  List<Object> get props => [status, hasReachedMax, posts];

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }
}

class PostInitial extends PostState {}
