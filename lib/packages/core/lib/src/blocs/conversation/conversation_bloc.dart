import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/aws/aws.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class LMChatConversationBloc
    extends Bloc<ConversationEvent, LMChatConversationState> {
  final mediaService = LMChatAWSUtility(!isDebug);
  final DatabaseReference realTime = LMChatRealtime.instance.chatroom();
  int? lastConversationId;
  static LMChatConversationBloc? _instance;
  static LMChatConversationBloc get instance =>
      _instance ??= LMChatConversationBloc._();
  LMChatConversationBloc._() : super(ConversationInitial()) {
    on<InitConversations>(
      (event, emit) {
        debugPrint("Conversations initiated");
        int chatroomId = event.chatroomId;
        lastConversationId = event.conversationId;

        realTime.onValue.listen(
          (event) {
            if (event.snapshot.value != null) {
              final response = event.snapshot.value as Map;
              final conversationId =
                  int.parse(response["collabcard"]["answer_id"]);
              if (lastConversationId != null &&
                  conversationId != lastConversationId) {
                add(UpdateConversations(
                  chatroomId: chatroomId,
                  conversationId: conversationId,
                ));
              }
            }
          },
        );
      },
    );
    on<ConversationEvent>((event, emit) async {
      if (event is LoadConversations) {
        if (event.getConversationRequest.page > 1) {
          emit(ConversationPaginationLoading());
        } else {
          emit(ConversationLoading());
        } //Perform logic
        LMResponse response = await LMChatCore.client
            .getConversation(event.getConversationRequest);
        if (response.success) {
          GetConversationResponse conversationResponse = response.data;
          for (var element in conversationResponse.conversationData!) {
            element.member = conversationResponse
                .userMeta?[element.userId ?? element.memberId];
          }
          for (var element in conversationResponse.conversationData!) {
            String? replyId = element.replyId == null
                ? element.replyConversation?.toString()
                : element.replyId.toString();
            element.replyConversationObject =
                conversationResponse.conversationMeta?[replyId];
            element.replyConversationObject?.member =
                conversationResponse.userMeta?[
                    element.replyConversationObject?.userId ??
                        element.replyConversationObject?.memberId];
          }
          emit(
            ConversationLoaded(conversationResponse),
          );
        } else {
          emit(
            ConversationError(response.errorMessage!, ''),
          );
        }
      }
    });

    on<PostConversation>((event, emit) async {
      await mapPostConversationFunction(
        event,
        emit,
      );
    });
    on<PostMultiMediaConversation>(
      (event, emit) async {
        await mapPostMultiMediaConversation(
          event,
          emit,
        );
      },
    );
    on<UpdateConversations>(
      (event, emit) async {
        if (lastConversationId != null &&
            event.conversationId != lastConversationId) {
          int maxTimestamp = DateTime.now().millisecondsSinceEpoch;
          final response = await LMChatCore.client
              .getConversation((GetConversationRequestBuilder()
                    ..chatroomId(event.chatroomId)
                    ..minTimestamp(0)
                    ..maxTimestamp(maxTimestamp * 1000)
                    ..isLocalDB(false)
                    ..page(1)
                    ..pageSize(5)
                    ..conversationId(event.conversationId))
                  .build());
          if (response.success) {
            GetConversationResponse conversationResponse = response.data!;
            for (var element in conversationResponse.conversationData!) {
              element.member = conversationResponse
                  .userMeta?[element.userId ?? element.memberId];
            }
            for (var element in conversationResponse.conversationData!) {
              String? replyId = element.replyId == null
                  ? element.replyConversation?.toString()
                  : element.replyId.toString();
              element.replyConversationObject =
                  conversationResponse.conversationMeta?[replyId];
              element.replyConversationObject?.member =
                  conversationResponse.userMeta?[
                      element.replyConversationObject?.userId ??
                          element.replyConversationObject?.memberId];
            }
            Conversation realTimeConversation =
                response.data!.conversationData!.first;
            if (response.data!.conversationMeta != null &&
                realTimeConversation.replyId != null) {
              Conversation? replyConversationObject = response.data!
                  .conversationMeta![realTimeConversation.replyId.toString()];
              realTimeConversation.replyConversationObject =
                  replyConversationObject;
            }
            emit(
              ConversationUpdated(
                response: realTimeConversation,
              ),
            );

            lastConversationId = event.conversationId;
          }
        }
      },
    );
  }

  mapPostMultiMediaConversation(
    PostMultiMediaConversation event,
    Emitter<LMChatConversationState> emit,
  ) async {
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
        if (postConversationResponse.success) {
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
                if (!uploadFileResponse.data!.success) {
                  emit(
                    MultiMediaConversationError(
                      uploadFileResponse.data!.errorMessage!,
                      event.postConversationRequest.temporaryId,
                    ),
                  );
                } else {
                  LMChatMedia mediaItem =
                      LMChatMedia.fromJson(putMediaRequest.toJson());
                  mediaItem.mediaFile = media.mediaFile;
                  mediaItem.thumbnailFile = media.thumbnailFile;
                  fileLink.add(mediaItem);
                }
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
              postConversationResponse.errorMessage!,
              event.postConversationRequest.temporaryId,
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

  mapPostConversationFunction(
      PostConversation event, Emitter<LMChatConversationState> emit) async {
    try {
      DateTime dateTime = DateTime.now();
      User user = LMChatPreferences.instance.getUser()!;
      Conversation conversation = Conversation(
        answer: event.postConversationRequest.text,
        chatroomId: event.postConversationRequest.chatroomId,
        createdAt: "",
        userId: user.id,
        header: "",
        date: "${dateTime.day} ${dateTime.month} ${dateTime.year}",
        replyId: event.postConversationRequest.replyId,
        attachmentCount: event.postConversationRequest.attachmentCount,
        replyConversationObject: event.repliedTo,
        hasFiles: event.postConversationRequest.hasFiles,
        member: user,
        temporaryId: event.postConversationRequest.temporaryId,
        id: 1,
      );
      emit(LocalConversation(conversation));
      LMResponse<PostConversationResponse> response =
          await LMChatCore.client.postConversation(
        event.postConversationRequest,
      );

      if (response.success) {
        if (response.data!.success) {
          Conversation conversation = response.data!.conversation!;
          if (conversation.replyId != null ||
              conversation.replyConversation != null) {
            conversation.replyConversationObject = event.repliedTo;
          }
          emit(ConversationPosted(response.data!));
        } else {
          emit(
            ConversationError(
              response.data!.errorMessage!,
              event.postConversationRequest.temporaryId,
            ),
          );
          return false;
        }
      } else {
        emit(
          ConversationError(
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
}
