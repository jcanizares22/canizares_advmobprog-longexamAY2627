import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> fetchComments(int postId) async {
    final response = await http
        .get(Uri.parse('$DUMMY_JSON_BASE_URL/comments/post/$postId'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Unable to load comments (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final comments = data['comments'] as List<dynamic>? ?? const [];
    return comments
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList();
  }

  Future<Comment> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    final response = await http
        .post(
          Uri.parse('$DUMMY_JSON_BASE_URL/comments/add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Unable to add comment (${response.statusCode})');
    }
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
