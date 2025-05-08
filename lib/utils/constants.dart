import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  /// Primary color - Yellow
  static const Color primaryColor = Color(0xFFFFCA28);

  /// Accent color - Orange
  static const Color accentColor = Color(0xFFFF9900);

  /// Background color - Light
  static const Color backgroundColor = Color(0xFFF5F5F5);

  /// Text color - Dark
  static const Color textColorDark = Color(0xFF333333);

  /// Text color - Light
  static const Color textColorLight = Color(0xFFFFFFFF);

  /// Error color - Red
  static const Color errorColor = Color(0xFFE53935);

  /// Success color - Green
  static const Color successColor = Color(0xFF43A047);

  /// Warning color - Amber
  static const Color warningColor = Color(0xFFFFB300);

  /// Info color - Blue
  static const Color infoColor = Color(0xFF2196F3);

  /// Default border radius
  static const double defaultBorderRadius = 12.0;

  /// Default padding
  static const double defaultPadding = 16.0;

  /// Default margin
  static const double defaultMargin = 16.0;

  /// Default elevation
  static const double defaultElevation = 2.0;

  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Task priority colors
  static const Map<String, Color> taskPriorityColors = {
    'low': Color(0xFF43A047), // Green
    'medium': Color(0xFFFFB300), // Amber
    'high': Color(0xFFE53935), // Red
  };

  /// Task status colors
  static const Map<String, Color> taskStatusColors = {
    'pending': Color(0xFF757575), // Grey
    'in_progress': Color(0xFF2196F3), // Blue
    'completed': Color(0xFF43A047), // Green
  };

  /// API base URL
  static const String apiBaseUrl = 'http://localhost:8000';

  /// API endpoints
  static const Map<String, String> apiEndpoints = {
    // Auth endpoints
    'loginInit': '/auth/login',
    'loginComplete': '/auth/login/complete',
    'registerInit': '/auth/register/init',
    'registerComplete': '/auth/register/complete',
    'logout': '/auth/logout',
    'refreshToken': '/auth/refresh-token',
    'healthCheck': '/health/',

    // User endpoints
    'userProfile': '/api/profile/',
    'updateProfile': '/api/profile/',
    'uploadAvatar': '/api/profile/avatar/',

    // Task endpoints - keeping these for future implementation
    'tasks': '/tasks/',
    'taskById': '/tasks/', // Append task ID
    'completeTask': '/tasks/', // Append task ID + /complete
    'taskCategories': '/tasks/categories/',

    // Event endpoints
    'events': '/events/',
    'eventById': '/events/', // Append event ID

    // Meeting endpoints
    'meetings': '/meetings/',
    'meetingById': '/meetings/', // Append meeting ID
    'joinMeeting': '/meetings/', // Append meeting ID + /join
    'leaveMeeting': '/meetings/', // Append meeting ID + /leave

    // Message endpoints
    'messages': '/messages/',
    'messageById': '/messages/', // Append message ID

    // File endpoints
    'files': '/files/',
    'fileById': '/files/', // Append file ID

    // Study group endpoints
    'studyGroups': '/study-groups/',
    'studyGroupById': '/study-groups/', // Append group ID
    'joinStudyGroup': '/study-groups/', // Append group ID + /join
    'leaveStudyGroup': '/study-groups/', // Append group ID + /leave

    // Note endpoints
    'notes': '/notes/',
    'noteById': '/notes/', // Append note ID
  };

  /// Shared preferences keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userAvatarKey = 'user_avatar';
  static const String darkModeKey = 'dark_mode';
  static const String onboardingCompletedKey = 'onboarding_completed';

  /// Error messages
  static const String networkErrorMessage =
      'Network error. Please check your internet connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please log in again.';
  static const String notFoundErrorMessage = 'Resource not found.';
  static const String validationErrorMessage =
      'Validation error. Please check your input.';
  static const String unknownErrorMessage =
      'An unknown error occurred. Please try again.';

  /// Success messages
  static const String loginSuccessMessage = 'Login successful.';
  static const String registerSuccessMessage = 'Registration successful.';
  static const String logoutSuccessMessage = 'Logout successful.';
  static const String profileUpdateSuccessMessage =
      'Profile updated successfully.';
  static const String taskCreateSuccessMessage = 'Task created successfully.';
  static const String taskUpdateSuccessMessage = 'Task updated successfully.';
  static const String taskDeleteSuccessMessage = 'Task deleted successfully.';

  /// Validation messages
  static const String requiredFieldMessage = 'This field is required.';
  static const String invalidEmailMessage =
      'Please enter a valid email address.';
  static const String passwordTooShortMessage =
      'Password must be at least 8 characters long.';
  static const String passwordsDoNotMatchMessage = 'Passwords do not match.';
  static const String invalidDateMessage = 'Please enter a valid date.';
  static const String invalidTimeMessage = 'Please enter a valid time.';

  /// Date formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';

  /// App settings
  static const int maxTasksPerPage = 20;
  static const int maxEventsPerPage = 20;
  static const int maxMeetingsPerPage = 20;
  static const int maxMessagesPerPage = 50;
  static const int maxFilesPerPage = 20;
  static const int maxStudyGroupsPerPage = 20;
  static const int maxNotesPerPage = 20;

  /// App routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register/';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String taskListRoute = '/tasks';
  static const String taskDetailRoute = '/tasks/detail';
  static const String taskCreateRoute = '/tasks/create';
  static const String taskEditRoute = '/tasks/edit';
  static const String eventListRoute = '/events';
  static const String eventDetailRoute = '/events/detail';
  static const String eventCreateRoute = '/events/create';
  static const String eventEditRoute = '/events/edit';
  static const String meetingListRoute = '/meetings';
  static const String meetingDetailRoute = '/meetings/detail';
  static const String meetingCreateRoute = '/meetings/create';
  static const String meetingEditRoute = '/meetings/edit';
  static const String messageListRoute = '/messages';
  static const String messageDetailRoute = '/messages/detail';
  static const String fileListRoute = '/files';
  static const String fileDetailRoute = '/files/detail';
  static const String studyGroupListRoute = '/study-groups';
  static const String studyGroupDetailRoute = '/study-groups/detail';
  static const String studyGroupCreateRoute = '/study-groups/create';
  static const String studyGroupEditRoute = '/study-groups/edit';
  static const String noteListRoute = '/notes';
  static const String noteDetailRoute = '/notes/detail';
  static const String noteCreateRoute = '/notes/create';
  static const String noteEditRoute = '/notes/edit';
  static const String settingsRoute = '/settings';
  static const String aboutRoute = '/about';
  static const String helpRoute = '/help';
}
