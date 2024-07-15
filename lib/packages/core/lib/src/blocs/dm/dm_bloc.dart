import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/conversation/conversation_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

part 'dm_event.dart';
part 'dm_state.dart';

part 'handler/fetch_event_handler.dart';
part 'handler/refresh_event_handler.dart';
part 'handler/parsing_result_handler.dart';

/// BLoC responsible for handling the DM Home Feed,
/// Allows for users to fetch, and refresh the feed,
/// Also, updates the feed based on a realtime update.
class LMChatDMFeedBloc extends Bloc<LMChatDMFeedEvent, LMChatDMFeedState> {
  static LMChatDMFeedBloc? _instance;

  /// Creating a singleton instance of the LMChatDMFeedBloc
  static LMChatDMFeedBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatDMFeedBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatDMFeedBloc._() : super(LMChatDMInitial()) {
    final DatabaseReference realTime = LMChatRealtime.instance.homeFeed();
    realTime.onValue.listen((event) {
      add(LMChatRefreshDMFeedEvent());
    });
    // Event handler for fetch DM Feed event
    on<LMChatFetchDMFeedEvent>(fetchDMFeedEventHandler);
    // Event handler for refresh DM Feed event
    on<LMChatRefreshDMFeedEvent>(refreshDMFeedEventHandler);
  }
}
