/// A stub implementation of the dart:io Platform class for web.
/// This provides mock implementations of platform-specific functionality.
///
/// Used as a conditional import replacement for dart:io to allow
/// code to compile for web platforms.
class Platform {
  /// Always returns false for web
  static bool get isIOS => false;

  /// Always returns false for web
  static bool get isAndroid => false;

  /// Always returns true for web
  static bool get isWeb => true;

  /// Returns 'web' as the operating system for web platforms
  static String get operatingSystem => 'web';

  /// Returns 'web' as the operating system version for web platforms
  static String get operatingSystemVersion => 'web';
}
