import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:studyhive/models/user/user_model.dart';
import 'package:studyhive/utils/constants.dart';
import 'package:studyhive/utils/exceptions.dart';

/// Service for authentication-related API calls
class AuthService {
  final http.Client _httpClient;
  final FlutterSecureStorage _secureStorage;

  /// Creates a new AuthService instance
  AuthService({
    http.Client? httpClient,
    FlutterSecureStorage? secureStorage,
  })  : _httpClient = httpClient ?? http.Client(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Gets the stored authentication token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  /// Stores the authentication token
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  /// Removes the stored authentication token
  Future<void> removeToken() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
  }

  /// Checks if the user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Initiates login process with email and password
  /// Returns true if credentials are valid and OTP was sent
  Future<bool> loginInit({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['loginInit']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Store email and password temporarily for the complete step and resend functionality
        await _secureStorage.write(key: 'temp_email', value: email);
        await _secureStorage.write(key: 'temp_password', value: password);
        return true;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: data['message'] ?? AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Completes login process with OTP verification
  Future<UserModel> loginComplete({
    required String token, // OTP token
  }) async {
    try {
      final email = await _secureStorage.read(key: 'temp_email');

      if (email == null) {
        throw ApiException(
          statusCode: 400,
          message: 'Please initiate login again',
        );
      }

      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['loginComplete']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Invalid OTP',
          );
        }

        final accessToken = data['data']['accessToken'] as String;
        final userData = data['data']['user'] as Map<String, dynamic>;

        // Store the token
        await setToken(accessToken);

        // Create user model
        final UserModel user = UserModel(
          id: userData['id'],
          email: userData['email'],
          firstName: userData['first_name'] ?? '',
          lastName: userData['last_name'] ?? '',
          avatar: userData['avatar'],
          createdAt: DateTime.parse(
              userData['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(
              userData['updated_at'] ?? DateTime.now().toIso8601String()),
        );

        // Store user data
        await _secureStorage.write(key: AppConstants.userIdKey, value: user.id);
        await _secureStorage.write(
            key: AppConstants.userEmailKey, value: user.email);
        await _secureStorage.write(
          key: AppConstants.userNameKey,
          value: '${user.firstName} ${user.lastName}',
        );
        if (user.avatar != null) {
          await _secureStorage.write(
              key: AppConstants.userAvatarKey, value: user.avatar);
        }

        // Clean up temporary storage
        await _secureStorage.delete(key: 'temp_email');
        await _secureStorage.delete(key: 'temp_password');

        return user;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        throw ApiException(
          statusCode: response.statusCode,
          message: data['message'] ?? AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Logs in a user with email and password - two-step process
  /// Kept for backward compatibility
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Initialize login
    await loginInit(email: email, password: password);

    // This would be replaced with OTP verification in actual flow
    // For now, just throw an exception to remind developers to use the two-step flow
    throw ApiException(
      statusCode: 400,
      message:
          'Please use loginInit and loginComplete for the two-step authentication flow',
    );
  }

  /// Initiates user registration
  Future<bool> registerInit({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['registerInit']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Store email and password temporarily for the complete step
        await _secureStorage.write(key: 'temp_email', value: email);
        await _secureStorage.write(key: 'temp_password', value: password);
        return true;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: data['message'] ?? AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Completes user registration with OTP verification
  Future<UserModel> registerComplete({
    required String token, // OTP token
    String? firstName,
    String? lastName,
  }) async {
    try {
      final email = await _secureStorage.read(key: 'temp_email');

      if (email == null) {
        throw ApiException(
          statusCode: 400,
          message: 'Please initiate registration again',
        );
      }

      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['registerComplete']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'token': token,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Invalid OTP',
          );
        }

        final accessToken = data['data']['accessToken'] as String;
        final userData = data['data']['user'] as Map<String, dynamic>;

        // Store the token
        await setToken(accessToken);

        // Create user model
        final UserModel user = UserModel(
          id: userData['id'],
          email: userData['email'],
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          avatar: userData['avatar'],
          createdAt: DateTime.parse(
              userData['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(
              userData['updated_at'] ?? DateTime.now().toIso8601String()),
        );

        // Store user data
        await _secureStorage.write(key: AppConstants.userIdKey, value: user.id);
        await _secureStorage.write(
            key: AppConstants.userEmailKey, value: user.email);
        await _secureStorage.write(
          key: AppConstants.userNameKey,
          value: '${user.firstName} ${user.lastName}',
        );
        if (user.avatar != null) {
          await _secureStorage.write(
              key: AppConstants.userAvatarKey, value: user.avatar);
        }

        // Clean up temporary storage
        await _secureStorage.delete(key: 'temp_email');
        await _secureStorage.delete(key: 'temp_password');

        return user;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        throw ApiException(
          statusCode: response.statusCode,
          message: data['message'] ?? AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Registers a new user - two-step process
  /// Kept for backward compatibility
  Future<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? avatar,
  }) async {
    // Initialize registration
    await registerInit(email: email, password: password);

    // This would be replaced with OTP verification in actual flow
    // For now, just throw an exception to remind developers to use the two-step flow
    throw ApiException(
      statusCode: 400,
      message:
          'Please use registerInit and registerComplete for the two-step authentication flow',
    );
  }

  /// Logs out the current user
  Future<bool> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        return true;
      }

      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['logout']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Clear stored data regardless of response
      await removeToken();
      await _secureStorage.delete(key: AppConstants.userIdKey);
      await _secureStorage.delete(key: AppConstants.userEmailKey);
      await _secureStorage.delete(key: AppConstants.userNameKey);
      await _secureStorage.delete(key: AppConstants.userAvatarKey);

      return response.statusCode == 200;
    } catch (e) {
      // Clear stored data even if there's an error
      await removeToken();
      await _secureStorage.delete(key: AppConstants.userIdKey);
      await _secureStorage.delete(key: AppConstants.userEmailKey);
      await _secureStorage.delete(key: AppConstants.userNameKey);
      await _secureStorage.delete(key: AppConstants.userAvatarKey);

      return true;
    }
  }

  /// Gets the current user's profile
  Future<UserModel> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw ApiException(
          statusCode: 401,
          message: AppConstants.unauthorizedErrorMessage,
        );
      }

      final response = await _httpClient.get(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['userProfile']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return UserModel.fromJson(data);
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: json.decode(response.body)['message'] ??
              AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Updates the current user's profile
  Future<UserModel> updateUserProfile({
    String? firstName,
    String? lastName,
    String? avatar,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw ApiException(
          statusCode: 401,
          message: AppConstants.unauthorizedErrorMessage,
        );
      }

      final Map<String, dynamic> updateData = {};
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (avatar != null) updateData['avatar'] = avatar;

      final response = await _httpClient.put(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['updateProfile']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        final UserModel user = UserModel.fromJson(data);

        // Update stored user data
        await _secureStorage.write(
          key: AppConstants.userNameKey,
          value: '${user.firstName} ${user.lastName}',
        );
        if (user.avatar != null) {
          await _secureStorage.write(
              key: AppConstants.userAvatarKey, value: user.avatar);
        }

        return user;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: json.decode(response.body)['message'] ??
              AppConstants.unknownErrorMessage,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Resend OTP for login or registration
  Future<bool> resendOtp({required String email, required bool isLogin}) async {
    try {
      // Get stored password from secure storage
      final password = await _secureStorage.read(key: 'temp_password');

      if (password == null) {
        throw ApiException(
          statusCode: 400,
          message:
              'Session expired. Please restart the login/registration process.',
        );
      }

      if (isLogin) {
        // Reinitialize login
        return await loginInit(email: email, password: password);
      } else {
        // Reinitialize registration
        return await registerInit(email: email, password: password);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }
}
