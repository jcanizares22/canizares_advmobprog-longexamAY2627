import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/comment_provider.dart';

class DetailScreen extends StatefulWidget {
  final int postId;
  final String userName;
  final String postContent;
  final int likes;
  final String avatar;
  final String image;
  final String date;

  const DetailScreen({
    super.key,
    this.postId = 0,
    required this.userName,
    required this.postContent,
    required this.likes,
    required this.avatar,
    required this.image,
    required this.date,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const _commentAvatars = [
    'assets/images/bean.jpg',
    'assets/images/francisleo.png',
    'assets/images/kobeprofile.jpg',
    'assets/images/snoopdogg.jpg',
    'assets/images/speed.jpg',
    'assets/images/travis.jpg',
    'assets/images/beanedgar.jpg',
    'assets/images/depp.jpg',
  ];
  late int _currentLikes;
  bool _isLiked = false;
  final Map<int, bool> _likedComments = {};
  final Map<int, int> _commentLikes = {};
  final TextEditingController _commentController = TextEditingController();
  bool _isAddingComment = false;

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.likes;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<CommentProvider>().fetchComments(widget.postId);
    });
  }

  bool _isNetwork(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _currentLikes += _isLiked ? 1 : -1;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty) return;
    final userId = context.read<AuthProvider>().user?.id ?? 1;
    setState(() => _isAddingComment = true);
    try {
      await context.read<CommentProvider>().addComment(
        body: body,
        postId: widget.postId,
        userId: userId,
      );
      _commentController.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not add comment. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAddingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discussion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// USER HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: widget.avatar.isEmpty
                      ? null
                      : _isNetwork(widget.avatar)
                      ? NetworkImage(widget.avatar)
                      : AssetImage(widget.avatar) as ImageProvider,
                  child: widget.avatar.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// POST CONTENT
            Text(widget.postContent, style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 12),

            /// POST IMAGE
            if (widget.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isNetwork(widget.image)
                    ? Image.network(widget.image)
                    : Image.asset(widget.image),
              ),

            const SizedBox(height: 12),

            /// LIKES + DATE
            Text(
              '$_currentLikes likes • ${widget.date}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        color: _isLiked ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Like',
                        style: TextStyle(
                          color: _isLiked ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.comment_outlined, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Comment', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.share_outlined, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Share', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Community replies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _comments(),
          ],
        ),
      ),
    );
  }

  Widget _comments() {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading(widget.postId)) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorFor(widget.postId) != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.errorFor(widget.postId)!),
              TextButton(
                onPressed: () => provider.fetchComments(widget.postId),
                child: const Text('Retry'),
              ),
            ],
          );
        }
        final comments = provider.commentsFor(widget.postId);
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _addComment(),
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isAddingComment ? null : _addComment,
                  icon: _isAddingComment
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
            if (comments.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('No comments yet.'),
              ),
            ...comments.asMap().entries.map((entry) {
              final comment = entry.value;
              final avatar =
                  _commentAvatars[comment.userId.abs() %
                      _commentAvatars.length];
              final isLiked = _likedComments[comment.id] ?? false;
              final likes = _commentLikes[comment.id] ?? comment.likes;
              return Padding(
                padding: EdgeInsets.only(
                  left: entry.key.isOdd ? 28 : 0,
                  bottom: 10,
                ),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: AssetImage(avatar),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.fullName.isEmpty
                                    ? comment.username
                                    : comment.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(comment.body),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => setState(() {
                                  _likedComments[comment.id] = !isLiked;
                                  _commentLikes[comment.id] =
                                      likes + (isLiked ? -1 : 1);
                                }),
                                borderRadius: BorderRadius.circular(6),
                                child: Row(
                                  children: [
                                    Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 16,
                                      color: Color(0xFFF00707),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Like $likes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFF00707),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
