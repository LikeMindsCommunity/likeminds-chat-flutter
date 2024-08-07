// ignore_for_file: deprecated_member_use_from_same_package

part of '../analytics_bloc.dart';

/// {@template fire_analytics_event_handler}
/// [fireAnalyticsEventHandler] handles the event to fire an analytics event.
/// [eventName] of type String defines the name of the event to be fired.
/// [eventProperties] of type Map<String, dynamic> defines the properties
/// of the event to be fired.
/// {@endtemplate}
fireAnalyticsEventHandler(
    LMChatFireAnalyticsEvent event, Emitter<LMChatAnalyticsState> emit) async {
  emit(LMChatAnalyticsEventFired(
    eventName: event.eventName,
    eventProperties: event.eventProperties,
    // widgetSource: event.widgetSource,
  ));
}
