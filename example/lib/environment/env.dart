import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvDev.apiKey;
  @EnviedField(varName: 'BOT_ID', obfuscate: true)
  static final String botId = _EnvDev.botId;
  @EnviedField(varName: 'CM_ID', obfuscate: true)
  static final String cmId = _EnvDev.cmId;
  @EnviedField(varName: 'USER_ID', obfuscate: true)
  static final String userId = _EnvDev.userId;
}

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final apiKey = _EnvProd.apiKey;
  @EnviedField(varName: 'BOT_ID', obfuscate: true)
  static final String botId = _EnvProd.botId;
  @EnviedField(varName: 'CM_ID', obfuscate: true)
  static final String cmId = _EnvProd.cmId;
  @EnviedField(varName: 'USER_ID', obfuscate: true)
  static final String userId = _EnvProd.userId;
}
