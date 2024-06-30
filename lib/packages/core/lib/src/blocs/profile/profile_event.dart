part of 'profile_bloc.dart';

/// {@template lm_profile_event}
/// LMChatProfileEvent defines the events which are handled by this bloc.
/// {@endtemplate}
abstract class LMChatProfileEvent extends Equatable {
  /// {@macro lm_profile_event}
  const LMChatProfileEvent();

  @override
  List<Object> get props => [];
}

/// {@template lm_feed_profile_state_init}
/// LMChatProfileStateInitState defines the state when LMChatProfileBloc is initiated.
/// {@endtemplate}
class LMChatProfileEventInitEvent extends LMChatProfileEvent {}

/// {@template lm_route_to_user_profile_event}
/// LMChatRouteToUserProfileEvent defines the event to route to user profile.
/// [uuid] of type String defines the uuid of the user.
/// [context] of type BuildContext defines the context to navigate to user profile.
/// {@endtemplate}
class LMChatRouteToUserProfileEvent extends LMChatProfileEvent {
  /// Uuid of the user
  final String uuid;

  /// Context to navigate to user profile
  final BuildContext context;

  /// {@macro lm_route_to_user_profile_event}
  const LMChatRouteToUserProfileEvent({
    required this.uuid,
    required this.context,
  });

  @override
  List<Object> get props => [uuid, identityHashCode(this)];
}

/// {@template lm_login_required_event}
/// LMChatLoginRequiredEvent defines the event when login is required.
/// {@endtemplate}

class LMChatLoginRequiredEvent extends LMChatProfileEvent {}

/// {@template lm_logout_event}
/// LMChatLogoutEvent defines the event when user logged out.
/// {@endtemplate}
class LMChatLogoutEvent extends LMChatProfileEvent {}
