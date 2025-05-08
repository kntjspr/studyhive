import 'package:flutter/foundation.dart';
import 'package:studyhive/models/user/user_model.dart';
import 'package:studyhive/services/auth_service.dart';

/// Provider for authentication state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  UserModel? _user;

  /// Whether the user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Whether authentication state is loading
  bool get isLoading => _isLoading;

  /// Current user
  UserModel? get user => _user;

  /// Sets the authentication state
  void setAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  /// Sets the loading state
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// Sets the current user
  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  /// Initializes the provider by checking authentication status
  Future<void> initialize() async {
    setLoading(true);
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      setAuthenticated(isAuthenticated);
      
      if (isAuthenticated) {
        final user = await _authService.getUserProfile();
        setUser(user);
      }
    } catch (e) {
      setAuthenticated(false);
      setUser(null);
    } finally {
      setLoading(false);
    }
  }

  /// Logs the user out
  Future<void> logout() async {
    setLoading(true);
    try {
      await _authService.logout();
      setAuthenticated(false);
      setUser(null);
    } finally {
      setLoading(false);
    }
  }
} 