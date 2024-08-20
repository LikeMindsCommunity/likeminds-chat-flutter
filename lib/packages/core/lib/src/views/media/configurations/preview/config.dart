import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/style.dart';

/// {@template lm_chat_media_preview_config}
/// [LMChatMediaPreviewConfig] is a class which is used to configure the chat media_preview
/// screen. It is used to customize the chat media_preview screen.
/// [builder] is used to set builders for the chat media_preview screen.
/// [setting] is used to set the settings for the chat media_preview screen.
/// [style] is used to set the style for the chat media_preview screen.
/// {@endtemplate}
class LMChatMediaPreviewConfig {
  /// {@macro lm_chat_media_preview_builder_delegate}
  final LMChatMediaPreviewBuilderDelegate builder;

  /// {@macro lm_chat_media_preview_setting}
  final LMChatMediaPreviewSetting setting;

  /// {@macro lm_chat_media_preview_style}
  final LMChatMediaPreviewStyle style;

  /// {@macro lm_chat_media_preview_config}
  const LMChatMediaPreviewConfig({
    this.builder = const LMChatMediaPreviewBuilderDelegate(),
    this.style = const LMChatMediaPreviewStyle(),
    this.setting = const LMChatMediaPreviewSetting(),
  });
}
