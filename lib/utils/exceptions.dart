/// Base exception class for the application
abstract class AppException implements Exception {
  /// Error message
  final String message;

  /// Creates a new AppException instance
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Exception for API errors
class ApiException extends AppException {
  /// HTTP status code
  final int statusCode;

  /// Creates a new ApiException instance
  const ApiException({
    required this.statusCode,
    required String message,
  }) : super(message);

  @override
  String toString() => 'ApiException: $statusCode - $message';

  /// Checks if the exception is a network error
  bool get isNetworkError => statusCode == 0;

  /// Checks if the exception is a server error
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Checks if the exception is a client error
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Checks if the exception is an authentication error
  bool get isAuthError => statusCode == 401;

  /// Checks if the exception is a forbidden error
  bool get isForbiddenError => statusCode == 403;

  /// Checks if the exception is a not found error
  bool get isNotFoundError => statusCode == 404;

  /// Checks if the exception is a validation error
  bool get isValidationError => statusCode == 422;
}

/// Exception for validation errors
class ValidationException extends AppException {
  /// Field-specific error messages
  final Map<String, List<String>> errors;

  /// Creates a new ValidationException instance
  const ValidationException({
    required String message,
    required this.errors,
  }) : super(message);

  @override
  String toString() => 'ValidationException: $message - $errors';
}

/// Exception for authentication errors
class AuthException extends AppException {
  /// Creates a new AuthException instance
  const AuthException(String message) : super(message);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception for network errors
class NetworkException extends AppException {
  /// Creates a new NetworkException instance
  const NetworkException(String message) : super(message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for cache errors
class CacheException extends AppException {
  /// Creates a new CacheException instance
  const CacheException(String message) : super(message);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception for not found errors
class NotFoundException extends AppException {
  /// Creates a new NotFoundException instance
  const NotFoundException(String message) : super(message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception for forbidden errors
class ForbiddenException extends AppException {
  /// Creates a new ForbiddenException instance
  const ForbiddenException(String message) : super(message);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Exception for server errors
class ServerException extends AppException {
  /// Creates a new ServerException instance
  const ServerException(String message) : super(message);

  @override
  String toString() => 'ServerException: $message';
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  /// Creates a new TimeoutException instance
  const TimeoutException(String message) : super(message);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception for unknown errors
class UnknownException extends AppException {
  /// Creates a new UnknownException instance
  const UnknownException(String message) : super(message);

  @override
  String toString() => 'UnknownException: $message';
}
