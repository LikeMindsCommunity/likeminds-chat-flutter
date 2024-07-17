import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

part 'explore_event.dart';
part 'explore_state.dart';

part 'handler/fetch_explore_handler.dart';
part 'handler/pin_explore_space_handler.dart';
part 'handler/refresh_explore_event_handler.dart';

/// A BLoC to manage the Explore Feed of LMChat
///
/// Used to manage, fetch, refresh, and pin explore chatrooms
class LMChatExploreBloc extends Bloc<LMChatExploreEvent, LMChatExploreState> {
  static LMChatExploreBloc? _instance;

  /// Creates and maintains a singleton instance of this BLoC
  static LMChatExploreBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return _instance = LMChatExploreBloc._();
    } else {
      return _instance!;
    }
  }

  LMChatExploreBloc._() : super(LMChatExploreInitialState()) {
    // Handle fetch explore event using handlers
    on<LMChatFetchExploreEvent>(fetchExploreEventHandler);
    // Handle pin explore space using handlers
    on<LMChatPinSpaceEvent>(pinExploreSpaceEventHandler);
    // Handle refresh explore event using handler
    on<LMChatRefreshExploreEvent>(refreshExploreEventHandler);
  }
}
