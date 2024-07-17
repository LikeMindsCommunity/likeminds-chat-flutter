import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

part 'handler/fetch_chatroom_handler.dart';

/// BLoC responsible for handling the Chatroom,
/// Allows for users to fetch and display a chatroom,
class LMChatroomBloc extends Bloc<LMChatroomEvent, LMChatroomState> {
  static LMChatroomBloc? _instance;

  // Creating a singleton instance of the LMChatHomeFeedBloc
  static LMChatroomBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatroomBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatroomBloc._() : super(LMChatroomLoadingState()) {
    // Event handler for fetching chatroom
    on<LMChatFetchChatroomEvent>(fetchChatroomEventHandler);
  }
}
