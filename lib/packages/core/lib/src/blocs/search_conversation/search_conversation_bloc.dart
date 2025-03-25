import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:meta/meta.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
part 'search_conversation_event.dart';
part 'search_conversation_state.dart';
part 'handler/get_convo_search_handler.dart';

/// [LMChatSearchConversationBloc] is responsible for handling the search functionality
/// for conversations in a chat application.
/// It extends [Bloc] and uses [LMChatSearchConversationEvent] and [LMChatSearchConversationState].
/// It has a singleton instance [instance] which is used to access the bloc.
class LMChatSearchConversationBloc
    extends Bloc<LMChatSearchConversationEvent, LMChatSearchConversationState> {
  static LMChatSearchConversationBloc? _instance;

  /// Singleton instance of [LMChatSearchConversationBloc]
  static LMChatSearchConversationBloc get instance =>
      _instance ??= LMChatSearchConversationBloc._();

  /// Private constructor to enforce singleton pattern
  LMChatSearchConversationBloc._() : super(LMChatSearchConversationInitial()) {
    // Handle search conversation event
    on<LMChatSearchConversationEvent>(_searchConversationEventHandler);
  }
}
