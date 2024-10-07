import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:meta/meta.dart';

part 'chatroom_action_event.dart';
part 'chatroom_action_state.dart';

class LMChatroomActionBloc
    extends Bloc<LMChatroomActionEvent, LMChatroomActionState> {
  static LMChatroomActionBloc? _instance;
  // Creating a singleton instance of the LMChatHomeFeedBloc
  static LMChatroomActionBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatroomActionBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatroomActionBloc._() : super(LMChatChatroomActionInitial()) {
    on<LMChatroomActionEvent>(_handleEvent);
  }

  void _handleEvent(
      LMChatroomActionEvent event, Emitter<LMChatroomActionState> emit) async {
    if (event is LMChatShowEmojiKeyboardEvent) {
      _handleShowEmojiKeyboard(event, emit);
    } else if (event is LMChatHideEmojiKeyboardEvent) {
      _handleHideEmojiKeyboard(emit);
    } else if (event is LMChatMarkReadChatroomEvent) {
      await _handleMarkReadChatroom(event);
    } else if (event is LMChatSetChatroomTopicEvent) {
      await _handleSetChatroomTopic(event, emit);
    }
  }

  void _handleShowEmojiKeyboard(
      LMChatShowEmojiKeyboardEvent event, Emitter<LMChatroomActionState> emit) {
    emit(LMChatShowEmojiKeyboardState(
      conversationId: event.conversationId,
    ));
  }

  void _handleHideEmojiKeyboard(Emitter<LMChatroomActionState> emit) {
    emit(LMChatHideEmojiKeyboardState());
  }

  Future<void> _handleMarkReadChatroom(
      LMChatMarkReadChatroomEvent event) async {
    // ignore: unused_local_variable
    LMResponse response = await LMChatCore.client.markReadChatroom(
        (MarkReadChatroomRequestBuilder()..chatroomId(event.chatroomId))
            .build());
  }

  Future<void> _handleSetChatroomTopic(LMChatSetChatroomTopicEvent event,
      Emitter<LMChatroomActionState> emit) async {
    try {
      emit(LMChatChatroomActionLoading());
      LMResponse<void> response = await LMChatCore.client
          .setChatroomTopic((SetChatroomTopicRequestBuilder()
                ..chatroomId(event.chatroomId)
                ..conversationId(event.conversationId))
              .build());
      if (response.success) {
        emit(LMChatChatroomTopicSet(event.topic));
      } else {
        emit(LMChatChatroomTopicError(errorMessage: response.errorMessage!));
      }
    } catch (e) {
      emit(LMChatChatroomTopicError(
          errorMessage: "An error occurred while setting topic"));
    }
  }
}
