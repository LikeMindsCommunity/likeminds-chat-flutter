part of '../profile_bloc.dart';

// map route to user profile event to the event handler
void _handleLMRouteToUserProfileEvent(
    LMChatRouteToUserProfileEvent event, Emitter<LMChatProfileState> emit) {
  emit(
    LMChatRouteToUserProfileState(
      uuid: event.uuid,
      context: event.context,
    ),
  );
}
