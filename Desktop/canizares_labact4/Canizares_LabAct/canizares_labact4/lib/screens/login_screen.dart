import 'package:canizares_labact4/widgets/custom_dialogs.dart'
    show customDialog;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../providers/auth_provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    with SingleTickerProviderStateMixin {
  // Controllers without default text
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Focus nodes for detecting focus
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  // Focus state
  bool usernameFocused = false;
  bool passwordFocused = false;
  bool _showPassword = false;

  // Animation for logo
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    usernameFocus.addListener(() {
      setState(() {
        usernameFocused = usernameFocus.hasFocus;
      });
    });
    passwordFocus.addListener(() {
      setState(() {
        passwordFocused = passwordFocus.hasFocus;
      });
    });

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Lab 7 Revision: The login function placed under the controllers
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      usernameController.text.trim(),
      passwordController.text,
    );
    if (!mounted) return;
    if (success && authProvider.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(username: authProvider.user!.username),
        ),
        (_) => false,
      );
    } else if (authProvider.errorMessage != null) {
      customDialog(
        context,
        title: 'Login failed',
        content: authProvider.errorMessage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 42.h, 24.w, 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/youdyis logo.png',
                          width: 58.w,
                          height: 58.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'YouDyis',
                        style: TextStyle(
                          color: const Color(0xFFF00707),
                          fontFamily: 'Klavika',
                          fontSize: 38.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 54.h),
                Text(
                  'Welcome back.',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontSize: 31.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF00707),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Your campus, your community, your next idea.',
                  style: TextStyle(fontSize: 15.sp, color: Colors.black54),
                ),
                SizedBox(height: 30.h),
                Container(
                  padding: EdgeInsets.all(22.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        focusNode: usernameFocus,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter your username'
                            : null,
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocus,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _showPassword
                                ? 'Hide password'
                                : 'Show password',
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: context.watch<AuthProvider>().isLoading
                              ? null
                              : login,
                          child: context.watch<AuthProvider>().isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'New to YouDyis? Create an account',
                      style: TextStyle(
                        color: const Color(0xFFF00707),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
