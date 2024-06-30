part of 'analytics_bloc.dart';

/// {@template lm_analytics_event}
/// LMChatAnalyticsEvent defines the events which are handled by LMChatAnalyticsBloc.
/// {@endtemplate}
abstract class LMChatAnalyticsEvent extends Equatable {
  /// {@macro lm_analytics_event}
  const LMChatAnalyticsEvent();

  @override
  List<Object> get props => [];
}

/// {@template lm_init_analytic_event}
/// LMChatInitAnalyticsEvent defines the event to initiate LMChatAnalyticsBloc.
/// {@endtemplate}
class LMChatInitAnalyticsEvent extends LMChatAnalyticsEvent {}

/// {@template lm_fire_analytic_event}
/// LMChatFireAnalyticsEvent defines the event to fire an analytics event.
/// [eventName] of type String defines the name of the event to be fired.
/// [eventProperties] of type Map<String, dynamic> defines the properties
/// of the event to be fired.
/// {@endtemplate}
class LMChatFireAnalyticsEvent extends LMChatAnalyticsEvent {
  // Name of the event to be fired
  // i.e. post_liked, etc.
  final String eventName;
  // Properties of the event to be fired
  // i.e. likes count, post id, etc.
  final Map<String, dynamic> eventProperties;

  /// {@macro lm_feed_widget_source}
  // final LMChatWidgetSource? widgetSource;

  /// {@macro lm_fire_analytic_event}
  const LMChatFireAnalyticsEvent({
    required this.eventName,
    required this.eventProperties,
    // this.widgetSource,
  });

  @override
  List<Object> get props => [
        eventName,
        eventProperties,
        identityHashCode(this),
      ];
}
