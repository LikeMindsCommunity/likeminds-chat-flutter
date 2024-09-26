import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/attachment/attachment_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/og_tag/og_tag_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [ConversationViewDataConvertor] is an extension on [Conversation] class.
/// It converts [Conversation] to [LMChatConversationViewData].
extension ConversationViewDataConvertor on Conversation {
  /// Converts [Conversation] to [LMChatConversationViewData]
  LMChatConversationViewData toConversationViewData() {
    final LMChatConversationViewDataBuilder conversationBuilder =
        LMChatConversationViewDataBuilder()
          ..answer(answer)
          ..attachmentCount(attachmentCount)
          ..attachments(
              attachments?.map((e) => e.toAttachmentViewData()).toList())
          ..attachmentsUploaded(attachmentsUploaded)
          ..chatroomId(chatroomId)
          ..communityId(communityId)
          ..createdAt(createdAt)
          ..createdEpoch(createdEpoch)
          ..date(date)
          ..deletedByUserId(deletedByUserId)
          ..deviceId(deviceId)
          ..endTime(endTime)
          ..expiryTime(expiryTime)
          ..header(header)
          ..id(id)
          ..internalLink(internalLink)
          ..isAnonymous(isAnonymous)
          ..isEdited(isEdited)
          ..lastUpdated(lastUpdated)
          ..location(location)
          ..locationLat(locationLat)
          ..locationLong(locationLong)
          ..multipleSelectNo(multipleSelectNo)
          ..multipleSelectState(multipleSelectState)
          ..onlineLinkEnableBefore(onlineLinkEnableBefore)
          ..pollAnswerText(pollAnswerText)
          ..pollType(pollType)
          ..replyChatroomId(replyChatroomId)
          ..replyId(replyId)
          ..startTime(startTime)
          ..state(state)
          ..temporaryId(temporaryId)
          ..memberId(memberId)
          ..toShowResults(toShowResults)
          ..pollTypeText(pollTypeText)
          ..submitTypeText(submitTypeText)
          ..isTimeStamp(isTimeStamp)
          ..member(member?.toUserViewData())
          ..replyConversation(replyConversation)
          ..replyConversationObject(
              replyConversationObject?.toConversationViewData())
          ..ogTags(ogTags?.toLMChatOGTagViewData())
        // ..conversationReactions(conversationReactions?.map((LMChatReactionViewData reaction) => reaction.toReactionViewData()).toList())
        // ..poll(poll?.toPollViewData())
        ;

    return conversationBuilder.build();
  }
}

/// [ConversationConvertor] is an extension on [LMChatConversationViewData] class.
/// It converts [LMChatConversationViewData] to [Conversation].
extension ConversationConvertor on LMChatConversationViewData {
  /// Converts [LMChatConversationViewData] to [Conversation]
  Conversation toConversation() {
    return Conversation(
      answer: answer,
      attachmentsUploaded: attachmentsUploaded,
      attachmentCount: attachmentCount,
      attachments: attachments?.map((e) => e.toAttachment()).toList(),
      chatroomId: chatroomId,
      communityId: communityId,
      createdAt: createdAt,
      createdEpoch: createdEpoch,
      date: date,
      deletedByUserId: deletedByUserId,
      deviceId: deviceId,
      endTime: endTime,
      expiryTime: expiryTime,
      header: header,
      id: id,
      internalLink: internalLink,
      isAnonymous: isAnonymous,
      isEdited: isEdited,
      lastUpdated: lastUpdated,
      location: location,
      locationLat: locationLat,
      locationLong: locationLong,
      multipleSelectNo: multipleSelectNo,
      multipleSelectState: multipleSelectState,
      onlineLinkEnableBefore: onlineLinkEnableBefore,
      pollAnswerText: pollAnswerText,
      pollType: pollType,
      replyChatroomId: replyChatroomId,
      replyId: replyId,
      startTime: startTime,
      state: state,
      temporaryId: temporaryId,
      memberId: memberId,
      toShowResults: toShowResults,
      pollTypeText: pollTypeText,
      submitTypeText: submitTypeText,
      isTimeStamp: isTimeStamp,
      member: member?.toUser(),
      replyConversation: replyConversation,
      replyConversationObject: replyConversationObject?.toConversation(),
      ogTags: ogTags?.toOGTag(),
      // conversationReactions: conversationReactions?.map((LMChatReactionViewData reaction) => reaction.toReaction()).toList(),
      // poll: poll?.toPoll(),
    );
  }
}
