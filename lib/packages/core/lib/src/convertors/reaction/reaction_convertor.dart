import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [ReactionViewDataConvertor] is an extension on [Reaction] class.
/// It converts [Reaction] to [LMChatReactionViewData].
extension ReactionViewDataConvertor on Reaction {
  /// Converts [Reaction] to [LMChatReactionViewData]
  LMChatReactionViewData toReactionViewData() {
    return (LMChatReactionViewDataBuilder()
          ..chatroomId(chatroomId)
          ..conversationId(conversationId)
          ..reaction(reaction)
          ..reactionId(reactionId)
          ..userId(userId))
        .build();
  }
}

/// [ReactionConvertor] is an extension on [LMChatReactionViewData] class.
/// It converts [LMChatReactionViewData] to [Reaction].
extension ReactionConvertor on LMChatReactionViewData {
  /// Converts [LMChatReactionViewData] to [Reaction]
  Reaction toReaction() {
    return Reaction(
      conversationId: conversationId,
      userId: userId,
      reaction: reaction,
      chatroomId: chatroomId,
      reactionId: reactionId,
    );
  }
}
