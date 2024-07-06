part of 'moderation_bloc.dart';

/// {@template lm_chat_moderation_event}
/// A sealed class which describes the states for moderation
/// {@endtemplate}
@immutable
sealed class LMChatModerationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// {@template lm_chat_moderation_initial_state}
/// The initial state for the moderation bloc
/// {@endtemplate}
class LMChatModerationInitialState extends LMChatModerationState {}

/// {@template lm_chat_moderation_loading_state}
/// The loading state for the moderation bloc
/// {@endtemplate}
class LMChatModerationTagLoadingState extends LMChatModerationState {}

/// {@template lm_chat_moderation_tag_loaded_state}
/// The loaded state for the moderation bloc
/// {@endtemplate}
class LMChatModerationTagLoadedState extends LMChatModerationState {
  /// The list of tags
  final List<LMChatReportTagViewData> tags;

  /// {@macro lm_chat_moderation_tag_loaded_state}
  LMChatModerationTagLoadedState({
    required this.tags,
  });

  @override
  List<Object?> get props => [tags];
}

/// {@template lm_chat_moderation_tag_loading_error_state}
/// The error state for the moderation bloc
/// {@endtemplate}
class LMChatModerationTagLoadingErrorState extends LMChatModerationState {
  /// The error message
  final String message;

  /// {@macro lm_chat_moderation_tag_loading_error_state}
  LMChatModerationTagLoadingErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

/// {@template lm_chat_moderation_report_posting_state}
/// The posting state for the moderation bloc
/// {@endtemplate}
class LMChatModerationReportPostedState extends LMChatModerationState {}

/// {@template lm_chat_moderation_report_posting_error_state}
/// Error state for the moderation bloc
/// {@endtemplate}
class LMChatModerationReportPostingErrorState extends LMChatModerationState {
  /// The error message
  final String errorMessage;

  /// {@macro lm_chat_moderation_report_posting_error_state}
  LMChatModerationReportPostingErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}
