import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:meta/meta.dart';

part 'conversation_action_event.dart';
part 'conversation_action_state.dart';

/// [LMChatConversationActionBloc] is responsible for handling the conversation actions.
/// It extends [Bloc] and uses [LMChatConversationActionEvent] and [ConversationActionState].
/// It has a singleton instance [instance] which is used to access the bloc.
class LMChatConversationActionBloc
    extends Bloc<LMChatConversationActionEvent, ConversationActionState> {
  static LMChatConversationActionBloc? _instance;
  /// Singleton instance of [LMChatConversationActionBloc]
  static LMChatConversationActionBloc get instance =>
      _instance ??= LMChatConversationActionBloc._();
  LMChatConversationActionBloc._() : super(ConversationActionInitial()) {
    on<LMChatEditConversationEvent>(
      (event, emit) async {
        await mapEditConversation(
          event,
          emit,
        );
      },
    );
    on<LMChatEditingConversationEvent>(
      (event, emit) async {
        emit(EditConversationState(
          chatroomId: event.chatroomId,
          conversationId: event.conversationId,
          editConversation: event.editConversation,
        ));
      },
    );
    on<LMChatEditRemoveEvent>((event, emit) => emit(EditRemoveState()));
    on<LMChatReplyConversationEvent>((event, emit) async {
      emit(ReplyConversationState(
        chatroomId: event.chatroomId,
        conversationId: event.conversationId,
        conversation: event.replyConversation,
      ));
    });
    on<LMChatReplyRemoveEvent>((event, emit) => emit(ReplyRemoveState()));
    on<LMChatDeleteConversationEvent>(_deleteConversationEventHandler);
  }

  _deleteConversationEventHandler(
      LMChatDeleteConversationEvent event, emit) async {
        debugPrint(event.conversationIds.toString());
    // create delete conversation request
    try {
      final DeleteConversationRequestBuilder deleteConversationRequestBuilder =
          DeleteConversationRequestBuilder()
            ..conversationIds(event.conversationIds)
            ..reason(event.reason);
      final response = await LMChatCore.client
          .deleteConversation(deleteConversationRequestBuilder.build());
      if (response.success) {
        emit(ConversationDelete(response.data!));
      } else {
        emit(ConversationDeleteError(
            response.errorMessage ?? 'An error occurred'));
      }
    } on Exception catch (e) {
      emit(ConversationDeleteError(e.toString()));
    }
  }

  mapEditConversation(LMChatEditConversationEvent event,
      Emitter<ConversationActionState> emit) async {
    emit(EditRemoveState());
    try {
      LMResponse<EditConversationResponse> response =
          await LMChatCore.client.editConversation(
        event.editConversationRequest,
      );

      if (response.success) {
        Conversation conversation = response.data!.conversation!;
        if (conversation.replyId != null ||
            conversation.replyConversation != null) {
          conversation.replyConversationObject = event.replyConversation;
        }
        emit(
          ConversationEdited(response.data!),
        );
      } else {
        emit(
          ConversationActionError(
            response.errorMessage!,
            event.editConversationRequest.conversationId.toString(),
          ),
        );
        return false;
      }
    } catch (e) {
      emit(
        ConversationActionError(
          "An error occurred while editing the message",
          event.editConversationRequest.conversationId.toString(),
        ),
      );
      return false;
    }
  }
}
