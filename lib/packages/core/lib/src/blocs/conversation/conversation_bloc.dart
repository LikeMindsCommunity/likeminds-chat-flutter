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

part 'handler/post_conversation_handler.dart';
part 'handler/post_multimedia_conversation_handler.dart';

class LMChatConversationBloc
    extends Bloc<LMChatConversationEvent, LMChatConversationState> {
  final mediaService = LMChatAWSUtility(!isDebug);
  final DatabaseReference realTime = LMChatRealtime.instance.chatroom();
  int? lastConversationId;
  static LMChatConversationBloc? _instance;
  static LMChatConversationBloc get instance =>
      _instance ??= LMChatConversationBloc._();
  LMChatConversationBloc._() : super(ConversationInitial()) {
    // on<InitConversations>(
    // (event, emit) {
    // debugPrint("Conversations initiated");
    // int chatroomId = event.chatroomId;
    // lastConversationId = event.conversationId;

    //   realTime.onValue.listen(
    //     (event) {
    //       if (event.snapshot.value != null) {
    //         final response = event.snapshot.value as Map;
    //         final conversationId =
    //             int.parse(response["collabcard"]["answer_id"]);
    //         if (lastConversationId != null &&
    //             conversationId != lastConversationId) {
    //           add(UpdateConversations(
    //             chatroomId: chatroomId,
    //             conversationId: conversationId,
    //           ));
    //         }
    //       }
    //     },
    //   );
    // },
    // );
    on<LMChatConversationEvent>((event, emit) async {
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
          emit(ConversationLoaded(conversationResponse));
        } else {
          emit(ConversationError(response.errorMessage!, ''));
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
}
