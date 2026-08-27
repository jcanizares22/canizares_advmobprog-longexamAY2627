import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  AuthUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  AuthUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<AuthUser?> restoreSession() async {
    _user = await _authService.getSavedSession();
    notifyListeners();
    return _user;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.login(username, password);
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> register({
    required String firstName,
    required String lastName,
    required String username,
    required String mobileNumber,
    required String password,
  }) async {
    try {
      await _authService.registerAccount(
        firstName: firstName,
        lastName: lastName,
        username: username,
        mobileNumber: mobileNumber,
        password: password,
      );
      return null;
    } catch (error) {
      return error.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> logout() async {
    await _authService.clearSession();
    _user = null;
    notifyListeners();
  }
}
