/// Model representing a task
class TaskModel {
  /// Unique identifier for the task
  final String id;

  /// Title of the task
  final String title;

  /// Optional description of the task
  final String? description;

  /// Optional due date of the task
  final DateTime? dueDate;

  /// Priority of the task (low, medium, high)
  final String priority;

  /// Status of the task (pending, in_progress, completed)
  final String status;

  /// Optional category of the task
  final String? category;

  /// Whether the task is completed
  final bool isCompleted;

  /// When the task was created
  final DateTime createdAt;

  /// When the task was last updated
  final DateTime updatedAt;

  /// User ID of the task owner
  final String userId;

  /// Creates a new TaskModel instance
  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    this.category,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  /// Creates a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      priority: json['priority'] as String,
      status: json['status'] as String,
      category: json['category'] as String?,
      isCompleted: json['is_completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  /// Converts the TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority,
      'status': status,
      'category': category,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }

  /// Creates a copy of this TaskModel with the given fields replaced with the new values
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  /// Available priority levels
  static const List<String> priorityLevels = ['low', 'medium', 'high'];

  /// Available status options
  static const List<String> statusOptions = [
    'pending',
    'in_progress',
    'completed'
  ];
}
