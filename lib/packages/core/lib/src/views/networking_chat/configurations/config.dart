import 'builder.dart';
import 'style.dart';
import 'settings.dart';

// export all the configurations
export 'builder.dart';
export 'style.dart';
export 'settings.dart';

/// {@template lm_chat_home_config}
/// [LMNetworkingChatConfig] is a class which is used to configure the LMNetworkingChatScreen
/// It is used to customize the LMNetworkingChatScreen.
/// {@endtemplate}
class LMNetworkingChatConfig {
  /// {@macro lm_chat_home_config}
  final LMNetworkingChatBuilderDelegate builder;

  /// {@macro lm_chat_home_config}
  final LMNetworkingChatSetting setting;

  /// {@macro lm_chat_home_config}
  final LMNetworkingChatStyle style;

  /// {@macro lm_chat_home_config}
  const LMNetworkingChatConfig({
    this.builder = const LMNetworkingChatBuilderDelegate(),
    this.setting = const LMNetworkingChatSetting(),
    this.style = const LMNetworkingChatStyle(),
  });
}
