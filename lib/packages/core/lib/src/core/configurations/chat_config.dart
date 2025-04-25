import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations/chat_builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/community_chat/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/community_hybrid_chat/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/explore/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/member_list/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/networking_chat/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/search/configuration/config.dart';
import 'package:likeminds_chat_flutter_core/src/utils/web/web_configurations.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/explore/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/participants/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/report/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/poll/configurations/config.dart';
export 'package:likeminds_chat_flutter_core/src/views/search/configuration/config.dart';
export 'package:likeminds_chat_flutter_core/src/utils/web/web_configurations.dart';

/// {@template lm_chat_config}
/// Configuration class for the Likeminds Chat SDK.
/// {@endtemplate}
class LMChatConfig {
  /// {@macro lm_chat_chatroom_config}
  final LMChatroomConfig chatRoomConfig;

  /// {@macro lm_chat_explore_config}
  final LMChatExploreConfig exploreConfig;

  final LMCommunityChatConfig communityChatConfig;
  final LMNetworkingChatConfig networkingChatConfig;
  final LMCommunityHybridChatConfig communityHybridChatConfig;
  final LMChatMemberListConfig memberListConfig;

  /// {@macro lm_chat_participant_config}
  final LMChatParticipantConfig participantConfig;

  /// {@macro lm_chat_report_config}
  final LMChatReportConfig reportConfig;

  /// {@macro lm_chat_media_forwarding_config}
  final LMChatMediaForwardingConfig mediaForwardingConfig;

  /// {@macro lm_chat_media_preview_config}
  final LMChatMediaPreviewConfig mediaPreviewConfig;

  /// {@macro lm_chat_poll_config}
  final LMChatPollConfig pollConfig;

  /// {@macro lm_search_config}
  final LMSearchConversationConfig searchConversationConfig;

  /// {@macro lm_chat_web_configuration}
  final LMChatWebConfiguration webConfiguration;

  /// {@macro lm_widget_builder_delegate}
  final LMChatWidgetBuilderDelegate widgetBuilderDelegate;

  /// [globalSystemOverlayStyle] is the system overlay style for the app.
  final SystemUiOverlayStyle? globalSystemOverlayStyle;

  /// {@macro lm_chat_config}
  LMChatConfig({
    this.chatRoomConfig = const LMChatroomConfig(),
    this.exploreConfig = const LMChatExploreConfig(),
    this.communityChatConfig = const LMCommunityChatConfig(),
    this.networkingChatConfig = const LMNetworkingChatConfig(),
    this.communityHybridChatConfig = const LMCommunityHybridChatConfig(),
    this.memberListConfig = const LMChatMemberListConfig(),
    this.participantConfig = const LMChatParticipantConfig(),
    this.reportConfig = const LMChatReportConfig(),
    this.mediaForwardingConfig = const LMChatMediaForwardingConfig(),
    this.mediaPreviewConfig = const LMChatMediaPreviewConfig(),
    this.pollConfig = const LMChatPollConfig(),
    this.searchConversationConfig = const LMSearchConversationConfig(),
    this.webConfiguration = const LMChatWebConfiguration(),
    this.widgetBuilderDelegate = const LMChatWidgetBuilderDelegate(),
    this.globalSystemOverlayStyle,
  });
}
