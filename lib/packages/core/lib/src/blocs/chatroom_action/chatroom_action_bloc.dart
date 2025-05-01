import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:meta/meta.dart';

part 'chatroom_action_event.dart';
part 'chatroom_action_state.dart';

part 'handler/show_emoji_keyboard_handler.dart';
part 'handler/hide_emoji_keyboard_handler.dart';
part 'handler/mark_read_chatroom_handler.dart';
part 'handler/set_chatroom_topic_handler.dart';
part 'handler/update_chatroom_action_handler.dart';

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
    } else if (event is LMChatroomActionUpdateEvent) {
      await _updateChatroomActionHandler(event, emit);
    }
  }

  @override
  Future<void> close() {
    _instance = null;
    return super.close();
  }
}
