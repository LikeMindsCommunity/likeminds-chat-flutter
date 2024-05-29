import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:meta/meta.dart';

part 'chatroom_action_event.dart';
part 'chatroom_action_state.dart';

class LMChatroomActionBloc
    extends Bloc<ChatroomActionEvent, ChatroomActionState> {
  static LMChatroomActionBloc? _instance;
  static LMChatroomActionBloc get instance =>
      _instance ??= LMChatroomActionBloc._();
  LMChatroomActionBloc._() : super(ChatroomActionInitial()) {
    on<ChatroomActionEvent>((event, emit) async {
      if (event is MarkReadChatroomEvent) {
        // ignore: unused_local_variable
        LMResponse response = await LMChatCore.client.markReadChatroom(
            (MarkReadChatroomRequestBuilder()..chatroomId(event.chatroomId))
                .build());
      } else if (event is SetChatroomTopicEvent) {
        try {
          emit(ChatroomActionLoading());
          LMResponse<void> response = await LMChatCore.client
              .setChatroomTopic((SetChatroomTopicRequestBuilder()
                    ..chatroomId(event.chatroomId)
                    ..conversationId(event.conversationId))
                  .build());
          if (response.success) {
            emit(ChatroomTopicSet(event.topic));
          } else {
            emit(ChatroomTopicError(errorMessage: response.errorMessage!));
          }
        } catch (e) {
          emit(ChatroomTopicError(
              errorMessage: "An error occurred while setting topic"));
        }
      }
    });
  }
}
