import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

part 'participants_event.dart';
part 'participants_state.dart';
part 'handler/get_participants_handler.dart';

/// [LMChatParticipantsBloc] is responsible for handling the participants of a chat room.
/// It extends [Bloc] and uses [LMChatParticipantsEvent] and [LMChatParticipantsState].
/// It has a singleton instance [instance] which is used to access the bloc.
class LMChatParticipantsBloc
    extends Bloc<LMChatParticipantsEvent, LMChatParticipantsState> {
  static LMChatParticipantsBloc? _instance;

  /// Singleton instance of [LMChatParticipantsBloc]
  static LMChatParticipantsBloc get instance =>
      _instance ??= LMChatParticipantsBloc._();
  LMChatParticipantsBloc._() : super(const LMChatParticipantsInitialState()) {
    // handle get participants event
    on<LMChatGetParticipantsEvent>(_getParticipantsEventHandler);
  }
}
