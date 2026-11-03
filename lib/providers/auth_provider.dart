import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/data_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final DataService _dataService;

  AuthProvider(this._dataService);

  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String? _error;
  String _token = '';

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  String get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.role == 'admin';

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');
    if (token != null && userId != null) {
      _token = token;
      try {
        final users = await _dataService.getUsers();
        _user = users.firstWhere((u) => u.id == userId);
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _user = await _dataService.login(email, password);
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token);
      await prefs.setString('user_id', _user!.id);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _user = await _dataService.signup(name, email, password);
      _token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token);
      await prefs.setString('user_id', _user!.id);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _dataService.forgotPassword(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    _user = null;
    _token = '';
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void updateUser(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
