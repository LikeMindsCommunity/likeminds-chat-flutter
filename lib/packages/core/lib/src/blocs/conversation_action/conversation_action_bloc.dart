import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:meta/meta.dart';

part 'conversation_action_event.dart';
part 'conversation_action_state.dart';

class LMChatConversationActionBloc
    extends Bloc<ConversationActionEvent, ConversationActionState> {
  static LMChatConversationActionBloc? _instance;
  static LMChatConversationActionBloc get instance =>
      _instance ??= LMChatConversationActionBloc._();
  LMChatConversationActionBloc._() : super(ConversationActionInitial()) {
    on<EditConversation>(
      (event, emit) async {
        await mapEditConversation(
          event,
          emit,
        );
      },
    );
    on<EditingConversation>(
      (event, emit) async {
        emit(EditConversationState(
          chatroomId: event.chatroomId,
          conversationId: event.conversationId,
          editConversation: event.editConversation,
        ));
      },
    );
    on<EditRemove>((event, emit) => emit(EditRemoveState()));
    on<ReplyConversation>((event, emit) async {
      emit(ReplyConversationState(
        chatroomId: event.chatroomId,
        conversationId: event.conversationId,
        conversation: event.replyConversation,
      ));
    });
    on<ReplyRemove>((event, emit) => emit(ReplyRemoveState()));
    on<DeleteConversation>(
      (event, emit) async {
        final response = await LMChatCore.client
            .deleteConversation((DeleteConversationRequestBuilder()
                  ..conversationIds(
                      event.deleteConversationRequest.conversationIds)
                  ..reason("Delete"))
                .build());
        if (response.success) {
          emit(ConversationDelete(response.data!));
        } else {
          emit(ConversationDeleteError(
              response.errorMessage ?? 'An error occured'));
        }
      },
    );
  }

  mapEditConversation(
      EditConversation event, Emitter<ConversationActionState> emit) async {
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
