part of '../conversation_bloc.dart';

/// Handler for managing post multimedia conversation event
postMultimediaConversationEventHandler(
  LMChatPostMultiMediaConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  final List<LMChatMediaModel> mediaList = event.mediaFiles.copy();
  try {
    // Generate thumbnails for videos before creating temporary conversation
    for (LMChatMediaModel media in mediaList) {
      if (media.mediaType == LMChatMediaType.video) {
        media.thumbnailFile ??= await getVideoThumbnail(media);
      }
    }

    // Create temporary conversation
    DateTime dateTime = DateTime.now();
    User user = LMChatLocalPreference.instance.getUser();
    String temporaryId = "-${event.postConversationRequest.temporaryId}";

    // Create temporary conversation object
    Conversation temporaryConversation = Conversation(
      answer: event.postConversationRequest.text,
      chatroomId: event.postConversationRequest.chatroomId,
      createdAt: "",
      header: "",
      date: DateFormat('dd MMM yyyy').format(dateTime),
      replyId: event.postConversationRequest.replyId,
      hasFiles: event.postConversationRequest.hasFiles,
      member: user,
      temporaryId: temporaryId,
      id: 1, // Temporary ID for local handling
      memberId: user.id,
      ogTags: event.postConversationRequest.ogTags,
      createdEpoch: dateTime.millisecondsSinceEpoch,
      attachments: mediaList
          .map((media) => media.toAttachmentViewData().toAttachment())
          .toList(),
    );

    // Emit loading state with temporary conversation
    emit(LMChatMultiMediaConversationLoadingState(
      temporaryConversation,
      mediaList,
    ));

    // Handle file uploads
    List<Attachment> uploadedAttachments = [];
    for (int index = 0; index < mediaList.length; index++) {
      LMChatMediaModel media = mediaList[index];
      try {
        // Upload main file
        String? url;
        if (media.mediaFile != null) {
          final response = await LMChatMediaService.uploadFile(
            media.mediaFile!.readAsBytesSync(),
            user.sdkClientInfo?.uuid ?? user.userUniqueId!,
            fileName: media.mediaFile!.path.split('/').last,
            chatroomId: event.postConversationRequest.chatroomId,
          );

          if (response.success) {
            url = response.data;
            media.mediaUrl = url;
          }
        } else {
          url = media.mediaUrl;
        }

        // Handle video thumbnail
        String? thumbnailUrl;
        if (media.mediaType == LMChatMediaType.video) {
          final response = await LMChatMediaService.uploadFile(
            media.thumbnailFile!.readAsBytesSync(),
            user.userUniqueId!,
            fileName: media.thumbnailFile!.path.split('/').last,
            chatroomId: event.postConversationRequest.chatroomId,
          );

          if (response.success) {
            thumbnailUrl = response.data;
            media.thumbnailUrl = thumbnailUrl;
          }
        }

        // Create attachment model
        uploadedAttachments.add(media
            .copyWith(
              mediaUrl: url,
              thumbnailUrl: thumbnailUrl,
              mediaFile: null,
              thumbnailFile: null,
            )
            .toAttachmentViewData()
            .copyWith(index: index)
            .toAttachment());
      } catch (e) {
        _callAnalyticEvent(event);
        emit(LMChatMultiMediaConversationErrorState(
          e.toString(),
          temporaryId,
        ));
        return;
      }
    }

    // Post conversation to server
    final response = await LMChatCore.client.postConversation(
      (PostConversationRequestBuilder()
            ..attachments(uploadedAttachments)
            ..temporaryId(temporaryId)
            ..text(event.postConversationRequest.text)
            ..chatroomId(event.postConversationRequest.chatroomId)
            ..hasFiles(event.postConversationRequest.hasFiles)
            ..replyId(event.postConversationRequest.replyId))
          .build(),
    );
    debugPrint(response.toString());
    if (response.success) {
      emit(LMChatMultiMediaConversationPostedState(
        response.data!,
        mediaList,
      ));

      // Fire analytics event
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.chatroomResponded,
          eventProperties: {
            'chatroom_id': event.postConversationRequest.chatroomId,
            'chatroom_type': 'normal',
            'community_id':
                LMChatLocalPreference.instance.getCommunityData()?.id,
          },
        ),
      );

      LMChatMediaHandler.instance.clearPickedMedia();
      LMChatConversationBloc.instance.lastConversationId = response.data!.id;
    } else {
      _callAnalyticEvent(event);
      emit(LMChatMultiMediaConversationErrorState(
        response.errorMessage!,
        temporaryId,
      ));
    }
  } catch (e) {
    _callAnalyticEvent(event);
    emit(LMChatConversationErrorState(
      "An error occurred",
      event.postConversationRequest.temporaryId,
    ));
  }
}

void _callAnalyticEvent(event) {
  LMChatAnalyticsBloc.instance.add(
    LMChatFireAnalyticsEvent(
      eventName: LMChatAnalyticsKeys.attachmentUploadedError,
      eventProperties: {
        'chatroom_id': event.postConversationRequest.chatroomId,
        'chatroom_type': 'normal',
      },
    ),
  );
}
