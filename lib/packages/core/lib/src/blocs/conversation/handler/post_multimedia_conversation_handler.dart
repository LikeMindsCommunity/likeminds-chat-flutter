part of '../conversation_bloc.dart';

mapPostMultiMediaConversation(
  PostMultiMediaConversation event,
  Emitter<LMChatConversationState> emit,
) async {
  final mediaService = LMChatAWSUtility(!isDebug);
  int? lastConversationId;
  try {
    DateTime dateTime = DateTime.now();
    User user = LMChatPreferences.instance.getUser()!;
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
      userId: user.id,
      ogTags: event.postConversationRequest.ogTags,
    );

    emit(
      MultiMediaConversationLoading(
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
          MultiMediaConversationPosted(
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
              MultiMediaConversationError(
                uploadFileResponse.errorMessage!,
                event.postConversationRequest.temporaryId,
              ),
            );
          } else {
            emit(
              MultiMediaConversationError(
                uploadFileResponse.errorMessage!,
                event.postConversationRequest.temporaryId,
              ),
            );
          }
        }
        lastConversationId = response.data!.conversation!.id;
        emit(
          MultiMediaConversationPosted(
            postConversationResponse,
            fileLink,
          ),
        );
      }
    } else {
      emit(
        MultiMediaConversationError(
          response.errorMessage!,
          event.postConversationRequest.temporaryId,
        ),
      );
      return false;
    }
  } catch (e) {
    emit(
      ConversationError(
        "An error occurred",
        event.postConversationRequest.temporaryId,
      ),
    );
    return false;
  }
}
