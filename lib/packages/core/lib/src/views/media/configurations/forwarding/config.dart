import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/style.dart';

export 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/style.dart';
export 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/builder.dart';

/// {@template lm_chat_media_forwarding_config}
/// [LMChatMediaForwardingConfig] is a class which is used to configure the chat media_forwarding
/// screen. It is used to customize the chat media_forwarding screen.
/// [builder] is used to set builders for the chat media_forwarding screen.
/// [setting] is used to set the settings for the chat media_forwarding screen.
/// [style] is used to set the style for the chat media_forwarding screen.
/// {@endtemplate}
class LMChatMediaForwardingConfig {
  /// {@macro lm_chat_media_forwarding_builder_delegate}
  final LMChatMediaForwardingBuilderDelegate builder;

  /// {@macro lm_chat_media_forwarding_setting}
  final LMChatMediaForwardingSetting setting;

  /// {@macro lm_chat_media_forwarding_style}
  final LMChatMediaForwardingStyle style;

  /// {@macro lm_chat_media_forwarding_config}
  const LMChatMediaForwardingConfig({
    this.builder = const LMChatMediaForwardingBuilderDelegate(),
    this.style = const LMChatMediaForwardingStyle(),
    this.setting = const LMChatMediaForwardingSetting(),
  });
}
