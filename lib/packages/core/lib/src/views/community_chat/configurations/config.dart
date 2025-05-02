import 'builder.dart';
import 'style.dart';
import 'settings.dart';

// export all the configurations
export 'builder.dart';
export 'style.dart';
export 'settings.dart';

/// {@template lm_community_chat_config}
/// [LMCommunityChatConfig] is a class which is used to configure the LMCommunityChatScreen
///  It is used to customize the LMCommunityChatScreen.
/// {@endtemplate}
class LMCommunityChatConfig {
  /// {@macro lm_community_chat_builder_delegate}
  final LMCommunityChatBuilderDelegate builder;

  /// {@macro lm_community_chat_setting}
  final LMCommunityChatSetting setting;

  /// {@macro lm_community_chat_style}
  final LMCommunityChatStyle style;

  /// {@macro lm_chat_home_config}
  const LMCommunityChatConfig({
    this.builder = const LMCommunityChatBuilderDelegate(),
    this.setting = const LMCommunityChatSetting(),
    this.style = const LMCommunityChatStyle(),
  });
}
