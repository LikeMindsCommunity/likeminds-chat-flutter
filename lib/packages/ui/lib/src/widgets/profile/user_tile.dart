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
    return userViewData.isDeleted == true
        ? _defDeletedUserTile()
        : _defUserTile();
  }

  Widget _defDeletedUserTile() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
          ),
          height: 54,
          width: 54,
        ),
        LMChatDefaultTheme.kHorizontalPaddingSmall,
        LMChatDefaultTheme.kHorizontalPaddingMedium,
        const LMChatText(
          'Deleted User',
          style: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: LMChatDefaultTheme.kFontMedium,
            ),
          ),
        )
      ],
    );
  }

  LMChatTile _defUserTile() {
    return LMChatTile(
      onTap: onTap,
      style: style ??
          LMChatTileStyle(
            backgroundColor: _chatTheme.container,
            gap: 4,
            margin: const EdgeInsets.only(bottom: 2),
          ),
      leading: leading ??
          LMChatProfilePicture(
            style: LMChatProfilePictureStyle.basic().copyWith(
              size: 48,
            ),
            fallbackText: userViewData.name,
            imageUrl: userViewData.imageUrl,
            onTap: onTap,
          ),
      trailing: trailing,
      title: title ??
          LMChatText(
            userViewData.name,
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _chatTheme.onContainer,
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
