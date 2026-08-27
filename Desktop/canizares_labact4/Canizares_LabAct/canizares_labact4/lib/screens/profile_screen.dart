import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Corrected imports based on your project structure
import '../widgets/custom_buttom.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_dialogs.dart';
import 'detail_screen.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final int userId;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _communityProfiles = [
    {'name': 'Emily Johnson', 'image': 'assets/images/bean.jpg'},
    {'name': 'Jian Villanueva', 'image': 'assets/images/francisleo.png'},
    {'name': 'Penelope Harper', 'image': 'assets/images/kobeprofile.jpg'},
    {'name': 'Mateo Perez', 'image': 'assets/images/snoopdogg.jpg'},
    {'name': 'Charlotte Lopez', 'image': 'assets/images/speed.jpg'},
    {'name': 'Lucas Gray', 'image': 'assets/images/travis.jpg'},
    {'name': 'Mia Santos', 'image': 'assets/images/beanedgar.jpg'},
    {'name': 'Noah Reyes', 'image': 'assets/images/depp.jpg'},
  ];
  List<Post> _profilePosts = const [];
  bool _postsLoading = false;
  String? _postsError;
  bool isFollowing = false;
  int followers = 10000000;

  final String profileImageUrl = 'assets/images/NUCCITLogo_Black.png';
  final String coverImageUrl = 'assets/images/owl.jpg';

  String _profileAsset(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? 'assets/images/NUCCITLogo_White.png'
      : profileImageUrl;

  // ===== ABOUT INFO =====
  final String bio = "Building useful ideas with the NUCCIT community.";
  final String birthday = "August 22, 2000";
  final String location = "Manila, Philippines";
  final String course = "BS Information Technology";
  final String school =
      "National University College of Computing and Information Technologies";

  @override
  void initState() {
    super.initState();
    _loadProfilePosts();
  }

  Future<void> _loadProfilePosts() async {
    if (widget.userId <= 0) {
      return;
    }
    setState(() {
      _postsLoading = true;
      _postsError = null;
    });
    try {
      final posts = await context.read<PostProvider>().fetchPostsByUser(
        widget.userId,
      );
      if (!mounted) return;
      setState(() => _profilePosts = posts);
    } catch (_) {
      if (!mounted) return;
      setState(() => _postsError = 'Could not load your posts.');
    } finally {
      if (mounted) setState(() => _postsLoading = false);
    }
  }

  Widget _postsTab() {
    if (_postsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_postsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_postsError!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadProfilePosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_profilePosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 42, color: Colors.grey.shade500),
            const SizedBox(height: 10),
            const Text('No posts found for this user.'),
            const SizedBox(height: 6),
            Text(
              'DummyJSON has no posts assigned to this user ID yet.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h),
      itemCount: _profilePosts.length,
      itemBuilder: (context, index) {
        final post = _profilePosts[index];
        final profile =
            _communityProfiles[post.userId.abs() % _communityProfiles.length];
        final postUserName = post.userId == widget.userId
            ? widget.username
            : profile['name']!;
        final postAvatar = post.userId == widget.userId
            ? _profileAsset(context)
            : profile['image']!;
        final content = '${post.title}\n\n${post.body}';
        return PostCard(
          onPostTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
                postId: post.id,
                userName: postUserName,
                postContent: content,
                likes: post.likes,
                avatar: postAvatar,
                image: '',
                date: 'Post #${post.id}',
              ),
            ),
          ),
          userName: postUserName,
          postContent: content,
          date: 'Post #${post.id}',
          numOfLikes: post.likes,
          profileImageUrl: postAvatar,
          postId: post.id,
          commentUserId: post.userId,
        );
      },
    );
  }

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
      followers += isFollowing ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFollowing
              ? 'You followed ${widget.username}'
              : 'You unfollowed ${widget.username}',
        ),
      ),
    );
  }

  String formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    return count.toString();
  }

  void navigateToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          userName: widget.username,
          postContent: 'TAPOS SAKIN SI KULAONG!',
          likes: 123,
          avatar: profileImageUrl,
          image: 'https://philboxing.com/news/pix/pac.mad.250w.jpg',
          date: 'Just now',
        ),
      ),
    );
  }

  // ===== ABOUT TAB WIDGET =====
  Widget _about() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: "Bio",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
          ),
          SizedBox(height: 6.h),
          CustomFont(
            text: bio,
            fontSize: 14.sp,
            color:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
          SizedBox(height: 20.h),
          _aboutItem(Icons.cake, "Birthday", birthday),
          _aboutItem(Icons.location_on, "Location", location),
          _aboutItem(Icons.school, "Course", course),
          _aboutItem(Icons.account_balance, "School", school),
        ],
      ),
    );
  }

  Widget _aboutItem(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 22.sp),
          SizedBox(width: 12.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFont(
                  text: title,
                  fontSize: 12.sp,
                  color:
                      Theme.of(context).textTheme.bodySmall?.color ??
                      Colors.grey,
                ),
                CustomFont(
                  text: value,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== PHOTOS TAB WIDGET =====
  Widget _photos() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [
        GestureDetector(
          onTap: () => customShowImageDialog(
            context,
            imageUrl: 'https://philboxing.com/news/pix/pac.mad.250w.jpg',
            isAsset: false,
          ),
          child: Image.network(
            'https://philboxing.com/news/pix/pac.mad.250w.jpg',
            fit: BoxFit.cover,
          ),
        ),
        GestureDetector(
          onTap: () => customShowImageDialog(
            context,
            imageUrl: profileImageUrl,
            isAsset: false,
          ),
          child: Image.network(profileImageUrl, fit: BoxFit.cover),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ===== COVER & PROFILE =====
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child: Image.asset(coverImageUrl, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: -50,
                        left: 20.w,
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Theme.of(context).cardColor,
                          child: CircleAvatar(
                            radius: 46.r,
                            backgroundImage: AssetImage(_profileAsset(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),

                  // ===== USER INFO =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: widget.username,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.bodyLarge?.color ??
                              Colors.black,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            CustomFont(
                              text: formatFollowers(followers),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color ??
                                  Colors.black,
                            ),
                            SizedBox(width: 5.w),
                            CustomFont(
                              text: "Followers",
                              fontSize: 14.sp,
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color ??
                                  Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            CustomButton(
                              buttonName: isFollowing ? 'Unfollow' : 'Follow',
                              fontColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                              onPressed: toggleFollow,
                            ),
                            SizedBox(width: 10.w),
                            CustomButton(
                              buttonName: 'Message',
                              fontColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                              backgroundColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Message feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ===== TABS =====
                  SizedBox(height: 20.h),
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    unselectedLabelColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    indicatorColor: Theme.of(context).colorScheme.onSurface,
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'About'),
                      Tab(text: 'Photos'),
                    ],
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(children: [_postsTab(), _about(), _photos()]),
        ),
      ),
    );
  }
}
