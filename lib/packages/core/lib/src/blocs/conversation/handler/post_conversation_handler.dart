part of '../conversation_bloc.dart';

/// Handler for managing post conversation event
postConversationEventHandler(
  LMChatPostConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  final DateTime dateTime = DateTime.now();
  final tempId = dateTime.toString();
  try {
    User user = LMChatLocalPreference.instance.getUser();
    LMChatConversationViewData conversationViewData =
        (LMChatConversationViewDataBuilder()
              ..answer(event.text)
              ..chatroomId(event.chatroomId)
              ..createdAt("")
              ..memberId(user.id)
              ..header("")
              ..date("${dateTime.day} ${dateTime.month} ${dateTime.year}")
              ..replyId(event.replyId)
              ..attachmentCount(event.attachmentCount)
              ..replyConversationObject(event.repliedTo)
              ..hasFiles(event.hasFiles)
              ..member(user.toUserViewData())
              ..temporaryId(tempId)
              ..id(1))
            .build();

    emit(LMChatLocalConversationState(conversationViewData));

    final PostConversationRequestBuilder postConversationRequest =
        PostConversationRequestBuilder()
          ..chatroomId(event.chatroomId)
          ..text(event.text)
          ..replyId(event.replyId)
          ..temporaryId(tempId);
    if (event.replyId == null &&
        event.shareLink != null &&
        event.shareLink!.isNotEmpty) {
      postConversationRequest.shareLink(event.shareLink!);
    }
    LMResponse<PostConversationResponse> response =
        await LMChatCore.client.postConversation(
      postConversationRequest.build(),
    );

    if (response.success && response.data != null) {
      Conversation conversation = response.data!.conversation!;
      conversationViewData = conversation.toConversationViewData();
      if (conversation.replyId != null ||
          conversation.replyConversation != null) {
        conversationViewData = conversationViewData.copyWith(
          replyConversationObject: event.repliedTo,
        );
      }
      emit(LMChatConversationPostedState(conversationViewData));
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.chatroomResponded,
          eventProperties: {
            'chatroom_id': event.chatroomId,
            'chatroom_type': 'normal',
            'community_id':
                LMChatLocalPreference.instance.getCommunityData()?.id,
          },
        ),
      );
      LMChatConversationBloc.instance.lastConversationId = conversation.id;
      return false;
    } else {
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.messageSendingError,
          eventProperties: {
            'chatroom_id': event.chatroomId,
            'chatroom_type': 'normal',
          },
        ),
      );
      emit(LMChatConversationErrorState(
        response.errorMessage!,
        tempId,
      ));
      return false;
    }
  } catch (e) {
    LMChatAnalyticsBloc.instance.add(
      LMChatFireAnalyticsEvent(
        eventName: LMChatAnalyticsKeys.messageSendingError,
        eventProperties: {
          'chatroom_id': event.chatroomId,
          'chatroom_type': 'normal',
        },
      ),
    );
    emit(LMChatConversationErrorState(
      "An error occurred",
      tempId,
    ));
    return false;
  }
}
