import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [ConversationViewDataConvertor] is an extension on [Conversation] class.
/// It converts [Conversation] to [LMChatConversationViewData].
extension ConversationViewDataConvertor on Conversation {
  /// Converts [Conversation] to [LMChatConversationViewData]
  LMChatConversationViewData toConversationViewData({
    Map<String, List<PollOption>>? conversationPollsMeta,
    Map<String, List<Attachment>>? attachmentMeta,
    Map<String, Conversation>? conversationMeta,
    Map<String, List<Reaction>>? reactionMeta,
    Map<int, User>? userMeta,
    Map<String, LMWidgetData>? widgets,
  }) {
    // get member from userMeta
    final LMChatUserViewData? member =
        this.member?.toUserViewData() ?? userMeta?[memberId]?.toUserViewData();

    // get replyConversationObject from conversationMeta
    final LMChatConversationViewData? replyConversation =
        replyConversationObject?.toConversationViewData(
              conversationPollsMeta: conversationPollsMeta,
              userMeta: userMeta,
              attachmentMeta: attachmentMeta,
              reactionMeta: reactionMeta,
              conversationMeta: conversationMeta,
              widgets: widgets,
            ) ??
            conversationMeta?[replyId.toString()]?.toConversationViewData(
              conversationPollsMeta: conversationPollsMeta,
              userMeta: userMeta,
              attachmentMeta: attachmentMeta,
              reactionMeta: reactionMeta,
              conversationMeta: conversationMeta,
              widgets: widgets,
            );
    // get attachments from attachmentMeta
    final List<LMChatAttachmentViewData>? attachments =
        attachmentMeta?[id.toString()]
            ?.map((e) => e.toAttachmentViewData())
            .toList();
    // get reactions from reactionMeta
    final List<LMChatReactionViewData>? conversationReactions =
        reactionMeta?[id.toString()]
            ?.map((e) => e.toReactionViewData())
            .toList();

    LMChatConversationViewDataBuilder conversationBuilder =
        LMChatConversationViewDataBuilder()
          ..allowAddOption(allowAddOption)
          ..answer(answer)
          ..attachmentCount(attachmentCount)
          ..attachments(attachments ??
              this.attachments?.map((e) => e.toAttachmentViewData()).toList())
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
          ..multipleSelectState(
              LMChatPollMultiSelectState.fromValue(multipleSelectState))
          ..onlineLinkEnableBefore(onlineLinkEnableBefore)
          ..pollAnswerText(pollAnswerText)
          ..pollType(LMChatPollType.fromValue(pollType))
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
          ..member(member)
          ..replyConversation(this.replyConversation)
          ..replyConversationObject(
            replyConversation ??
                replyConversationObject?.toConversationViewData(
                  conversationPollsMeta: conversationPollsMeta,
                  userMeta: userMeta,
                  attachmentMeta: attachmentMeta,
                  reactionMeta: reactionMeta,
                  conversationMeta: conversationMeta,
                  widgets: widgets,
                ),
          )
          ..ogTags(ogTags?.toLMChatOGTagViewData())
          ..hasReactions(hasReactions)
          ..conversationReactions(conversationReactions ??
              this
                  .conversationReactions
                  ?.map((e) => e.toReactionViewData())
                  .toList())
          ..poll(this
              .polls
              ?.map((e) => e.toPollOptionViewData(
                    userMeta: userMeta,
                  ))
              .toList())
          ..noPollExpiry(noPollExpiry)
          ..allowVoteChange(allowVoteChange);

    String? widgetId = this.widgetId;
    LMChatWidgetViewData? widget;

    if (widgetId != null) {
      LMChatWidgetViewData? widgetsViewDataMeta =
          widgets?[widgetId]?.toWidgetViewData();

      conversationBuilder.widgetId(widgetId);
      conversationBuilder.widget(widgetsViewDataMeta);
    }

    final polls = conversationPollsMeta?[id.toString()];
    if (polls != null) {
      polls.sort((a, b) => a.id!.compareTo(b.id!));
    }
    if (polls != null) {
      conversationBuilder.poll(polls
          .map((e) => e.toPollOptionViewData(
                userMeta: userMeta,
              ))
          .toList());
    }
    return conversationBuilder.build();
  }
}

/// [ConversationConvertor] is an extension on [LMChatConversationViewData] class.
/// It converts [LMChatConversationViewData] to [Conversation].
extension ConversationConvertor on LMChatConversationViewData {
  /// Converts [LMChatConversationViewData] to [Conversation]
  Conversation toConversation() {
    return Conversation(
      allowAddOption: allowAddOption,
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
      multipleSelectState: multipleSelectState?.value,
      onlineLinkEnableBefore: onlineLinkEnableBefore,
      pollAnswerText: pollAnswerText,
      pollType: pollType?.value,
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
      hasReactions: hasReactions,
      conversationReactions: conversationReactions
          ?.map((LMChatReactionViewData reaction) => reaction.toReaction())
          .toList(),
      // poll: poll?.toPoll(),
      noPollExpiry: noPollExpiry,
      allowVoteChange: allowVoteChange,
      widgetId: widgetId,
    );
  }
}
