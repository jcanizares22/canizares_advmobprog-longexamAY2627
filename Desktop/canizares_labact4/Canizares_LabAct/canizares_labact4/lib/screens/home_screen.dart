import 'package:canizares_labact4/screens/notifaction_screen.dart';
import 'package:canizares_labact4/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_font.dart';
import '../providers/auth_provider.dart';
import 'package:canizares_labact4/screens/newsfeed_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username; // ✅ STORE IT

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static const Color primaryDark = Color(0xFF11120D);
  static const Color secondaryDark = Color(0xFF565449);
  static const Color surface = Color(0xFFD8CFBC);
  static const Color background = Color(0xFFFFFBF4);

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _getAppBarTitle(Color foregroundColor) {
    if (_selectedIndex == 1) {
      return Text(
        'Notifications',
        style: TextStyle(
          color: foregroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Klavika',
        ),
      );
    } else if (_selectedIndex == 2) {
      return Text(
        widget.username,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Klavika',
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/youdyis logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          CustomFont(
            text: 'YouDyis',
            fontSize: ScreenUtil().setSp(26),
            color: foregroundColor,
            fontFamily: 'Klavika',
            fontWeight: FontWeight.bold,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final pageBackground = isDarkMode ? const Color(0xFF11120D) : background;
    final dividerColor = isDarkMode ? const Color(0xFF3A3932) : surface;
    final foregroundColor = isDarkMode ? Colors.white : primaryDark;
    final unselectedColor = isDarkMode ? Colors.white70 : secondaryDark;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: pageBackground,
        body: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/youdyis logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'YouDyis',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    color: foregroundColor,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 1,
        shadowColor: dividerColor,
        title: _getAppBarTitle(foregroundColor),
        iconTheme: IconThemeData(color: foregroundColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() => _selectedIndex = page);
        },
        children: [
          const NewsFeedScreen(),
          const NotificationScreen(),
          ProfileScreen(
            username: widget.username,
            userId: context.read<AuthProvider>().user?.id ?? 0,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: dividerColor, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: pageBackground,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: foregroundColor,
          unselectedItemColor: unselectedColor,
          onTap: _onTappedBar,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() => _selectedIndex = value);
    _pageController.jumpToPage(value);
  }
}
