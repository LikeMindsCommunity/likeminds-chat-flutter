import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';

part 'profile_state.dart';

part 'event_handler/login_required_event_handler.dart';

part 'event_handler/logout_event_handler.dart';

part 'event_handler/route_to_user_profile_event_handler.dart';

/// {@template lm_profile_bloc}
/// `LMChatProfileBloc` handle all the profile related actions
/// like login, logout, route to user profile.
/// LMChatProfileEvent defines the events which are handled by this bloc.
/// {@endtemplate}
class LMChatProfileBloc extends Bloc<LMChatProfileEvent, LMChatProfileState> {
  static LMChatProfileBloc? _lmProfileBloc;

  /// {@macro lm_profile_bloc}
  static LMChatProfileBloc get instance =>
      _lmProfileBloc ??= LMChatProfileBloc._();

  LMChatProfileBloc._() : super(LMChatProfileInitState()) {
    on<LMChatLoginRequiredEvent>(_handleLMLoginRequiredEvent);
    on<LMChatLogoutEvent>(_handleLMLogoutEvent);
    on<LMChatRouteToUserProfileEvent>(_handleLMRouteToUserProfileEvent);
  }
}
