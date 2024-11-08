import 'package:intl/intl.dart';
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

String getUserHomePrefixPreviewMessage(
  LMChatConversationViewData conversation,
) {
  String personLabel = "";
  final user = LMChatLocalPreference.instance.getUser();
  bool isByCurrentUser = conversation.member!.id == user.id;
  personLabel = isByCurrentUser
      ? 'You: '
      : '${conversation.member!.name.split(' ').first}: ';
  return personLabel;
}

String getUserDMPrefixPreviewMessage(
  LMChatConversationViewData conversation,
  LMChatUserViewData conversationUser,
  LMChatUserViewData chatroomUser,
  LMChatUserViewData chatroomWithUser,
) {
  String personLabel = "";
  final user = LMChatLocalPreference.instance.getUser();
  bool a = conversationUser.id == chatroomWithUser.id &&
      user.id == chatroomWithUser.id;
  bool b = conversationUser.id == chatroomUser.id && user.id == chatroomUser.id;
  personLabel = a
      ? 'You: '
      : b
          ? 'You: '
          : '';
  return personLabel;
}

String getDMChatroomPreviewMessage(
  LMChatConversationViewData conversation,
  LMChatUserViewData conversationUser,
  LMChatUserViewData chatroomUser,
  LMChatUserViewData chatroomWithUser,
) {
  String personLabel = "";
  final user = LMChatLocalPreference.instance.getUser();
  bool a = conversationUser.id == chatroomWithUser.id &&
      user.id == chatroomWithUser.id;
  bool b = conversationUser.id == chatroomUser.id && user.id == chatroomUser.id;
  personLabel = a
      ? 'You: '
      : b
          ? 'You: '
          : '';
  String message = conversation.deletedByUserId == null
      ? conversation.attachmentCount == 0
          ? '$personLabel${conversation.state != 0 ? LMChatTaggingHelper.extractStateMessage(
              conversation.answer,
            ) : LMChatTaggingHelper.convertRouteToTag(
              conversation.answer,
              withTilde: false,
            )}'
          : personLabel
      : getDeletedText(conversation, user.toUserViewData());
  return message;
}

String getHomeChatroomPreviewMessage(
  LMChatConversationViewData conversation,
) {
  String personLabel = "";
  final user = LMChatLocalPreference.instance.getUser();
  bool isByCurrentUser = conversation.member!.id == user.id;
  personLabel = isByCurrentUser
      ? 'You: '
      : '${conversation.member!.name.split(' ').first}: ';
  String message = conversation.deletedByUserId == null
      ? conversation.attachmentCount == 0 && conversation.state != 10
          ? '$personLabel${conversation.state != 0 ? LMChatTaggingHelper.extractStateMessage(
              conversation.answer,
            ) : LMChatTaggingHelper.convertRouteToTag(
              conversation.answer,
              withTilde: false,
            )}'
          : personLabel
      : getDeletedText(conversation, user.toUserViewData());
  return message;
}

String getGIFText(LMChatConversationViewData conversation) {
  String gifText = conversation.answer;
  const String gifMessageIndicator =
      "* This is a gif message. Please update your app *";

  if (gifText.endsWith(gifMessageIndicator)) {
    gifText = gifText
        .substring(0, gifText.length - gifMessageIndicator.length)
        .trim();
  }

  return gifText;
}

String getTime(String time) {
  final int time0 = int.tryParse(time) ?? 0;
  final DateTime now = DateTime.now();
  final DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time0);
  final Duration difference = now.difference(messageTime);
  if (difference.inDays > 0 || now.day != messageTime.day) {
    return DateFormat('dd/MM/yyyy').format(messageTime);
  }
  return DateFormat('kk:mm').format(messageTime);
}
