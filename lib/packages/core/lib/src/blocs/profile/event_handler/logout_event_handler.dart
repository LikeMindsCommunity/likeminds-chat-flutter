part of '../profile_bloc.dart';

/// map logout event to the event handler
void _handleLMLogoutEvent(
        LMChatLogoutEvent event, Emitter<LMChatProfileState> emit) =>
    emit(LMChatLogoutState());
