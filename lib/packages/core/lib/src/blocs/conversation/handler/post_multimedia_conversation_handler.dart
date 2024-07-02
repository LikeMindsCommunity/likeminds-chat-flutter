part of '../conversation_bloc.dart';

/// Handler for managing post conversation event
postMultimediaConversationEventHandler(
  LMChatPostMultiMediaConversationEvent event,
  Emitter<LMChatConversationState> emit,
) async {
  final mediaService = LMChatAWSUtility(!isDebug);
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
        event.mediaFiles,
      ),
    );
    LMResponse<PostConversationResponse> response =
        await LMChatCore.client.postConversation(
      event.postConversationRequest,
    );

    if (response.success) {
      PostConversationResponse postConversationResponse = response.data!;
      if (event.mediaFiles.length == 1 &&
          event.mediaFiles.first.mediaType == LMChatMediaType.link) {
        emit(
          LMChatMultiMediaConversationPostedState(
            postConversationResponse,
            event.mediaFiles,
          ),
        );
      } else {
        List<LMChatMedia> fileLink = [];
        int length = event.mediaFiles.length;
        for (int i = 0; i < length; i++) {
          LMChatMedia media = event.mediaFiles[i];
          String? url = await mediaService.uploadFile(
            media.mediaFile!,
            event.postConversationRequest.chatroomId,
            postConversationResponse.conversation!.id,
          );
          String? thumbnailUrl;
          if (media.mediaType == LMChatMediaType.video) {
            // If the thumbnail file is not present in media object
            // then generate the thumbnail and upload it to the server
            if (media.thumbnailFile == null) {
              await getVideoThumbnail(media);
            }
            thumbnailUrl = await mediaService.uploadFile(
              media.thumbnailFile!,
              event.postConversationRequest.chatroomId,
              postConversationResponse.conversation!.id,
            );
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
                })
                ..type(attachmentType)
                ..thumbnailUrl(thumbnailUrl)
                ..url(url!))
              .build();
          LMResponse<PutMediaResponse> uploadFileResponse =
              await LMChatCore.client.putMultimedia(putMediaRequest);
          if (!uploadFileResponse.success) {
            emit(
              LMChatMultiMediaConversationErrorState(
                uploadFileResponse.errorMessage!,
                event.postConversationRequest.temporaryId,
              ),
            );
          } else {
            emit(
              LMChatMultiMediaConversationErrorState(
                uploadFileResponse.errorMessage!,
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
            fileLink,
          ),
        );
      }
    } else {
      emit(
        LMChatMultiMediaConversationErrorState(
          response.errorMessage!,
          event.postConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  } catch (e) {
    emit(
      LMChatConversationErrorState(
        "An error occurred",
        event.postConversationRequest.temporaryId,
      ),
    );
    return false;
  }
}
