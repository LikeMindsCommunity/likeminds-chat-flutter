import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

part 'conversation_action_event.dart';
part 'conversation_action_state.dart';
part 'handler/delete_conversation_event_handler.dart';
part 'handler/edit_conversation_event_handler.dart';
part 'handler/reply_conversation_event_handler.dart';

/// [LMChatConversationActionBloc] is responsible for handling the conversation actions.
/// It extends [Bloc] and uses [LMChatConversationActionEvent] and [LMChatConversationActionState].
/// It has a singleton instance [instance] which is used to access the bloc.
class LMChatConversationActionBloc
    extends Bloc<LMChatConversationActionEvent, LMChatConversationActionState> {
  static LMChatConversationActionBloc? _instance;

  /// Singleton instance of [LMChatConversationActionBloc]
  static LMChatConversationActionBloc get instance =>
      _instance ??= LMChatConversationActionBloc._();
  LMChatConversationActionBloc._() : super(LMChatConversationActionInitial()) {
    // map the events to the event handlers
    on<LMChatEditConversationEvent>(_editConversationEventHandler);
    on<LMChatEditingConversationEvent>(_editingConversationEventHandler);
    on<LMChatEditRemoveEvent>(_editRemoveEventHandler);
    on<LMChatReplyConversationEvent>(_replyEventHandler);
    on<LMChatReplyRemoveEvent>(_replyRemoveEventHandler);
    on<LMChatDeleteConversationEvent>(_deleteConversationEventHandler);
  }
}
