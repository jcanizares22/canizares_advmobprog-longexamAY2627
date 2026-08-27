import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';

class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final int numOfLikes;
  final String date;

  final String? imageUrl;
  final String? profileImageUrl;

  final bool isAds;
  final String adsMarket;
  final VoidCallback? onAdTap;
  final VoidCallback? onPostTap;
  final int? postId;
  final int commentUserId;

  const PostCard({
    super.key,
    required this.userName,
    this.postContent = '',
    this.numOfLikes = 0,
    this.date = '',
    this.imageUrl,
    this.profileImageUrl,
    this.isAds = false,
    this.adsMarket = '',
    this.onAdTap,
    this.onPostTap,
    this.postId,
    this.commentUserId = 1,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.numOfLikes;
    if (widget.postId != null && widget.postId! > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CommentProvider>().fetchComments(widget.postId!);
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  bool _isNetwork(String? url) =>
      url != null && (url.startsWith('http://') || url.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPostTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),

                if (widget.postContent.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    widget.postContent,
                    maxLines: widget.isAds ? 2 : null,
                    overflow: widget.isAds ? TextOverflow.ellipsis : null,
                  ),
                ],

                /// 🔹 POST IMAGE WITH LOADING EFFECT
                if (widget.imageUrl != null && _isNetwork(widget.imageUrl)) ...[
                  SizedBox(height: 10.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AspectRatio(
                      aspectRatio: widget.isAds ? 16 / 9 : 4 / 3,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl!,
                        fit: BoxFit.cover,

                        /// LOADING
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),

                        /// ERROR
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                /// 🔹 ADS CTA
                if (widget.isAds) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MORE DETAILS',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.adsMarket,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: widget.onAdTap,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: const BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                /// 🔹 NORMAL POST FOOTER
                if (!widget.isAds) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 14,
                        color: Color(0xFFF00707),
                      ),
                      SizedBox(width: 6.w),
                      Text(_currentLikes.toString()),
                    ],
                  ),
                  Divider(height: 20.h),
                  _actionButtons(),
                  if (widget.postId != null && widget.postId! > 0)
                    _commentSection(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 HEADER WITH PROFILE IMAGE LOADING
  Widget _header() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: Colors.grey[300],
          child: ClipOval(
            child:
                widget.profileImageUrl != null &&
                    _isNetwork(widget.profileImageUrl)
                ? CachedNetworkImage(
                    imageUrl: widget.profileImageUrl!,
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  )
                : widget.profileImageUrl != null
                ? Image.asset(
                    widget.profileImageUrl!,
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.contain,
                  )
                : const Icon(Icons.person),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
          label: 'Like',
          onTap: () => setState(() {
            _isLiked = !_isLiked;
            _currentLikes += _isLiked ? 1 : -1;
          }),
        ),
        _ActionButton(
          icon: Icons.comment_outlined,
          label: 'Comment',
          onTap: _focusComment,
        ),
        _ActionButton(icon: Icons.share_outlined, label: 'Share'),
      ],
    );
  }

  Widget _commentSection() {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        final comments = provider.commentsFor(widget.postId!);
        return Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
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
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ],
            ),
            ...comments
                .take(2)
                .map(
                  (comment) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage(
                        _commentAvatars[comment.userId.abs() %
                            _commentAvatars.length],
                      ),
                    ),
                    title: Text(
                      comment.fullName.isEmpty
                          ? comment.username
                          : comment.fullName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      comment.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }

  void _focusComment() {
    if (widget.postId == null || widget.postId! <= 0) return;
    _commentFocusNode.requestFocus();
  }

  Future<void> _submitComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty || widget.postId == null) return;
    try {
      await context.read<CommentProvider>().addComment(
        body: body,
        postId: widget.postId!,
        userId: widget.commentUserId,
      );
      _commentController.clear();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not add comment. Please try again.')),
        );
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            SizedBox(width: 6.w),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
