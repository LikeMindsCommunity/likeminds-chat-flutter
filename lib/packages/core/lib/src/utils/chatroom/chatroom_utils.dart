import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/enums.dart';
import 'package:likeminds_chat_flutter_core/src/utils/conversation/conversation_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

List<int> getChatroomTypes(LMChatroomType type) {
  List<int> chatrooms = [];
  if (type == LMChatroomType.dm) chatrooms.add(10);
  if (type == LMChatroomType.group) chatrooms.addAll([0, 7]);
  return chatrooms;
}

String getChatroomPreviewMessage(
  LMChatConversationViewData conversation,
  LMChatUserViewData conversationUser,
  LMChatUserViewData chatroomUser,
  LMChatUserViewData chatroomWithUser,
) {
  String personLabel = "";
  final user = LMChatLocalPreference.instance.getUser();
  bool a = conversationUser.id == chatroomWithUser.id &&
      user!.id == chatroomWithUser.id;
  bool b =
      conversationUser.id == chatroomUser.id && user!.id == chatroomUser.id;
  personLabel = a
      ? 'You: '
      : b
          ? 'You: '
          : '';
  String message = conversation.deletedByUserId == null
      ? '$personLabel${conversation.state != 0 ? LMChatTaggingHelper.extractStateMessage(
          conversation.answer,
        ) : LMChatTaggingHelper.convertRouteToTag(
          conversation.answer,
          withTilde: false,
        )}'
      : getDeletedText(conversation, user!.toUserViewData());
  return message;
}
