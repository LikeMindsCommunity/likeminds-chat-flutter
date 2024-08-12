import 'package:likeminds_chat_flutter_core/src/views/media/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/style.dart';

/// {@template lm_chat_report_config}
/// [LMChatMediaForwardingConfig] is a class which is used to configure the chat report
/// screen. It is used to customize the chat report screen.
/// [builder] is used to set builders for the chat report screen.
/// [setting] is used to set the settings for the chat report screen.
/// [style] is used to set the style for the chat report screen.
/// {@endtemplate}
class LMChatMediaForwardingConfig {
  /// {@macro lm_chat_report_builder_delegate}
  final LMChatMediaForwardingBuilderDelegate builder;

  /// {@macro lm_chat_report_setting}
  final LMChatMediaForwardingSetting setting;

  /// {@macro lm_chat_report_style}
  final LMChatMediaForwardingStyle style;

  /// {@macro lm_chat_report_config}
  const LMChatMediaForwardingConfig({
    this.builder = const LMChatMediaForwardingBuilderDelegate(),
    this.style = const LMChatMediaForwardingStyle(),
    this.setting = const LMChatMediaForwardingSetting(),
  });
}
