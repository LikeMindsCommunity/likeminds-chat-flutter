import 'package:flutter/src/widgets/framework.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/lists/conversation/conversation_list.dart';

class LMChatroomBuilder extends LMChatroomBuilderDelegate {
  @override
  Widget conversationList(
      int chatroomId, LMChatConversationList conversationList) {
    // TODO: implement conversationList
    return conversationList;
  }

  @override
  Widget sentChatBubbleBuilder(BuildContext context,
      LMChatConversationViewData conversation, LMChatBubble bubble) {
    // TODO: implement sentChatBubbleBuilder
    return bubble.copyWith();
  }
}
