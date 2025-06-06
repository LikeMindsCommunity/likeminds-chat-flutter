import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/analytics/analytics_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

part 'conversation_action_event.dart';
part 'conversation_action_state.dart';
part 'handler/delete_conversation_event_handler.dart';
part 'handler/edit_conversation_event_handler.dart';
part 'handler/reply_conversation_event_handler.dart';
part 'handler/refresh_bar_event_handler.dart';
part 'handler/text_change_event_handler.dart';
part 'handler/link_preview_removed_event_handler.dart';
part 'handler/put_reaction_handler.dart';
part 'handler/delete_reaction_handler.dart';
part 'handler/search_conversation_chatroom_handler.dart';

/// {@template lm_chat_conversation_action_bloc}
/// [LMChatConversationActionBloc] is responsible for handling the conversation actions.
/// It extends [Bloc] and uses [LMChatConversationActionEvent] and [LMChatConversationActionState].
/// It has a singleton instance [instance] which is used to access the bloc.
/// {@endtemplate}
class LMChatConversationActionBloc
    extends Bloc<LMChatConversationActionEvent, LMChatConversationActionState> {
  /// Singleton instance of [LMChatConversationActionBloc]
  static LMChatConversationActionBloc? _instance;

  /// {@macro lm_chat_conversation_action_bloc}
  static LMChatConversationActionBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatConversationActionBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatConversationActionBloc._() : super(LMChatConversationActionInitial()) {
    // map the events to the event handlers
    on<LMChatEditConversationEvent>(_editConversationEventHandler);
    on<LMChatEditingConversationEvent>(_editingConversationEventHandler);
    on<LMChatEditRemoveEvent>(_editRemoveEventHandler);
    on<LMChatReplyConversationEvent>(_replyEventHandler);
    on<LMChatReplyRemoveEvent>(_replyRemoveEventHandler);
    on<LMChatDeleteConversationEvent>(_deleteConversationEventHandler);
    on<LMChatRefreshBarEvent>(_refreshBarEventHandler);
    on<LMChatConversationTextChangeEvent>(_textChangeEventHandler);
    on<LMChatLinkPreviewRemovedEvent>(_linkPreviewRemovedEventHandler);
    on<LMChatPutReaction>(_putReactionHandler);
    on<LMChatDeleteReaction>(_deleteReactionHandler);
    on<LMChatSearchConversationInChatroomEvent>(
        _searchConversationInChatroomEventHandler);
  }
  @override
  Future<void> close() {
    _instance = null;
    return super.close();
  }
}
