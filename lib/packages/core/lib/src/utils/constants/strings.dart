/// A class containing string constants used throughout the LikeMinds Chat application.
/// This class centralizes all string literals to maintain consistency and make updates easier.
/// It includes constants for:
/// - Authentication related strings (apiKey, authToken, etc.)
/// - UI titles and labels
/// - Feature flags and configuration keys
/// - Error messages
class LMChatStringConstants {
  /// Title displayed for the main chatrooms feed
  static const String homeFeedTitle = "Chatrooms";

  /// Key used for storing and retrieving API key
  static const String apiKey = "apiKey";

  /// Key used for storing and retrieving user's unique identifier
  static const String uuid = "uuid";

  /// Key used for storing and retrieving user's display name
  static const String userName = "userName";

  /// Key used for storing and retrieving authentication token
  static const String authToken = "authToken";

  /// Key used for storing and retrieving access token
  static const String accessToken = "accessToken";

  /// Key used for storing and retrieving refresh token
  static const String refreshToken = 'refreshToken';

  /// Title displayed for the direct messages feed
  static const String dmHomeFeedTitle = "Direct Messages";

  /// Feature flag key for enabling/disabling DM request functionality
  static const String isDMWithRequestEnabled = "isDMWithRequestEnabled";

  /// Title displayed for the groups tab
  static const String groupHomeTabTitle = "Groups";

  /// Title displayed for the direct messages tab
  static const String dmHomeTabTitle = "DMs";

  /// Default error message shown when an unexpected error occurs
  static const String errorFallback = "Something went wrong, please try again!";

  /// Core version of LikeMinds Chat SDK
  static const String coreVersion = "1.2.2";
}
