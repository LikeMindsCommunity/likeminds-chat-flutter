import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_explore_style}
/// [LMChatExploreStyle] is a class which is used to style the explore
/// screen. It is used to customize the explore screen.
/// {@endtemplate}
class LMChatExploreStyle {
  /// {@macro lm_chat_explore_style}
  const LMChatExploreStyle({
    this.popUpMenuStyle,
  });

  /// The style for the popup menu.
  final LMChatCustomPopupMenuStyle Function(
      LMChatCustomPopupMenuStyle oldStyle)? popUpMenuStyle;
}
