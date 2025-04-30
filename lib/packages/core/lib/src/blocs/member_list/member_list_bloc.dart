import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:meta/meta.dart';

part 'member_list_event.dart';
part 'member_list_state.dart';
part 'handler/get_all_members_handler.dart';
part 'handler/search_members_handler.dart';

class LMChatMemberListBloc
    extends Bloc<LMChatMemberListEvent, LMChatMemberListState> {
  // static private instance
  static LMChatMemberListBloc? _instance;

  /// Creates a singleton instance of the LMChatMemberListBloc
  static LMChatMemberListBloc get instance {
    if (_instance == null || _instance!.isClosed) {
      return LMChatMemberListBloc._();
    } else {
      return _instance!;
    }
  }

  // private constructor
  LMChatMemberListBloc._() : super(LmChatMemberListInitial()) {
    on<LMChatGetAllMemberEvent>(_getAllMembersEventHandler);
    on<LMChatMemberListSearchEvent>(_searchMembersEventHandler);
  }
}
