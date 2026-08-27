import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// Importing screens from the correct folder
import 'package:canizares_labact4/screens/login_screen.dart';
import 'package:canizares_labact4/screens/register_screen.dart';
import 'package:canizares_labact4/screens/splash_screen.dart';
import 'package:canizares_labact4/screens/home_screen.dart';
import 'package:canizares_labact4/providers/post_provider.dart';
import 'package:canizares_labact4/providers/auth_provider.dart';
import 'package:canizares_labact4/providers/comment_provider.dart';
import 'package:canizares_labact4/screens/settings_screen.dart';
import 'package:canizares_labact4/providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const FacebookReplication(),
    ),
  );
}

class FacebookReplication extends StatelessWidget {
  const FacebookReplication({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit is required for the .sp, .h, and .w units used in Lab 7
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          title: 'NUCCIT Connect',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFF00707),
              brightness: Brightness.light,
            ),
            fontFamily: 'Frutiger',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF11120D),
              elevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Color(0xFFF00707), width: 1.5),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF00707),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFF00707),
              brightness: Brightness.dark,
            ),
            fontFamily: 'Frutiger',
            scaffoldBackgroundColor: const Color(0xFF11120D),
            cardColor: const Color(0xFF24241F),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF11120D),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF24241F),
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          // Start the app on the Splash Screen as per instructions
          initialRoute: '/splash',
          routes: {
            '/home': (context) {
              final username =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return HomeScreen(username: username ?? '');
            },
            '/login': (context) => const LogInScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
