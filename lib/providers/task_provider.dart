import 'package:flutter/foundation.dart';
import 'package:studyhive/models/task/task_model.dart';
import 'package:studyhive/services/task_service.dart';
import 'package:studyhive/utils/exceptions.dart';

/// Provider for managing task state
class TaskProvider extends ChangeNotifier {
  final TaskService _taskService;

  /// List of all tasks
  List<TaskModel> _tasks = [];

  /// Currently selected task
  TaskModel? _selectedTask;

  /// Loading state
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  /// Filter for task status
  String? _statusFilter;

  /// Filter for task priority
  String? _priorityFilter;

  /// Filter for task category
  String? _categoryFilter;

  /// Sort field for tasks
  String _sortBy = 'dueDate';

  /// Sort direction for tasks
  bool _sortAscending = true;

  /// Available categories
  List<String> _categories = [];

  /// Creates a new TaskProvider instance
  TaskProvider(this._taskService);

  /// Gets all tasks
  List<TaskModel> get tasks => _getFilteredAndSortedTasks();

  /// Gets the currently selected task
  TaskModel? get selectedTask => _selectedTask;

  /// Gets the loading state
  bool get isLoading => _isLoading;

  /// Gets the error message
  String? get errorMessage => _errorMessage;

  /// Gets the status filter
  String? get statusFilter => _statusFilter;

  /// Gets the priority filter
  String? get priorityFilter => _priorityFilter;

  /// Gets the category filter
  String? get categoryFilter => _categoryFilter;

  /// Gets the sort field
  String get sortBy => _sortBy;

  /// Gets the sort direction
  bool get sortAscending => _sortAscending;

  /// Gets the available categories
  List<String> get categories => _categories;

  /// Fetches all tasks from the API
  Future<void> fetchTasks() async {
    _setLoading(true);
    _clearError();

    try {
      _tasks = await _taskService.getTasks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches a specific task by ID
  Future<void> fetchTaskById(String taskId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedTask = await _taskService.getTaskById(taskId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Creates a new task
  Future<bool> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    required String priority,
    required String status,
    String? category,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final task = await _taskService.createTask(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
        category: category,
      );

      _tasks.add(task);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates an existing task
  Future<bool> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    String? category,
    bool? isCompleted,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _taskService.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
        category: category,
        isCompleted: isCompleted,
      );

      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }

      if (_selectedTask?.id == taskId) {
        _selectedTask = updatedTask;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Marks a task as completed
  Future<bool> completeTask(String taskId) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedTask = await _taskService.completeTask(taskId);

      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }

      if (_selectedTask?.id == taskId) {
        _selectedTask = updatedTask;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes a task
  Future<bool> deleteTask(String taskId) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _taskService.deleteTask(taskId);

      if (success) {
        _tasks.removeWhere((task) => task.id == taskId);

        if (_selectedTask?.id == taskId) {
          _selectedTask = null;
        }

        notifyListeners();
      }

      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches all task categories
  Future<void> fetchCategories() async {
    _setLoading(true);
    _clearError();

    try {
      _categories = await _taskService.getCategories();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Sets the status filter
  void setStatusFilter(String? status) {
    _statusFilter = status;
    notifyListeners();
  }

  /// Sets the priority filter
  void setPriorityFilter(String? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  /// Sets the category filter
  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  /// Sets the sort field and direction
  void setSorting(String field, {bool ascending = true}) {
    _sortBy = field;
    _sortAscending = ascending;
    notifyListeners();
  }

  /// Clears all filters
  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    _categoryFilter = null;
    notifyListeners();
  }

  /// Sets the selected task
  void selectTask(TaskModel? task) {
    _selectedTask = task;
    notifyListeners();
  }

  /// Sets the loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets the error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears the error message
  void _clearError() {
    _errorMessage = null;
  }

  /// Gets filtered and sorted tasks
  List<TaskModel> _getFilteredAndSortedTasks() {
    // Apply filters
    List<TaskModel> filteredTasks = _tasks.where((task) {
      bool matchesStatus =
          _statusFilter == null || task.status == _statusFilter;
      bool matchesPriority =
          _priorityFilter == null || task.priority == _priorityFilter;
      bool matchesCategory =
          _categoryFilter == null || task.category == _categoryFilter;

      return matchesStatus && matchesPriority && matchesCategory;
    }).toList();

    // Apply sorting
    filteredTasks.sort((a, b) {
      dynamic valueA;
      dynamic valueB;

      switch (_sortBy) {
        case 'dueDate':
          valueA = a.dueDate;
          valueB = b.dueDate;

          // Handle null due dates
          if (valueA == null && valueB == null) return 0;
          if (valueA == null) return _sortAscending ? 1 : -1;
          if (valueB == null) return _sortAscending ? -1 : 1;
          break;
        case 'priority':
          // Convert priority to numeric value for sorting
          valueA = TaskModel.priorityLevels.indexOf(a.priority);
          valueB = TaskModel.priorityLevels.indexOf(b.priority);
          break;
        case 'title':
          valueA = a.title;
          valueB = b.title;
          break;
        case 'createdAt':
          valueA = a.createdAt;
          valueB = b.createdAt;
          break;
        default:
          valueA = a.dueDate;
          valueB = b.dueDate;
      }

      // Compare values
      int comparison;
      if (valueA is String && valueB is String) {
        comparison = valueA.compareTo(valueB);
      } else if (valueA is DateTime && valueB is DateTime) {
        comparison = valueA.compareTo(valueB);
      } else if (valueA is num && valueB is num) {
        comparison = valueA.compareTo(valueB);
      } else {
        comparison = 0;
      }

      return _sortAscending ? comparison : -comparison;
    });

    return filteredTasks;
  }
}
