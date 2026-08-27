import '../widgets/custom_info.dart' as notif;
import 'package:flutter/material.dart';

// --- Data Model for Notifications (Enhancement 1 & 3) ---
class NotificationData {
  final String name;
  final String post;
  final String description;
  final String date;
  int valueCount; // mutable to track likes
  final bool hasPlaceholder;
  final String? profileImageUrl; // Enhancement 2

  NotificationData({
    required this.name,
    required this.post,
    required this.description,
    required this.date,
    required this.valueCount,
    this.hasPlaceholder = false,
    this.profileImageUrl,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dynamic App Name (Enhancement 2)
  final String appName = 'NotifApp';

  // General Enhancement: Dynamic List of Notifications
  final List<NotificationData> _notifications = [
    NotificationData(
      name: 'Thiago Wallace',
      post: 'Project Alpha',
      description: 'Mentioned you in a comment.',
      date: 'Dec 9',
      valueCount: 5,
    ),
    NotificationData(
      name: 'Pablo Escobar',
      post: 'Task 101',
      description: 'Assigned 2 new values to the post.',
      date: 'Dec 8',
      valueCount: 2,
      hasPlaceholder: true,
    ),
    NotificationData(
      name: 'Odamart',
      post: 'Design Mockup',
      description: 'Shared a new file with you.',
      date: 'Dec 8',
      valueCount: 10,
    ),
    NotificationData(
      name: 'Ugay',
      post: 'Server Update',
      description: 'Liked your latest post.',
      date: 'Dec 7',
      valueCount: 1,
    ),
    NotificationData(
      name: 'Lucas Bryce',
      post: 'Code Review',
      description: 'Requested changes on pull request.',
      date: 'Dec 6',
      valueCount: 8,
      hasPlaceholder: true,
    ),
    NotificationData(
      name: 'Paul Cordez',
      post: 'Marketing Plan',
      description: 'Added you to a new group chat.',
      date: 'Dec 5',
      valueCount: 3,
    ),
    NotificationData(
      name: 'Justin To',
      post: 'Q3 Report',
      description: 'Uploaded the final Q3 report.',
      date: 'Dec 4',
      valueCount: 1,
    ),
    NotificationData(
      name: 'Kobe Sapugay',
      post: 'Team Lunch',
      description: 'Confirmed attendance for team lunch.',
      date: 'Dec 3',
      valueCount: 4,
      hasPlaceholder: true,
    ),
    NotificationData(
      name: 'Torrefiel',
      post: 'JS Framework',
      description: 'Sent you a direct message.',
      date: 'Dec 2',
      valueCount: 6,
    ),
    NotificationData(
      name: 'MJ Saquido',
      post: 'UX Research',
      description: 'Invited you to view the research findings.',
      date: 'Dec 1',
      valueCount: 7,
    ),
    NotificationData(
      name: 'Mercado Brothers',
      post: 'Comedy Skit',
      description: 'Posted a new photo.',
      date: 'Nov 30',
      valueCount: 2,
    ),
    NotificationData(
      name: 'Erikson',
      post: 'Daily Planet',
      description: 'Followed you.',
      date: 'Nov 29',
      valueCount: 9,
      hasPlaceholder: true,
    ),
    NotificationData(
      name: 'Simpao',
      post: 'Boxing Match',
      description: 'Reacted to your story.',
      date: 'Nov 28',
      valueCount: 1,
    ),
    NotificationData(
      name: 'Mayong',
      post: 'Mystery Case',
      description: 'Shared their location with you.',
      date: 'Nov 27',
      valueCount: 3,
    ),
    NotificationData(
      name: 'Toto Palaka',
      post: 'New Novel',
      description: 'Updated their profile picture.',
      date: 'Nov 26',
      valueCount: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$appName (${_notifications.length} New)'),
        backgroundColor: Color.fromARGB(255, 240, 7, 7),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];

            // Dynamic Description Formatting
            String dynamicDescription =
                '${notification.description} (Values: ${notification.valueCount}, Date: ${notification.date}).';
            if (notification.hasPlaceholder) {
              dynamicDescription += ' Placeholder is present.';
            }

            return Column(
              children: [
                notif.CustomInformation(
                  name: notification.name,
                  post: notification.post,
                  description: dynamicDescription,
                  date: notification.date,
                  numOfLikes: notification.valueCount,
                  profileImageUrl: notification.profileImageUrl ?? '',
                  imageUrl: '', // can pass image url if available
                  atProfile: false,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 15,
                  endIndent: 15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
