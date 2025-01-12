import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/conversation/conversation_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

part 'home_event.dart';
part 'home_state.dart';

part 'handler/fetch_event_handler.dart';
part 'handler/refresh_event_handler.dart';
part 'handler/parsing_result_handler.dart';

/// BLoC responsible for handling the Group Home Feed,
/// Allows for users to fetch, and refresh the feed,
/// Also, updates the feed based on a realtime update.
class LMChatHomeFeedBloc
    extends Bloc<LMChatHomeFeedEvent, LMChatHomeFeedState> {
  static LMChatHomeFeedBloc? _instance;

  /// Creates a singleton instance of the LMChatHomeFeedBloc
  static LMChatHomeFeedBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatHomeFeedBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatHomeFeedBloc._() : super(LMChatHomeInitial()) {
    final DatabaseReference realTime = LMChatRealtime.instance.homeFeed();
    realTime.onChildChanged.listen((event) {
      add(LMChatRefreshHomeFeedEvent());
    });
    // Event handler for fetch DM Feed event
    on<LMChatFetchHomeFeedEvent>(fetchHomeFeedEventHandler);
    // Event handler for refresh DM Feed event
    on<LMChatRefreshHomeFeedEvent>(refreshHomeFeedEventHandler);
  }
}
