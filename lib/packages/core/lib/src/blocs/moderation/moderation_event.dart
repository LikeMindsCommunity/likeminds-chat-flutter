part of 'moderation_bloc.dart';

/// {@template lm_chat_moderation_event}
/// A sealed class which describes the states for moderation
/// {@endtemplate}
@immutable
sealed class LMChatModerationEvent {}

/// {@template lm_chat_moderation_feth_tags_event}
/// The event to load tags
/// {@endtemplate}
class LMChatModerationFetchTagsEvent extends LMChatModerationEvent {}

/// {@template lm_chat_moderation_post_report_event}
/// The event to post report
/// {@endtemplate}
class LMChatModerationPostReportEvent extends LMChatModerationEvent {

  /// The id of the entity.
  final String entityId;

  /// The id of the report tag.
  final int reportTagId;

  /// The reason for the report.
  final String reason;

  /// {@macro lm_chat_moderation_post_report_event}
  LMChatModerationPostReportEvent({
    required this.entityId,
    required this.reportTagId,
    required this.reason,
  });
}
