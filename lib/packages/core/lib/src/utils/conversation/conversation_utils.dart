import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

List<LMChatConversationViewData>? addTimeStampInConversationList(
    List<LMChatConversationViewData>? conversationList, int communityId) {
  if (conversationList == null) {
    return conversationList;
  }
  LinkedHashMap<String, List<LMChatConversationViewData>> mappedConversations =
      LinkedHashMap<String, List<LMChatConversationViewData>>();

  for (LMChatConversationViewData conversation in conversationList) {
    if (conversation.isTimeStamp == null || !conversation.isTimeStamp!) {
      if (mappedConversations.containsKey(conversation.date)) {
        mappedConversations[conversation.date]!.add(conversation);
      } else {
        mappedConversations[conversation.date!] = <LMChatConversationViewData>[
          conversation
        ];
      }
    }
  }
  List<LMChatConversationViewData> conversationListWithTimeStamp =
      <LMChatConversationViewData>[];
  mappedConversations.forEach(
    (key, value) {
      conversationListWithTimeStamp.addAll(value);
      conversationListWithTimeStamp.add(
        Conversation(
          isTimeStamp: true,
          answer: key,
          communityId: communityId,
          chatroomId: 0,
          createdAt: key,
          header: key,
          id: 0,
          pollAnswerText: key,
        ).toConversationViewData(),
      );
    },
  );
  return conversationListWithTimeStamp;
}

/// Helps us handle the state message addition to the list locally on
/// new chatroom topic selection by creating it using the [User] and [Conversation]
/// params - [User] loggedInUser, [Conversation] newTopic
Conversation conversationToLocalTopicStateMessage(
    User loggedInUser, Conversation newTopic) {
  Conversation stateMessage;
  String mockBackendMessage = newTopic.answer.isNotEmpty
      ? "${loggedInUser.name} changed current topic to ${LMChatTaggingHelper.extractStateMessage(newTopic.answer)}"
      : "${loggedInUser.name} set a media message as current topic";
  stateMessage = Conversation(
    answer: mockBackendMessage,
    createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
    header: null,
    id: 0,
    state: 1,
  );
  return stateMessage;
}

String getDeletedText(
    LMChatConversationViewData conversation, LMChatUserViewData user) {
  return conversation.deletedByUserId == conversation.memberId
      ? conversation.deletedByUserId == user.id
          ? 'You deleted this message'
          : "This message was deleted by user"
      : "This message was deleted by Admin";
}

LMChatText getDeletedTextWidget(
    LMChatConversationViewData conversation, LMChatUserViewData user,
    {int? maxLines}) {
  return LMChatText(
    getDeletedText(conversation, user),
    style: LMChatTextStyle(
      maxLines: maxLines,
      textStyle: const TextStyle(
        color: LMChatDefaultTheme.greyColor,
        fontStyle: FontStyle.italic,
        fontSize: 13,
      ),
    ),
  );
}

Map<String, List<Reaction>> convertListToMapReaction(List<Reaction> reaction) {
  Map<String, List<Reaction>> mappedReactions = {};
  mappedReactions = {'All': reaction};
  for (var element in reaction) {
    if (mappedReactions.containsKey(element.reaction)) {
      mappedReactions[element.reaction]?.add(element);
    } else {
      mappedReactions[element.reaction] = [element];
    }
  }
  return mappedReactions;
}
