
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_community_chat_style}
/// [LMCommunityChatStyle] is a class which is used to style the home
/// screen. It is used to customize the home screen.
/// {@endtemplate}
class LMCommunityChatStyle {
  /// {@macro lm_community_chat_style}
  const LMCommunityChatStyle({
    this.homeFeedListStyle,
    this.dmFeedListStyle,
  });

  final LMCommunityChatListStyle Function(LMCommunityChatListStyle)?
      homeFeedListStyle;
  final LMChatDMFeedListStyle Function(LMChatDMFeedListStyle)? dmFeedListStyle;
}
