import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';


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

/// Return list of [LMChatConversationViewData] with [LMChatConversationViewType] top and bottom
/// based on the member id and date of the conversation
/// and add date conversation in between if the date is different
/// should be used when we are fetching the conversations for the first time, i.e page 1
List<LMChatConversationViewData> groupConversationsAndAddDates(
    List<LMChatConversationViewData> conversations) {
  List<LMChatConversationViewData> updatedConversations = [];

  for (int index = 0; index < conversations.length; index++) {
    LMChatConversationViewData conversation = conversations[index];
    int? nextMemberId;
    bool isNextDateConversation = false;

    if (index + 1 < conversations.length) {
      nextMemberId = conversations[index + 1].memberId;
      isNextDateConversation =
          conversations[index + 1].date != conversation.date;
    } else {
      nextMemberId = null;
    }

    if (isNextDateConversation || (conversation.memberId != nextMemberId)) {
      conversation = conversation.copyWith(
          conversationViewType: LMChatConversationViewType.top);
    } else {
      conversation = conversation.copyWith(
          conversationViewType: LMChatConversationViewType.bottom);
    }

    updatedConversations.add(conversation);

    if (isNextDateConversation) {
      updatedConversations.add(
        Conversation(
          isTimeStamp: true,
          answer: conversation.date ?? '',
          communityId: conversation.communityId,
          chatroomId: conversation.chatroomId,
          createdAt: conversation.date ?? '',
          header: conversation.date,
          id: 0,
          pollAnswerText: conversation.date,
        ).toConversationViewData(),
      );
      isNextDateConversation = false;
    }
  }

  return updatedConversations;
}

/// Return list of [LMChatConversationViewData] with [LMChatConversationViewType] top and bottom
/// based on the member id and date of the conversation
/// and add date conversation in between if the date is different
/// should be used when a new conversation is being added to the list
List<LMChatConversationViewData> updateRealTimeConversationsViewType(
    LMChatConversationViewData newConversation,
    List<LMChatConversationViewData> oldConversations) {
  List<LMChatConversationViewData> updatedConversations =
      [];
  int? previousMemberId =
      oldConversations.isNotEmpty ? oldConversations.first.memberId : null;
  String? previousMessageDate =
      oldConversations.isNotEmpty ? oldConversations.first.date : null;
  bool isNextDateConversation = previousMessageDate != newConversation.date;

  if (previousMemberId == newConversation.memberId) {
    if (isNextDateConversation) {
      updatedConversations.add(
        Conversation(
          isTimeStamp: true,
          answer: newConversation.date ?? '',
          communityId: newConversation.communityId,
          chatroomId: newConversation.chatroomId,
          createdAt: newConversation.date ?? '',
          header: newConversation.date,
          id: 0,
          pollAnswerText: newConversation.date,
        ).toConversationViewData(),
      );
      newConversation = newConversation.copyWith(
          conversationViewType: LMChatConversationViewType.top);
    } else {
      newConversation = newConversation.copyWith(
          conversationViewType: LMChatConversationViewType.bottom);
    }
  } else {
    if (isNextDateConversation) {
      updatedConversations.add(
        Conversation(
          isTimeStamp: true,
          answer: newConversation.date ?? '',
          communityId: newConversation.communityId,
          chatroomId: newConversation.chatroomId,
          createdAt: newConversation.date ?? '',
          header: newConversation.date,
          id: 0,
          pollAnswerText: newConversation.date,
        ).toConversationViewData(),
      );
    }
    newConversation = newConversation.copyWith(
        conversationViewType: LMChatConversationViewType.top);
  }

  updatedConversations.add(newConversation);
  return updatedConversations;
}

/// Return list of [LMChatConversationViewData] with [LMChatConversationViewType] top and bottom
/// based on the member id and date of the conversation
/// and add date conversation in between if the date is different
/// should be used when we are fetching the conversations with page > 1
List<LMChatConversationViewData> updatePaginationConversationsViewType(
  List<LMChatConversationViewData> oldConversations,
  List<LMChatConversationViewData> newConversations,
) {
  List<LMChatConversationViewData> updatedConversations = [];
  String? previousMessageDate =
      oldConversations.isNotEmpty ? oldConversations.last.date : null;
  bool isPreviousMessageInSameDate =
      previousMessageDate == newConversations.first.date;

  if (isPreviousMessageInSameDate) {
    oldConversations.removeLast();
  }

  int? previousMemberId =
      oldConversations.isNotEmpty ? oldConversations.last.memberId : null;

  if (previousMemberId == newConversations.first.memberId) {
    oldConversations.last = oldConversations.last
        .copyWith(conversationViewType: LMChatConversationViewType.bottom);
    updatedConversations
        .addAll(groupConversationsAndAddDates(newConversations));
  } else {
    updatedConversations
        .addAll(groupConversationsAndAddDates(newConversations));
  }

  return updatedConversations;
}
