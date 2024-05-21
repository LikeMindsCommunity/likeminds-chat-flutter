import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dm_event.dart';
part 'dm_state.dart';

class LMChatDMBloc extends Bloc<LMChatDMEvent, LMChatDMState> {
  LMChatDMBloc() : super(LMChatDMInitial()) {
    on<LMChatDMEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
