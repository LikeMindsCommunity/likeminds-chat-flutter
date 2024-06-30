part of '../profile_bloc.dart';

/// map login required event to the event handler
void _handleLMLoginRequiredEvent(
        LMChatLoginRequiredEvent event, Emitter<LMChatProfileState> emit) =>
    emit(LMChatLoginRequiredState());
