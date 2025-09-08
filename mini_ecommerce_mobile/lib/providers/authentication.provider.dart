import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../utils/apiRequests.dart';
import '../utils/storage.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? role;
  String? errorMessage;
  bool _loading = false;

  String? get token => _token;
  bool get isLoading => _loading;
  bool get isAuthenticated => _token?.isNotEmpty ?? false;

  // on reopenning app, check if token is still available msh expired
  Future<void> autoLogin() async {
    final token = await LocalStorage.getToken();
    if (token?.isNotEmpty ?? false) {
      _token = token;
      _setRoleFromToken(token!);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final res = await ApiRequests.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      if (res.statusCode == 200) {
        final token = jsonDecode(res.body)['token'] as String?;
        if (token == null) {
          errorMessage = 'Token unfound';
          return false;
        }

        _token = token;
        _setRoleFromToken(token);
        await LocalStorage.saveToken(token);
        return true;
      } else {
        errorMessage = 'Login failed: ${res.statusCode})';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String email, String password) async {
    _setLoading(true);
    try {
      final res = await ApiRequests.post(
        '/auth/register',
        {
          'email': email,
          'password': password,
        },
      );

      if (res.statusCode == 200) {
        return await login(email, password);
      } else {
        errorMessage = 'Register failed: ${res.statusCode})';
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setRoleFromToken(String token) {
    try {
      final payload = token.split('.')[1];
      final decoded =
          utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final data = jsonDecode(decoded);

      role = data['role'];
    } catch (_) {
      role = null;
    }
  }

  Future<void> logout() async {
    _token = null;
    role = null;
    await LocalStorage.deleteToken();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
