part of 'conversation_action_bloc.dart';

@immutable
abstract class ConversationActionState extends Equatable {}

class ConversationActionInitial extends ConversationActionState {
  @override
  List<Object> get props => [];
}

class ConversationActionError extends ConversationActionState {
  final String temporaryId;
  final String errorMessage;

  ConversationActionError(this.errorMessage, this.temporaryId);

  @override
  List<Object> get props => [
        temporaryId,
        errorMessage,
      ];
}

class ConversationEdited extends ConversationActionState {
  final EditConversationResponse editConversationResponse;

  ConversationEdited(
    this.editConversationResponse,
  );

  @override
  List<Object> get props => [
        editConversationResponse,
      ];
}

class ConversationDelete extends ConversationActionState {
  final DeleteConversationResponse deleteConversationResponse;

  ConversationDelete(
    this.deleteConversationResponse,
  );

  @override
  List<Object> get props => [
        deleteConversationResponse,
      ];
}

class ConversationDeleteError extends ConversationActionState {
  final String errorMessage;

  ConversationDeleteError(this.errorMessage);

  @override
  List<Object> get props => [
        errorMessage,
      ];
}

class ReplyConversationState extends ConversationActionState {
  final int chatroomId;
  final int conversationId;
  final Conversation conversation;

  ReplyConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.conversation,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
      ];
}

class ReplyRemoveState extends ConversationActionState {
  final int time = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [time];
}

class EditConversationState extends ConversationActionState {
  final int chatroomId;
  final int conversationId;
  final Conversation editConversation;

  EditConversationState({
    required this.chatroomId,
    required this.conversationId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        chatroomId,
        conversationId,
        editConversation.toEntity().toJson(),
      ];
}

class EditRemoveState extends ConversationActionState {
  @override
  List<Object> get props => [];
}
