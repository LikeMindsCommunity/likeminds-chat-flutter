part of '../conversation_bloc.dart';

/// Handler for managing post conversation event
postMultimediaConversationEventHandler(
  LMChatPostMultiMediaConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  // final mediaService = LMChatMediaService.instance;
  final List<LMChatMediaModel> mediaList = event.mediaFiles.copy();
  try {
    DateTime dateTime = DateTime.now();
    User user = LMChatLocalPreference.instance.getUser();
    Conversation conversation = Conversation(
      answer: event.postConversationRequest.text,
      chatroomId: event.postConversationRequest.chatroomId,
      createdAt: "",
      header: "",
      date: "${dateTime.day} ${dateTime.month} ${dateTime.year}",
      replyId: event.postConversationRequest.replyId,
      attachmentCount: event.postConversationRequest.attachmentCount,
      hasFiles: event.postConversationRequest.hasFiles,
      member: user,
      temporaryId: event.postConversationRequest.temporaryId,
      id: 1,
      memberId: user.id,
      ogTags: event.postConversationRequest.ogTags,
    );

    emit(
      LMChatMultiMediaConversationLoadingState(
        conversation,
        mediaList,
      ),
    );
    LMResponse<PostConversationResponse> response =
        await LMChatCore.client.postConversation(event.postConversationRequest);

    if (response.success) {
      PostConversationResponse postConversationResponse = response.data!;
      if (event.mediaFiles.length == 1 &&
          event.mediaFiles.first.mediaType == LMChatMediaType.link) {
        emit(
          LMChatMultiMediaConversationPostedState(
            postConversationResponse,
            mediaList,
          ),
        );
      } else {
        int length = event.mediaFiles.length;
        for (int i = 0; i < length; i++) {
          LMChatMediaModel media = event.mediaFiles[i];

          try {
            String? url;
            if (media.mediaFile != null) {
              final response = await LMChatMediaService.uploadFile(
                media.mediaFile!.readAsBytesSync(),
                LMChatLocalPreference.instance.getUser().userUniqueId!,
                fileName: media.mediaFile!.path.split('/').last,
                chatroomId: event.postConversationRequest.chatroomId,
                conversationId: postConversationResponse.conversation!.id,
              );

              if (response.success) {
                url = response.data;
              }
            } else {
              url = media.mediaUrl;
            }

            String? thumbnailUrl;
            if (media.mediaType == LMChatMediaType.video) {
              // If the thumbnail file is not present in media object
              // then generate the thumbnail and upload it to the server
              if (media.thumbnailFile == null) {
                await getVideoThumbnail(media);
              }
              final response = await LMChatMediaService.uploadFile(
                media.thumbnailFile!.readAsBytesSync(),
                LMChatLocalPreference.instance.getUser().userUniqueId!,
                chatroomId: event.postConversationRequest.chatroomId,
                conversationId: postConversationResponse.conversation!.id,
              );
              thumbnailUrl = response.data;
            }

            String attachmentType = mapMediaTypeToString(media.mediaType);
            PutMediaRequest putMediaRequest = (PutMediaRequestBuilder()
                  ..conversationId(postConversationResponse.conversation!.id)
                  ..filesCount(length)
                  ..index(i)
                  ..height(media.height)
                  ..width(media.width)
                  ..meta({
                    'size': media.size,
                    'number_of_page': media.pageCount,
                    'file_name': media.mediaFile!.path.split('/').last,
                    'duration': media.duration,
                  })
                  ..type(attachmentType)
                  ..url(url!)
                  ..thumbnailUrl(thumbnailUrl))
                .build();
            LMResponse<PutMediaResponse> uploadFileResponse =
                await LMChatCore.client.putMultimedia(putMediaRequest);
            if (!uploadFileResponse.success) {
              _callAnalyticEvent(event);
              emit(
                LMChatMultiMediaConversationErrorState(
                  uploadFileResponse.errorMessage!,
                  event.postConversationRequest.temporaryId,
                ),
              );
            }
          } on Exception catch (e) {
            _callAnalyticEvent(event);
            emit(
              LMChatMultiMediaConversationErrorState(
                e.toString(),
                event.postConversationRequest.temporaryId,
              ),
            );
          }
        }
        LMChatConversationBloc.instance.lastConversationId =
            response.data!.conversation!.id;
        emit(
          LMChatMultiMediaConversationPostedState(
            postConversationResponse,
            mediaList,
          ),
        );
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
      }
    } else {
      _callAnalyticEvent(event);
      emit(
        LMChatMultiMediaConversationErrorState(
          response.errorMessage!,
          event.postConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  } catch (e) {
    _callAnalyticEvent(event);
    emit(
      LMChatConversationErrorState(
        "An error occurred",
        event.postConversationRequest.temporaryId,
      ),
    );
    return false;
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
