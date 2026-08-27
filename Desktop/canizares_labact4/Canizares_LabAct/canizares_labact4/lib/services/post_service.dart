import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  Future<List<Post>> fetchPosts() async {
    final response = await http
        .get(Uri.parse('$DUMMY_JSON_BASE_URL/posts?limit=30'))
        .timeout(const Duration(seconds: 15));
    return _parsePosts(response);
  }

  Future<List<Post>> fetchPostsByUser(int userId) async {
    final response = await http
        .get(Uri.parse('$DUMMY_JSON_BASE_URL/posts/user/$userId'))
        .timeout(const Duration(seconds: 15));
    final posts = _parsePosts(response);
    if (posts.isNotEmpty) return posts;

    final userPostsResponse = await http
        .get(Uri.parse('$DUMMY_JSON_BASE_URL/users/$userId/posts'))
        .timeout(const Duration(seconds: 15));
    return _parsePosts(userPostsResponse);
  }

  List<Post> _parsePosts(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Unable to load posts (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final posts = data['posts'] as List<dynamic>? ?? const [];
    return posts.whereType<Map<String, dynamic>>().map(Post.fromJson).toList();
  }
}
