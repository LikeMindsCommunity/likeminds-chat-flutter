import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';
part 'handler/fire_analytics_event_handler.dart';

/// {@template lm_analytics_bloc}
/// LMChatAnalyticsBloc handle all the analytics related actions
/// like fire analytics event.
/// LMChatAnalyticsEvent defines the events which are handled by this bloc.
/// LMChatAnalyticsState defines the states which are emitted by this bloc
/// {@endtemplate}
class LMChatAnalyticsBloc
    extends Bloc<LMChatAnalyticsEvent, LMChatAnalyticsState> {
  /// {@macro lm_analytics_bloc}
  static LMChatAnalyticsBloc? _lmAnalyticsBloc;

  /// {@macro lm_analytics_bloc}
  static LMChatAnalyticsBloc get instance =>
      _lmAnalyticsBloc ??= LMChatAnalyticsBloc._();

  LMChatAnalyticsBloc._() : super(LMChatAnalyticsInitiated()) {
    on<LMChatFireAnalyticsEvent>(fireAnalyticsEventHandler);
  }
}
