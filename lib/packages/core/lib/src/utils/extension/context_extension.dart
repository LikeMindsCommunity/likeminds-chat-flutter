import 'package:flutter/material.dart';

/// {@template context_extension}
/// Extension methods for BuildContext
/// {@endtemplate}
extension BuildContextExtension on BuildContext {
  /// Push a new page to the navigator stack
  Future<T?> push<T extends Object?>(Widget page) async => Navigator.push<T>(
        this,
        MaterialPageRoute<T>(
          builder: (context) => page,
        ),
      );

  /// Replace the current page with a new page in the navigator stack
  Future<T?> replace<T extends Object?, TO extends Object?>(
          Widget page) async =>
      Navigator.pushReplacement<T, TO>(
        this,
        MaterialPageRoute<T>(
          builder: (context) => page,
        ),
      );

  /// Pop the current page from the navigator stack
  void pop<T extends Object?>([T? result]) => Navigator.pop<T>(this, result);
}
