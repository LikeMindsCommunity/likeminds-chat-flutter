import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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

  /// A reference to the real-time database for the chatroom.
  ///
  /// This is an instance of [DatabaseReference] obtained from the
  /// [LMChatRealtime] singleton. It is used to interact with the
  /// real-time chatroom data in the Firebase Realtime Database.
  final DatabaseReference realTime = LMChatRealtime.instance.chatroom();

  static LMChatConversationBloc? _instance;

  /// The ID of the current chatroom.
  ///
  /// This is a static variable that holds the ID of the chatroom that is
  /// currently active or being interacted with. It can be `null` if no
  /// chatroom is currently selected.
  static int? currentChatroomId;

  /// Subscription to the real-time database changes.
  /// Needs to be cancelled when the BLoC is closed.
  StreamSubscription? _realtimeSubscription;

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
  Future<void> close() async {
    currentChatroomId = null;
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    LMChatConversationBloc.replyConversation = null;
    _instance = null;
    return super.close();
  }

  /// Handles the initialization of conversation events.
  ///
  /// This method sets the current chatroom ID and the last conversation ID
  /// from the provided event. It also listens for real-time updates on child
  /// changes and triggers an update event if a new conversation is detected.
  ///
  /// Parameters:
  /// - `event`: The event containing the chatroom ID and conversation ID to initialize.
  /// - `emit`: The emitter used to emit new states.
  ///
  /// Listens to:
  /// - `realTime.onChildChanged`: Listens for changes in the real-time database.
  ///   If a change is detected and it is not the same as the last conversation ID,
  ///   an update event is added to the conversation bloc.
  initialiseConversationsEventHandler(
    LMChatInitialiseConversationsEvent event,
    Emitter<LMChatConversationState> emit,
  ) async {
    await _realtimeSubscription?.cancel(); // Cancel previous subscription
    _realtimeSubscription = null; // Clear reference

    currentChatroomId = event.chatroomId;
    lastConversationId = event.conversationId;

    _realtimeSubscription = realTime.onChildChanged.listen(
      (event) {
        if (event.snapshot.value != null && currentChatroomId != null) {
          final response = event.snapshot.value as Map;
          final conversationId = int.tryParse(response["answer_id"]);

          if (lastConversationId != null &&
              conversationId != lastConversationId &&
              conversationId != null) {
            LMChatConversationBloc.instance.add(LMChatUpdateConversationsEvent(
              chatroomId: currentChatroomId!,
              conversationId: conversationId,
            ));
          }
        }
      },
    );
  }
}
