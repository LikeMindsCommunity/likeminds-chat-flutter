import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

part 'dm_event.dart';
part 'dm_state.dart';

part 'handler/fetch_event_handler.dart';
part 'handler/refresh_event_handler.dart';

/// BLoC responsible for handling the DM Home Feed,
/// Allows for users to fetch, and refresh the feed,
/// Also, updates the feed based on a realtime update.
class LMChatDMFeedBloc extends Bloc<LMChatDMFeedEvent, LMChatDMFeedState> {
  static LMChatDMFeedBloc? _instance;

  // Creating a singleton instance of the LMChatDMFeedBloc
  static LMChatDMFeedBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return LMChatDMFeedBloc._();
    } else {
      return _instance ?? LMChatDMFeedBloc._();
    }
  }

  LMChatDMFeedBloc._() : super(LMChatDMInitial()) {
    // Event handler for fetch DM Feed event
    on<LMChatFetchDMFeedEvent>(fetchDMFeedEventHandler);
    // Event handler for refresh DM Feed event
    on<LMChatRefreshDMFeedEvent>(refreshDMFeedEventHandler);
  }
}
