import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// [LMChatUserTile] is a [LMChatTile] that represents a user in a chat room.
class LMChatUserTile extends LMChatTile {
  /// [userViewData] is the user to be displayed in the tile.
  final LMChatUserViewData userViewData;

  final LMChatThemeData _chatTheme = LMChatTheme.theme;

  /// [LMChatUserTile] constructor to create an instance of [LMChatUserTile].
  LMChatUserTile({
    super.key,
    required this.userViewData,
    super.onTap,
    super.style,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.absorbTouch,
  });

  @override
  Widget build(BuildContext context) {
    return _defUserTile();
  }

  LMChatTile _defUserTile() {
    return LMChatTile(
      onTap: onTap,
      style: style ??
          LMChatTileStyle(
            backgroundColor: _chatTheme.container,
            gap: 4,
            // margin: 12,
          ),
      leading: leading ??
          LMChatProfilePicture(
            style: LMChatProfilePictureStyle.basic().copyWith(
              backgroundColor: _chatTheme.primaryColor,
              size: 48,
              fallbackTextStyle: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _chatTheme.onPrimary,
                ),
              ),
            ),
            fallbackText: userViewData.name,
            imageUrl: userViewData.imageUrl,
            onTap: onTap,
          ),
      title: title ??
          LMChatText(
            userViewData.name,
            style: const LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      subtitle: subtitle,
    );
  }

  /// `copyWith()` method to create a copy of the [LMChatUserTile] instance with the new values.
  @override
  LMChatTile copyWith({
    LMChatUserViewData? userViewData,
    VoidCallback? onTap,
    LMChatTileStyle? style,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
  }) {
    return LMChatUserTile(
      userViewData: userViewData ?? this.userViewData,
      onTap: onTap ?? this.onTap,
      style: style ?? this.style,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
    );
  }
}
