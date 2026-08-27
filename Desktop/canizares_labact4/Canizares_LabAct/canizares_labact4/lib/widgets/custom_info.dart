import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/detail_screen.dart';
import 'custom_font.dart';
import '../constants.dart';

class CustomInformation extends StatefulWidget {
  const CustomInformation({
    super.key,

    required this.name,

    required this.post,

    required this.description,

    required this.date,

    this.numOfLikes = 0,

    this.icon = const Icon(Icons.person),

    this.profileImageUrl = '',

    this.imageUrl = '',

    this.atProfile = false,
  });

  final String name;

  final String post;

  final String description;

  final Icon icon;

  final String profileImageUrl;

  final String date;

  final int numOfLikes;

  final String imageUrl;

  final bool atProfile;

  @override
  State<CustomInformation> createState() => _CustomInformationState();
}

class _CustomInformationState extends State<CustomInformation> {
  late int _currentLikes;

  @override
  void initState() {
    super.initState();

    _currentLikes = widget.numOfLikes;
  }

  void _incrementLikes() {
    setState(() {
      _currentLikes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),

      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: InkWell(
          onTap: () {
            if (!widget.atProfile) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    userName: widget.name,
                    postContent: widget.description,
                    likes: _currentLikes,
                    avatar: widget.profileImageUrl,
                    image: widget.imageUrl,
                    date: widget.date,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                widget.profileImageUrl.isEmpty
                    ? widget.icon
                    : CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.asset(
                            widget.profileImageUrl,
                            fit: BoxFit.cover,
                            width: 30.sp,
                            height: 30.sp,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ),

                SizedBox(width: 10.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      CustomFont(
                        text: widget.name,

                        fontSize: 20.sp,

                        color:
                            Theme.of(context).textTheme.bodyLarge?.color ??
                            Colors.black,

                        fontWeight: FontWeight.w800,
                      ),

                      CustomFont(
                        text: 'Posted: ${widget.post}',

                        fontSize: 13.sp,

                        color:
                            Theme.of(context).textTheme.bodyLarge?.color ??
                            Colors.black,
                      ),

                      CustomFont(
                        text: widget.description,

                        fontSize: 12.sp,

                        color:
                            Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.black,

                        fontStyle: FontStyle.italic,
                      ),

                      SizedBox(height: 5.h),

                      CustomFont(
                        text: widget.date,

                        fontSize: 12.sp,

                        color: Colors.grey.shade400,
                      ),

                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          InkWell(
                            onTap: _incrementLikes,

                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,

                                  color: RED_ACCENT,

                                  size: 18.sp,
                                ),

                                SizedBox(width: 4.w),

                                CustomFont(
                                  text: _currentLikes == 0
                                      ? 'Like'
                                      : _currentLikes.toString(),

                                  fontSize: 12.sp,

                                  color: RED_ACCENT,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
