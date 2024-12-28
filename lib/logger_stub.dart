import 'package:flutter/foundation.dart';

/// A stub implementation of the `Logger` class for platforms where the
/// `logger` package is unavailable, such as Flutter Web.
///
/// This class provides basic logging functionality by using `debugPrint`
/// statements to output messages to the console. It supports logging messages
/// with different levels (error, warning, info, and debug).
///
/// **Note**: For platforms that support the `logger` package, use conditional
/// imports to include the actual `Logger` implementation. This stub is meant
/// for lightweight logging in environments like Flutter Web.

class Logger {
  /// Logs an error message with optional details and stack trace.
  ///
  /// The error message is displayed with the prefix `ERROR`. If an `error` or
  /// `stackTrace` is provided, they are also logged.
  ///
  /// Example:
  /// ```dart
  /// logger.e('An error occurred', error: someError, stackTrace: someStackTrace);
  /// ```
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (_shouldLog()) {
      debugPrint('ERROR: $message');
      if (error != null) debugPrint('Error details: $error');
      if (stackTrace != null) debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Logs a warning message.
  ///
  /// The warning message is displayed with the prefix `WARNING`.
  ///
  /// Example:
  /// ```dart
  /// logger.w('This is a warning message');
  /// ```
  void w(String message) {
    if (_shouldLog()) {
      debugPrint('WARNING: $message');
    }
  }

  /// Logs an informational message.
  ///
  /// The informational message is displayed with the prefix `INFO`.
  ///
  /// Example:
  /// ```dart
  /// logger.i('App started successfully');
  /// ```
  void i(String message) {
    if (_shouldLog()) {
      debugPrint('INFO: $message');
    }
  }

  /// Logs a debug message.
  ///
  /// The debug message is displayed with the prefix `DEBUG`. Use this for
  /// temporary logs during development.
  ///
  /// Example:
  /// ```dart
  /// logger.d('Debugging variable: $variableValue');
  /// ```
  void d(String message) {
    if (_shouldLog()) {
      debugPrint('DEBUG: $message');
    }
  }

  /// Determines whether logging should occur.
  ///
  /// You can override this logic to conditionally enable or disable logging,
  /// for example, based on whether the app is running in production mode.
  ///
  /// Example:
  /// ```dart
  /// bool _shouldLog() => !kReleaseMode; // Logs only in debug mode
  /// ```
  bool _shouldLog() {
    return true; // Replace with environment-specific logic if needed.
  }
}
