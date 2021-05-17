import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinity_list/posts/models/models.dart';
import 'package:http/http.dart' as http;

part 'post_state.dart';

const _postLimit = 20;

class PostCubit extends Cubit<PostState> {
  PostCubit({required this.httpClient}) : super(PostInitial());

  final http.Client httpClient;

  void getPosts() async {
    emit(await _getFetchedPost());
  }

  Future<PostState> _getFetchedPost() async {
    if (state.hasReachedMax) {
      return state;
    }

    try {
      if (state.status == PostStatus.initial) {
        final fetchedPosts = await _fetchPosts();
        if (fetchedPosts.length <= 10) {
          return state.copyWith(
              status: PostStatus.success,
              posts: fetchedPosts,
              hasReachedMax: true);
        }

        return state.copyWith(
            status: PostStatus.success,
            posts: fetchedPosts,
            hasReachedMax: false);
      }

      final List<Post> posts = await _fetchPosts(state.posts.length);

      return posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false);
    } on Exception {
      return state.copyWith(status: PostStatus.success);
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'}));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;

      return body
          .map(
            (json) => Post(
              id: json['id'] as int,
              title: json['title'] as String,
              body: json['body'] as String,
            ),
          )
          .toList();
    }
    throw Exception('Error fetching posts');
  }
}
