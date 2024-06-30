part of 'profile_bloc.dart';

/// {@template lm_profile_state}
/// LMChatProfileState defines the states which are emitted by the [LMChatProfileBloc].
/// {@endtemplate}
abstract class LMChatProfileState extends Equatable {
  /// {@macro lm_profile_state}
  const LMChatProfileState();

  @override
  List<Object> get props => [];
}

/// {@template lm_feed_profile_state_init}
/// LMChatProfileStateInitState defines the state when [LMChatProfileBloc] is initiated.
/// {@endtemplate}
class LMChatProfileInitState extends LMChatProfileState {}

/// {@template lm_feed_route_to_user_profile_state}
/// LMChatRouteToUserProfileState defines the state to route to user profile.
/// [uuid] of type String defines the uuid of the user.
/// [context] of type BuildContext defines the context to navigate to user profile.
/// {@endtemplate}
class LMChatRouteToUserProfileState extends LMChatProfileState {
  /// The uuid of the user
  final String uuid;
  /// [BuildContext] of the screen
  final BuildContext context;
  /// [LMChatRouteToUserProfileState] constructor
  const LMChatRouteToUserProfileState({
    required this.uuid,
    required this.context,
  });

  @override
  List<Object> get props => [uuid, identityHashCode(this)];
}

/// {@template lm_feed_login_required_state}
/// LMChatLoginRequiredState defines the state when login is required.
/// {@endtemplate}
class LMChatLoginRequiredState extends LMChatProfileState {}

/// {@template lm_feed_logout_state}
/// LMChatLogoutState defines the state when user logged out.
/// {@endtemplate}
class LMChatLogoutState extends LMChatProfileState {}


