import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studyhive/models/task/task_model.dart';
import 'package:studyhive/services/auth_service.dart';
import 'package:studyhive/utils/constants.dart';
import 'package:studyhive/utils/exceptions.dart';

/// Service for task-related API calls
class TaskService {
  final http.Client _httpClient;
  final AuthService _authService;

  /// Creates a new TaskService instance
  TaskService({
    http.Client? httpClient,
    AuthService? authService,
  })  : _httpClient = httpClient ?? http.Client(),
        _authService = authService ?? AuthService();

  /// Gets all tasks for the current user
  Future<List<TaskModel>> getTasks() async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.get(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['tasks']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => TaskModel.fromJson(json)).toList();
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

  /// Gets a specific task by ID
  Future<TaskModel> getTaskById(String taskId) async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.get(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['taskById']}$taskId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return TaskModel.fromJson(data);
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

  /// Creates a new task
  Future<TaskModel> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    required String priority,
    required String status,
    String? category,
  }) async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.post(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['tasks']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'due_date': dueDate?.toIso8601String(),
          'priority': priority,
          'status': status,
          'category': category,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return TaskModel.fromJson(data);
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

  /// Updates an existing task
  Future<TaskModel> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    String? category,
    bool? isCompleted,
  }) async {
    try {
      final token = await _authService.getToken();
      final Map<String, dynamic> updateData = {};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (dueDate != null) updateData['due_date'] = dueDate.toIso8601String();
      if (priority != null) updateData['priority'] = priority;
      if (status != null) updateData['status'] = status;
      if (category != null) updateData['category'] = category;
      if (isCompleted != null) updateData['is_completed'] = isCompleted;

      final response = await _httpClient.put(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['taskById']}$taskId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return TaskModel.fromJson(data);
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

  /// Marks a task as completed
  Future<TaskModel> completeTask(String taskId) async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.put(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['completeTask']}$taskId/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body)['data'];
        return TaskModel.fromJson(data);
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

  /// Deletes a task
  Future<bool> deleteTask(String taskId) async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.delete(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['taskById']}$taskId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
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

  /// Gets all task categories
  Future<List<String>> getCategories() async {
    try {
      final token = await _authService.getToken();
      final response = await _httpClient.get(
        Uri.parse(
            '${AppConstants.apiBaseUrl}${AppConstants.apiEndpoints['taskCategories']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((category) => category as String).toList();
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
}
