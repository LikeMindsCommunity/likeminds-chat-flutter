part of 'conversation_action_bloc.dart';

@immutable
abstract class ConversationActionEvent extends Equatable {}

class EditConversation extends ConversationActionEvent {
  final EditConversationRequest editConversationRequest;
  final Conversation? replyConversation;

  EditConversation(this.editConversationRequest, {this.replyConversation});

  @override
  List<Object> get props => [
        editConversationRequest,
      ];
}

class EditingConversation extends ConversationActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation editConversation;

  EditingConversation({
    required this.conversationId,
    required this.chatroomId,
    required this.editConversation,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        editConversation,
      ];
}

class EditRemove extends ConversationActionEvent {
  @override
  List<Object> get props => [];
}

class DeleteConversation extends ConversationActionEvent {
  final DeleteConversationRequest deleteConversationRequest;

  DeleteConversation(this.deleteConversationRequest);

  @override
  List<Object> get props => [
        deleteConversationRequest,
      ];
}

class ReplyConversation extends ConversationActionEvent {
  final int conversationId;
  final int chatroomId;
  final Conversation replyConversation;

  ReplyConversation({
    required this.conversationId,
    required this.chatroomId,
    required this.replyConversation,
  });

  @override
  List<Object> get props => [
        conversationId,
        chatroomId,
        replyConversation,
      ];
}

class ReplyRemove extends ConversationActionEvent {
  final int time = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [time];
}

// class NewConversation extends ConversationActionEvent {
//   final int chatroomId;
//   final int conversationId;

//   NewConversation({
//     required this.chatroomId,
//     required this.conversationId,
//   });

//   @override
//   List<Object> get props => [
//         chatroomId,
//         conversationId,
//       ];
// }

// class UpdateConversationList extends ConversationActionEvent {
//   final int conversationId;
//   final int chatroomId;

//   UpdateConversationList({
//     required this.conversationId,
//     required this.chatroomId,
//   });

//   @override
//   List<Object> get props => [
//         conversationId,
//         chatroomId,
//       ];
// }
