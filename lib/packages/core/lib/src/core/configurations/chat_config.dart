import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations/chat_builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/explore/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/home/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/configurations/config.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/explore/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/home/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/participants/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/report/configurations/config.dart';

/// {@template lm_chat_config}
/// Configuration class for the Likeminds Chat SDK.
/// {@endtemplate}
class LMChatConfig {
  /// {@macro lm_chat_chatroom_config}
  final LMChatroomConfig chatRoomConfig;

  /// {@macro lm_chat_explore_config}
  final LMChatExploreConfig exploreConfig;

  /// {@macro lm_chat_home_config}
  final LMChatHomeConfig homeConfig;

  /// {@macro lm_chat_participant_config}
  final LMChatParticipantConfig participantConfig;

  /// {@macro lm_chat_report_config}
  final LMChatReportConfig reportConfig;

  /// {@macro lm_chat_media_forwarding_config}
  final LMChatMediaForwardingConfig mediaForwardingConfig;

  /// {@macro lm_widget_builder_delegate}
  final LMChatWidgetBuilderDelegate widgetBuilderDelegate;

  /// [globalSystemOverlayStyle] is the system overlay style for the app.
  final SystemUiOverlayStyle? globalSystemOverlayStyle;

  /// {@macro lm_chat_config}
  LMChatConfig({
    this.chatRoomConfig = const LMChatroomConfig(),
    this.exploreConfig = const LMChatExploreConfig(),
    this.homeConfig = const LMChatHomeConfig(),
    this.participantConfig = const LMChatParticipantConfig(),
    this.reportConfig = const LMChatReportConfig(),
    this.mediaForwardingConfig = const LMChatMediaForwardingConfig(),
    this.widgetBuilderDelegate = const LMChatWidgetBuilderDelegate(),
    this.globalSystemOverlayStyle,
  });
}
