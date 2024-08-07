part of '../conversation_action_bloc.dart';

void _linkPreviewRemovedEventHandler(
    LMChatLinkPreviewRemovedEvent event, emit) async {
  emit (
    LMChatLinkRemovedState(
      isPermanentlyRemoved: event.isPermanentlyRemoved,
    ),
  );
}
