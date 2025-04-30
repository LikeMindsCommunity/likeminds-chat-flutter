import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';

/// {@template lm_chat_home_style}
/// [LMNetworkingChatStyle] is a class which is used to style the home
/// screen. It is used to customize the home screen.
/// {@endtemplate}
class LMNetworkingChatStyle {
  /// {@macro lm_chat_home_style}
  const LMNetworkingChatStyle({
    this.homeFeedListStyle,
    this.dmFeedListStyle,
  });

  final LMCommunityChatListStyle Function(LMCommunityChatListStyle)?
      homeFeedListStyle;
  final LMChatDMFeedListStyle Function(LMChatDMFeedListStyle)? dmFeedListStyle;
}
