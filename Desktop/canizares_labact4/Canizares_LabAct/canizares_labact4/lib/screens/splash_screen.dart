import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();

    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final userFuture = context.read<AuthProvider>().restoreSession();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final user = await userFuture;
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user == null
            ? const LogInScreen()
            : HomeScreen(username: user.username),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF7F7F7), Color(0xFFEFEFEF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset('assets/images/owl.jpg', fit: BoxFit.cover),
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'YouDyis',
                      style: TextStyle(
                        color: const Color(0xFFF00707),
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Klavika',
                        shadows: [
                          Shadow(
                            blurRadius: 15,
                            color: Colors.black.withValues(alpha: 0.25),
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    SizedBox(height: 34.h),
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        color: Color(0xFFF00707),
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
