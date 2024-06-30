part of 'analytics_bloc.dart';

/// {@template lm_fire_analytic_state}
/// LMChatAnalyticsState defines the states which are emitted by LMChatAnalyticsBloc.
/// {@endtemplate}
abstract class LMChatAnalyticsState extends Equatable {
  /// {@macro lm_fire_analytic_state}
  const LMChatAnalyticsState();

  @override
  List<Object> get props => [];
}

/// {@template lm_analytics_initiated_state}
/// LMChatAnalyticsInitiated defines the state when LMChatAnalyticsBloc is initiated.
/// {@endtemplate}
class LMChatAnalyticsInitiated extends LMChatAnalyticsState {}

/// {@template lm_analytics_event_fired_state}
/// LMChatAnalyticsEventFired defines the state when an analytics event is fired.
/// [eventName] of type String defines the name of the event fired.
/// [eventProperties] of type Map<String, dynamic> defines the properties
/// of the event fired.
/// {@endtemplate}
class LMChatAnalyticsEventFired extends LMChatAnalyticsState {
  /// Name of the event fired
  final String eventName;
  /// Properties of the event fired
  /// i.e. likes count, post id, etc.
  final Map<String, dynamic> eventProperties;

  /// {@macro lm_feed_widget_source}
  // final LMChatWidgetSource? widgetSource;

  const LMChatAnalyticsEventFired({
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
