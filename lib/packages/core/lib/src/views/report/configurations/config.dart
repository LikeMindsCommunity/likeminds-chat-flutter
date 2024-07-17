import 'package:likeminds_chat_flutter_core/src/views/report/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/configurations/style.dart';

/// {@template lm_chat_report_config}
/// [LMChatReportConfig] is a class which is used to configure the chat report
/// screen. It is used to customize the chat report screen.
/// [builder] is used to set builders for the chat report screen.
/// [setting] is used to set the settings for the chat report screen.
/// [style] is used to set the style for the chat report screen.
/// {@endtemplate}
class LMChatReportConfig {
  /// {@macro lm_chat_report_builder_delegate}
  final LMChatReportBuilderDelegate builder;

  /// {@macro lm_chat_report_setting}
  final LMChatReportSetting setting;

  /// {@macro lm_chat_report_style}
  final LMChatReportStyle style;

  /// {@macro lm_chat_report_config}
  const LMChatReportConfig({
    this.builder = const LMChatReportBuilderDelegate(),
    this.style = const LMChatReportStyle(),
    this.setting = const LMChatReportSetting(),
  });
}
