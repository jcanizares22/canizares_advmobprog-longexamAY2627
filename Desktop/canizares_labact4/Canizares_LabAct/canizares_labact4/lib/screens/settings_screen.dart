import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _signOut(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LogInScreen()),
      (_) => false,
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Are you sure you want to sign out of YouDyis?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (shouldSignOut == true && context.mounted) {
      await _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();
    final darkMode = themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor: darkMode ? const Color(0xFF11120D) : Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: darkMode ? const Color(0xFF11120D) : null,
        foregroundColor: darkMode ? Colors.white : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: darkMode ? const Color(0xFF24241F) : Colors.white,
            child: ListTile(
              leading: Image.asset(
                'assets/images/NUCCITLogo_Black.png',
                width: 42,
              ),
              title: Text(
                user?.displayName ?? user?.username ?? 'NUCCIT student',
                style: TextStyle(
                  color: darkMode ? Colors.white : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'YouDyis account',
                style: TextStyle(color: darkMode ? Colors.white70 : null),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: darkMode ? const Color(0xFF24241F) : Colors.white,
            child: SwitchListTile(
              secondary: Icon(
                Icons.dark_mode_outlined,
                color: darkMode ? const Color(0xFFF00707) : null,
              ),
              title: Text(
                'Dark mode',
                style: TextStyle(color: darkMode ? Colors.white : null),
              ),
              subtitle: Text(
                'Adjust the reading experience',
                style: TextStyle(color: darkMode ? Colors.white70 : null),
              ),
              value: darkMode,
              activeThumbColor: const Color(0xFFF00707),
              onChanged: themeProvider.setDarkMode,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
