import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/auth_user.dart';

class AuthService {
  static const _userIdKey = 'auth_user_id';
  static const _usernameKey = 'auth_username';
  static const _firstNameKey = 'auth_first_name';
  static const _lastNameKey = 'auth_last_name';
  static const _tokenKey = 'auth_token';
  static const _registeredAccountsKey = 'registered_accounts';

  Future<AuthUser> login(String username, String password) async {
    final localUser = await _loginRegisteredAccount(username, password);
    if (localUser != null) {
      await saveSession(localUser);
      return localUser;
    }

    final response = await http.post(
      Uri.parse('$DUMMY_JSON_BASE_URL/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Invalid username or password.');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final user = AuthUser.fromJson(data);
    if (user.id == 0 || user.username.isEmpty) {
      throw Exception('The login response was invalid.');
    }
    await saveSession(user);
    return user;
  }

  Future<void> registerAccount({
    required String firstName,
    required String lastName,
    required String username,
    required String mobileNumber,
    required String password,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final accounts = _readAccounts(preferences);
    final usernameExists = accounts.any(
      (account) => account['username'] == username,
    );
    if (usernameExists) {
      throw Exception('That username is already registered.');
    }

    final nextId = accounts.isEmpty
        ? 10001
        : (accounts
                  .map((account) => account['id'] as int? ?? 10000)
                  .reduce((first, second) => first > second ? first : second) +
              1);
    accounts.add({
      'id': nextId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'mobileNumber': mobileNumber,
      'password': password,
    });
    await preferences.setString(_registeredAccountsKey, jsonEncode(accounts));
  }

  Future<AuthUser?> _loginRegisteredAccount(
    String username,
    String password,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final account = _readAccounts(preferences)
        .cast<Map<String, dynamic>?>()
        .firstWhere(
          (item) =>
              item?['username'] == username && item?['password'] == password,
          orElse: () => null,
        );
    if (account == null) return null;
    return AuthUser(
      id: account['id'] as int? ?? 0,
      username: account['username'] as String? ?? username,
      firstName: account['firstName'] as String? ?? '',
      lastName: account['lastName'] as String? ?? '',
    );
  }

  List<Map<String, dynamic>> _readAccounts(SharedPreferences preferences) {
    final rawAccounts = preferences.getString(_registeredAccountsKey);
    if (rawAccounts == null || rawAccounts.isEmpty) return [];
    final decoded = jsonDecode(rawAccounts);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((account) => Map<String, dynamic>.from(account))
        .toList();
  }

  Future<void> saveSession(AuthUser user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_userIdKey, user.id);
    await preferences.setString(_usernameKey, user.username);
    await preferences.setString(_firstNameKey, user.firstName);
    await preferences.setString(_lastNameKey, user.lastName);
    if (user.token != null) {
      await preferences.setString(_tokenKey, user.token!);
    }
  }

  Future<AuthUser?> getSavedSession() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt(_userIdKey);
    final username = preferences.getString(_usernameKey);
    if (userId == null || username == null || username.isEmpty) return null;
    return AuthUser(
      id: userId,
      username: username,
      firstName: preferences.getString(_firstNameKey) ?? '',
      lastName: preferences.getString(_lastNameKey) ?? '',
      token: preferences.getString(_tokenKey),
    );
  }

  Future<void> clearSession() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_userIdKey);
    await preferences.remove(_usernameKey);
    await preferences.remove(_firstNameKey);
    await preferences.remove(_lastNameKey);
    await preferences.remove(_tokenKey);
  }
}
