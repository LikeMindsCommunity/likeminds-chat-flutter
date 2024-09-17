import 'package:envied/envied.dart';

part 'giphy.g.dart';

/// A class that holds Giphy API credentials using environment variables.
///
/// This class uses the Envied package to load the Giphy API key from
/// a specified environment file (.env). The API key is obfuscated for security.
@Envied(name: 'GiphyCredentials', path: '.env')
abstract class LMChatGiphyCredentials {
  /// The Giphy API key, loaded from the environment variable 'GIPHY_API_KEY'.
  ///
  /// This key is obfuscated to prevent exposure in the source code.
  @EnviedField(varName: 'GIPHY_API_KEY', obfuscate: true)
  static final String apiKey = _GiphyCredentials.apiKey;
}
