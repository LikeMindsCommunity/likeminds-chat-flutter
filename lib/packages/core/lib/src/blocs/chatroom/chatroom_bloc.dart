import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class LMChatroomBloc extends Bloc<LMChatroomEvent, LMChatroomState> {
  static LMChatroomBloc? _instance;
  static LMChatroomBloc get instance => _instance ??= LMChatroomBloc._();
  LMChatroomBloc._() : super(LMChatroomInitialState()) {
    on<LMChatroomEvent>((event, emit) async {
      if (event is LMChatInitChatroomEvent) {
        emit(LMChatroomLoadingState());
        LMResponse<GetChatroomResponse> getChatroomResponse =
            await LMChatCore.client.getChatroom(event.chatroomRequest);
        emit(LMChatroomLoadedState(
          getChatroomResponse: getChatroomResponse.data!,
        ));
      }
    });
  }
}
