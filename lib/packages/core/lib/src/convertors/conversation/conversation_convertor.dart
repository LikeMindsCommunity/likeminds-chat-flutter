import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/*
 final bool? allowAddOption;
  final String answer;
  final int? apiVersion;
  final int? attachmentCount;
  final List<LMChatAttachmentViewData>? attachments;
  final bool? attachmentsUploaded;
  final int? chatroomId;
  final int? communityId;
  final String createdAt;
  final int? createdEpoch;
  final String? date;
  final int? deletedByUserId;
  final String? deviceId;
  final int? endTime;
  final int? expiryTime;
  final bool? hasFiles;
  final bool? hasReactions;
  final String? header;
  final int id;
  final String? internalLink;
  final bool? isAnonymous;
  final bool? isEdited;
  final int? lastUpdated;
  final String? location;
  final String? locationLat;
  final String? locationLong;
  final int? multipleSelectNo;
  final int? multipleSelectState;
  final dynamic ogTags;
  final int? onlineLinkEnableBefore;
  final String? pollAnswerText;
  final int? pollType;
  final int? replyChatroomId;
  final int? replyId;
  final int? startTime;
  final int? state;
  final String? temporaryId;
  final int? userId;
  final int? memberId;
  final bool? toShowResults;
  final String? pollTypeText;
  final String? submitTypeText;
  final bool? isTimeStamp;
  final LMChatUserViewData? member;
  final int? replyConversation;
  final LMChatConversationViewData? replyConversationObject;
  final List<LMChatReactionViewData>? conversationReactions;
  final LMChatPollViewData? poll;
*/
extension ConversationViewDataConvertor on Conversation {
  LMChatConversationViewData toConversationViewData() {
    final LMChatConversationViewDataBuilder conversationBuilder =
        LMChatConversationViewDataBuilder()
          ..answer(answer)
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
          ..userId(userId)
          ..memberId(memberId)
          ..toShowResults(toShowResults)
          ..pollTypeText(pollTypeText)
          ..submitTypeText(submitTypeText)
          ..isTimeStamp(isTimeStamp)
          ..member(member?.toUserViewData())
          ..replyConversation(replyConversation)
          ..replyConversationObject(
              replyConversationObject?.toConversationViewData())
        // ..conversationReactions(conversationReactions?.map((LMChatReactionViewData reaction) => reaction.toReactionViewData()).toList())
        // ..poll(poll?.toPollViewData())
        ;

    return conversationBuilder.build();
  }
}

extension ConversationConvertor on LMChatConversationViewData {
  Conversation toConversation() {
    return Conversation(
      answer: answer,
      attachmentsUploaded: attachmentsUploaded!,
      chatroomId: chatroomId!,
      communityId: communityId!,
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
      userId: userId,
      memberId: memberId,
      toShowResults: toShowResults,
      pollTypeText: pollTypeText,
      submitTypeText: submitTypeText,
      isTimeStamp: isTimeStamp,
      member: member?.toUser(),
      replyConversation: replyConversation,
      replyConversationObject: replyConversationObject?.toConversation(),
      // conversationReactions: conversationReactions?.map((LMChatReactionViewData reaction) => reaction.toReaction()).toList(),
      // poll: poll?.toPoll(),
    );
  }
}
