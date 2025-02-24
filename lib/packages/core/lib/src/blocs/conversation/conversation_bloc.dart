import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/services/media_service.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

part 'handler/post_conversation_handler.dart';
part 'handler/post_multimedia_conversation_handler.dart';
part 'handler/fetch_conversation_handler.dart';
part 'handler/update_conversation_handler.dart';
part 'handler/initialise_conversations_handler.dart';
part 'handler/local_conversation_handler.dart';
part 'handler/post_poll_handler.dart';

/// LMChatConversationBloc is the BLoC that manages conversations
///
/// It is used to fetch, refresh, and post conversations.
///
/// Uses a combination of LMChatConversationEvent, and LMChatVonversationState objects.
class LMChatConversationBloc
    extends Bloc<LMChatConversationEvent, LMChatConversationState> {
  /// Last conversation id for this instance of [LMChatConversationBloc]
  int? lastConversationId;

  final DatabaseReference realTime = LMChatRealtime.instance.chatroom();

  static LMChatConversationBloc? _instance;
  static int? _currentChatroomId;

  /// The reply conversation if user taps on reply and is not present in the current list
  static LMChatConversationViewData? replyConversation;

  /// Creates and maintains a singleton instance of this BLoC
  static LMChatConversationBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatConversationBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatConversationBloc._() : super(LMChatConversationInitialState()) {
    // Handle initialise conversation event through handler
    on<LMChatInitialiseConversationsEvent>(initialiseConversationsEventHandler);
    // Handle fetch conversation events through handler
    on<LMChatFetchConversationsEvent>(fetchConversationsEventHandler);
    // Handle post conversation event through handler
    on<LMChatPostConversationEvent>(postConversationEventHandler);
    // Handle post multimedia conversation event through handler
    on<LMChatPostMultiMediaConversationEvent>(
        postMultimediaConversationEventHandler);
    // Handle update conversations event through handler
    on<LMChatUpdateConversationsEvent>(updateConversationsEventHandler);
    // Handle adding of local conversation through handler
    on<LMChatLocalConversationEvent>(localConversationEventHandler);
    // Handle posting of poll conversation through handler
    on<LMChatPostPollConversationEvent>(postPollConversationHandler);
  }

  @override
  Future<void> close() {
    _currentChatroomId = null;
    LMChatConversationBloc.replyConversation = null;
    return super.close();
  }

  initialiseConversationsEventHandler(
    LMChatInitialiseConversationsEvent event,
    Emitter<LMChatConversationState> emit,
  ) async {
    _currentChatroomId = event.chatroomId;
    lastConversationId = event.conversationId;

    realTime.onChildChanged.listen(
      (event) {
        if (event.snapshot.value != null && _currentChatroomId != null) {
          final response = event.snapshot.value as Map;
          final conversationId = int.tryParse(response["answer_id"]);
          if (lastConversationId != null &&
              conversationId != lastConversationId &&
              conversationId != null) {
            LMChatConversationBloc.instance.add(LMChatUpdateConversationsEvent(
              chatroomId: _currentChatroomId!,
              conversationId: conversationId,
            ));
          }
        }
      },
    );
  }
}
