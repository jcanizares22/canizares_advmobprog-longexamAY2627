import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  static const List<Map<String, String>> communityProfiles = [
    {'name': 'Emily Johnson', 'image': 'assets/images/bean.jpg'},
    {'name': 'Jian Villanueva', 'image': 'assets/images/francisleo.png'},
    {'name': 'Penelope Harper', 'image': 'assets/images/kobeprofile.jpg'},
    {'name': 'Mateo Perez', 'image': 'assets/images/snoopdogg.jpg'},
    {'name': 'Charlotte Lopez', 'image': 'assets/images/speed.jpg'},
    {'name': 'Lucas Gray', 'image': 'assets/images/travis.jpg'},
    {'name': 'Mia Santos', 'image': 'assets/images/beanedgar.jpg'},
    {'name': 'Noah Reyes', 'image': 'assets/images/depp.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.isLoading && postProvider.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (postProvider.errorMessage != null && postProvider.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(postProvider.errorMessage!),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: postProvider.fetchPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (postProvider.posts.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }
        return RefreshIndicator(
          onRefresh: postProvider.fetchPosts,
          child: ListView.builder(
            itemCount: postProvider.posts.length,
            itemBuilder: (context, index) {
              return _clickablePost(context, postProvider.posts[index]);
            },
          ),
        );
      },
    );
  }

  Widget _clickablePost(BuildContext context, Post post) {
    final profile =
        communityProfiles[post.userId.abs() % communityProfiles.length];
    final userName = profile['name']!;
    final profileImage = profile['image']!;
    final content = '${post.title}\n\n${post.body}';
    return PostCard(
      onPostTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            postId: post.id,
            userName: userName,
            postContent: content,
            date: 'Post #${post.id}',
            likes: post.likes,
            image: '',
            avatar: profileImage,
          ),
        ),
      ),
      userName: userName,
      postContent: content,
      numOfLikes: post.likes,
      date: 'Post #${post.id}',
      postId: post.id,
      commentUserId: post.userId,
      profileImageUrl: profileImage,
    );
  }
}
