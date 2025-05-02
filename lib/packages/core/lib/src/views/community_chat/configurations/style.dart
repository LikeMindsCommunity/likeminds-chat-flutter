import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_community_chat_style}
/// [LMCommunityChatStyle] is a class which is used to style the LMCommunityChatScreen
/// It is used to customize the LMCommunityChatScreen.
/// {@endtemplate}
class LMCommunityChatStyle {
  /// {@macro lm_community_chat_style}
  const LMCommunityChatStyle({
    this.communityChatListStyle,
  });

  final LMCommunityChatListStyle Function(LMCommunityChatListStyle)?
      communityChatListStyle;
}
