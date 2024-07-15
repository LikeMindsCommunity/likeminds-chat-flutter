import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/aws/aws.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

part 'handler/post_conversation_handler.dart';
part 'handler/post_multimedia_conversation_handler.dart';
part 'handler/fetch_conversation_handler.dart';
part 'handler/update_conversation_handler.dart';
part 'handler/initialise_conversations_handler.dart';

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
  }

  initialiseConversationsEventHandler(
    LMChatInitialiseConversationsEvent event,
    Emitter<LMChatConversationState> emit,
  ) async {
    int chatroomId = event.chatroomId;
    lastConversationId = event.conversationId;

    realTime.onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final response = event.snapshot.value as Map;
          final conversationId = int.parse(response["collabcard"]["answer_id"]);
          if (lastConversationId != null &&
              conversationId != lastConversationId) {
            LMChatConversationBloc.instance.add(LMChatUpdateConversationsEvent(
              chatroomId: chatroomId,
              conversationId: conversationId,
            ));
          }
        }
      },
    );
  }
}
