import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:meta/meta.dart';

part 'member_list_event.dart';
part 'member_list_state.dart';

class LMChatMemberListBloc extends Bloc<LMChatMemberListEvent, LMChatMemberListState> {
  LMChatMemberListBloc() : super(LmChatMemberListInitial()) {
    on<LMChatMemberListEvent>((event, emit) async {
    //  final response = await LMChatCore.client.getAllMembers();
    });
  }
}
