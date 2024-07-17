import 'package:likeminds_chat_flutter_core/src/views/participants/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/configurations/style.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/participants/configurations/builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/participants/configurations/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/participants/configurations/style.dart';

/// {@template lm_chat_participant_config}
/// Configuration class for the Likeminds Chat Participant.
/// {@endtemplate}
class LMChatParticipantConfig {
  /// {@macro lm_chat_participant_builder_delegate}
  final LMChatParticipantBuilderDelegate builder;

  /// {@macro lm_chat_participant_style}
  final LMChatParticipantStyle style;

  /// {@macro lm_chat_participant_setting}
  final LMChatParticipantSetting setting;

  /// {@macro lm_chat_participant_config}
  const LMChatParticipantConfig({
    this.builder = const LMChatParticipantBuilderDelegate(),
    this.style = const LMChatParticipantStyle(),
    this.setting = const LMChatParticipantSetting(),
  });
}
