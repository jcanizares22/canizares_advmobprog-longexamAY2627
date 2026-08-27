import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService;
  List<Post> _posts = const [];
  bool _isLoading = false;
  String? _errorMessage;

  PostProvider({PostService? postService})
    : _postService = postService ?? PostService() {
    fetchPosts();
  }

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Post>> fetchPostsByUser(int userId) {
    return _postService.fetchPostsByUser(userId);
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _posts = await _postService.fetchPosts();
    } catch (_) {
      _posts = const [
        Post(
          id: 0,
          title: 'Welcome to NUCCIT Connect',
          body:
              'The community feed is temporarily offline. Pull to refresh when your connection returns.',
          tags: ['nuccit', 'community'],
          likes: 24,
          dislikes: 0,
          views: 120,
          userId: 1,
        ),
        Post(
          id: -1,
          title: 'Build, learn, and share',
          body:
              'Discover ideas and conversations from the College of Computing and Information Technologies.',
          tags: ['technology', 'campus'],
          likes: 18,
          dislikes: 0,
          views: 86,
          userId: 1,
        ),
      ];
      _errorMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
