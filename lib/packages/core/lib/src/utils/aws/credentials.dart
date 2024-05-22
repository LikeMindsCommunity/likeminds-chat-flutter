import 'package:envied/envied.dart';

part 'credentials.g.dart';

///These are BETA sample community credentials
@Envied(name: 'CredsDev', path: '.env.dev')
abstract class LMChatAWSCredsDev {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _CredsDev.apiKey;
  @EnviedField(varName: 'BOT_ID', obfuscate: true)
  static final String botId = _CredsDev.botId;
  @EnviedField(varName: 'BUCKET_NAME', obfuscate: true)
  static final String bucketName = _CredsDev.bucketName;
  @EnviedField(varName: 'POOL_ID', obfuscate: true)
  static final String poolId = _CredsDev.poolId;
}

///These are PROD community credentials
@Envied(name: 'CredsProd', path: '.env.prod')
abstract class LMChatAWSCredsProd {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _CredsProd.apiKey;
  @EnviedField(varName: 'BOT_ID', obfuscate: true)
  static final String botId = _CredsProd.botId;
  @EnviedField(varName: 'BUCKET_NAME', obfuscate: true)
  static final String bucketName = _CredsProd.bucketName;
  @EnviedField(varName: 'POOL_ID', obfuscate: true)
  static final String poolId = _CredsProd.poolId;
}
