import 'package:flutter/foundation.dart';

import '../models/comment.dart';
import '../services/comment_service.dart';

class CommentProvider extends ChangeNotifier {
  final CommentService _commentService;
  final Map<int, List<Comment>> _comments = {};
  final Set<int> _loadingPostIds = {};
  final Map<int, String> _errors = {};

  CommentProvider({CommentService? commentService})
    : _commentService = commentService ?? CommentService();

  List<Comment> commentsFor(int postId) => _comments[postId] ?? const [];
  bool isLoading(int postId) => _loadingPostIds.contains(postId);
  String? errorFor(int postId) => _errors[postId];

  Future<void> fetchComments(int postId) async {
    _loadingPostIds.add(postId);
    _errors.remove(postId);
    notifyListeners();
    try {
      _comments[postId] = await _commentService.fetchComments(postId);
    } catch (_) {
      _comments[postId] = const [];
      _errors[postId] = 'Could not load comments. Please try again.';
    } finally {
      _loadingPostIds.remove(postId);
      notifyListeners();
    }
  }

  Future<void> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    final comment = await _commentService.addComment(
      body: body,
      postId: postId,
      userId: userId,
    );
    _comments[postId] = [...commentsFor(postId), comment];
    notifyListeners();
  }
}
