class Comment {
  final int id;
  final String body;
  final int postId;
  final int userId;
  final int likes;
  final String username;
  final String fullName;

  const Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.userId,
    required this.likes,
    required this.username,
    required this.fullName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return Comment(
      id: json['id'] as int? ?? 0,
      body: json['body'] as String? ?? '',
      postId: json['postId'] as int? ?? 0,
      userId: user['id'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      username: user['username'] as String? ?? '',
      fullName: user['fullName'] as String? ?? '',
    );
  }
}
