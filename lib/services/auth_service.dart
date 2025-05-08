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

  /// Logs in a user with email and password
  Future<UserModel> login({
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Invalid credentials',
          );
        }

        // Extract user and token data
        final userData = data['data']['user'] as Map<String, dynamic>;
        final accessToken = data['data']['session']['access_token'] as String;
        final refreshToken = data['data']['session']['refresh_token'] as String;

        // Store the tokens
        await setToken(accessToken);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);

        // Create user model
        final UserModel user = UserModel(
          id: userData['id'].toString(),
          email: userData['email'],
          firstName: userData['first_name'] ?? '',
          lastName: userData['last_name'] ?? '',
          avatar: userData['avatar'],
          createdAt: DateTime.now(), // Use current time if not provided
          updatedAt: DateTime.now(), // Use current time if not provided
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

  /// Starts the registration process and sends OTP to email
  Future<String> registerInit({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
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
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Registration initialization failed',
          );
        }

        // Store email temporarily for the complete step
        await _secureStorage.write(key: 'temp_email', value: email);
        await _secureStorage.write(key: 'temp_password', value: password);
        if (firstName != null) {
          await _secureStorage.write(key: 'temp_first_name', value: firstName);
        }
        if (lastName != null) {
          await _secureStorage.write(key: 'temp_last_name', value: lastName);
        }

        return data['message'] ?? 'Verification code sent to your email';
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

  /// Completes the registration process with OTP verification
  Future<UserModel> registerComplete({
    required String token,
  }) async {
    try {
      // Get stored temporary data
      final email = await _secureStorage.read(key: 'temp_email');
      
      if (email == null) {
        throw ApiException(
          statusCode: 400,
          message: 'Missing registration data. Please start the registration process again.',
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
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Registration verification failed',
          );
        }

        // Extract user and token data
        final userData = data['data']['user'] as Map<String, dynamic>;
        final accessToken = data['data']['session']['access_token'] as String;
        final refreshToken = data['data']['session']['refresh_token'] as String;

        // Store the tokens
        await setToken(accessToken);
        await _secureStorage.write(key: 'refresh_token', value: refreshToken);

        // Get stored temporary data
        final firstName = await _secureStorage.read(key: 'temp_first_name');
        final lastName = await _secureStorage.read(key: 'temp_last_name');

        // Create user model
        final UserModel user = UserModel(
          id: userData['id'].toString(),
          email: userData['email'],
          firstName: firstName ?? userData['first_name'] ?? '',
          lastName: lastName ?? userData['last_name'] ?? '',
          avatar: userData['avatar'],
          bio: userData['bio'],
          createdAt: DateTime.parse(userData['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(userData['updated_at'] ?? DateTime.now().toIso8601String()),
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
        await _secureStorage.delete(key: 'temp_first_name');
        await _secureStorage.delete(key: 'temp_last_name');

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
      await _secureStorage.delete(key: 'refresh_token');
      await _secureStorage.delete(key: AppConstants.userIdKey);
      await _secureStorage.delete(key: AppConstants.userEmailKey);
      await _secureStorage.delete(key: AppConstants.userNameKey);
      await _secureStorage.delete(key: AppConstants.userAvatarKey);

      return response.statusCode == 200;
    } catch (e) {
      // Clear stored data even if there's an error
      await removeToken();
      await _secureStorage.delete(key: 'refresh_token');
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
    String? bio,
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
      if (bio != null) updateData['bio'] = bio;

      final response = await _httpClient.patch(
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

  /// Gets the stored refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  /// Refreshes the authentication token using refresh token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();

      if (refreshToken == null) {
        throw ApiException(
          statusCode: 401,
          message: AppConstants.unauthorizedErrorMessage,
        );
      }

      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['refreshToken']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Failed to refresh token',
          );
        }

        final accessToken = data['data']['session']['access_token'] as String;
        final newRefreshToken = data['data']['session']['refresh_token'] as String;
        final userData = data['data']['user'] as Map<String, dynamic>;

        // Store the new tokens
        await setToken(accessToken);
        await _secureStorage.write(key: 'refresh_token', value: newRefreshToken);

        return {
          'user': UserModel(
            id: userData['id'],
            email: userData['email'],
            firstName: userData['first_name'] ?? '',
            lastName: userData['last_name'] ?? '',
            avatar: userData['avatar'],
            createdAt: DateTime.parse(
                userData['created_at'] ?? DateTime.now().toIso8601String()),
            updatedAt: DateTime.parse(
                userData['updated_at'] ?? DateTime.now().toIso8601String()),
          ),
          'accessToken': accessToken,
          'refreshToken': newRefreshToken,
        };
      } else {
        // If refresh fails, clean up tokens and force re-login
        await removeToken();
        await _secureStorage.delete(key: 'refresh_token');
        
        throw ApiException(
          statusCode: response.statusCode,
          message: json.decode(response.body)['message'] ?? 
              'Session expired. Please log in again.',
        );
      }
    } catch (e) {
      // On any error, force re-login
      await removeToken();
      await _secureStorage.delete(key: 'refresh_token');
      
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: 500,
        message: e.toString(),
      );
    }
  }

  /// Checks if the server is healthy
  Future<bool> healthCheck() async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['healthCheck']}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// [Deprecated] Registers a new user (old single-step method)
  Future<UserModel> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? avatar,
  }) async {
    // Start registration process
    await registerInit(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    
    // For backward compatibility we would need OTP here, but can't automatically handle
    // So this method is now deprecated - user should use registerInit and registerComplete
    throw ApiException(
      statusCode: 400,
      message: 'This method is deprecated. Please use registerInit and registerComplete instead.',
    );
  }

  /// Uploads a profile avatar image
  Future<UserModel> uploadAvatar(List<int> imageBytes, String fileName) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw ApiException(
          statusCode: 401,
          message: AppConstants.unauthorizedErrorMessage,
        );
      }

      // Create multipart request
      final uri = Uri.parse(
          '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['uploadAvatar']}');
      final request = http.MultipartRequest('POST', uri);
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add file
      final multipartFile = http.MultipartFile.fromBytes(
        'avatar',
        imageBytes,
        filename: fileName,
      );
      request.files.add(multipartFile);
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] != true) {
          throw ApiException(
            statusCode: 400,
            message: data['message'] ?? 'Failed to upload avatar',
          );
        }
        
        final userData = data['data'];
        final UserModel user = UserModel.fromJson(userData);
        
        // Update stored avatar URL
        if (user.avatar != null) {
          await _secureStorage.write(
              key: AppConstants.userAvatarKey, value: user.avatar);
        }
        
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
}
