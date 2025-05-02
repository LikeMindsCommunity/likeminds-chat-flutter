import 'builder.dart';
import 'style.dart';
import 'settings.dart';

// export all the configurations
export 'builder.dart';
export 'style.dart';
export 'settings.dart';

/// {@template lm_community_hybrid_chat_config}
/// [LMCommunityHybridChatConfig] is a class which is used to configure the LMCommunityHybridChatScreen
/// It is used to customize the LMCommunityHybridChatScreen.
/// {@endtemplate}
class LMCommunityHybridChatConfig {
  /// {@macro lm_community_chat_builder_delegate}
  final LMCommunityHybridChatBuilderDelegate builder;

  /// {@macro lm_community_hybrid_chat_setting}
  final LMCommunityHybridChatSetting setting;

  /// {@macro lm_community_hybrid_chat_style}
  final LMCommunityHybridChatStyle style;

  /// {@macro lm_chat_home_config}
  const LMCommunityHybridChatConfig({
    this.builder = const LMCommunityHybridChatBuilderDelegate(),
    this.setting = const LMCommunityHybridChatSetting(),
    this.style = const LMCommunityHybridChatStyle(),
  });
}
