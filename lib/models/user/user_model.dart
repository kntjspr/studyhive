/// Model representing a user
class UserModel {
  /// Unique identifier for the user
  final String id;

  /// Email address of the user
  final String email;

  /// First name of the user
  final String firstName;

  /// Last name of the user
  final String lastName;

  /// Optional avatar URL of the user
  final String? avatar;

  /// When the user was created
  final DateTime createdAt;

  /// When the user was last updated
  final DateTime updatedAt;

  /// Creates a new UserModel instance
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this UserModel with the given fields replaced with the new values
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Gets the full name of the user
  String get fullName => '$firstName $lastName';
}
