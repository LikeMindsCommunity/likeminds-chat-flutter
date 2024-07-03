import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// [LMChatUserTile] is a [LMChatTile] that represents a user in a chat room.
class LMChatUserTile extends LMChatTile {
  /// [userViewData] is the user to be displayed in the tile.
  final LMChatUserViewData userViewData;

  /// [LMChatUserTile] constructor to create an instance of [LMChatUserTile].
  const LMChatUserTile({
    super.key,
    required this.userViewData,
    super.onTap,
    super.style,
    super.title,
    super.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    LMChatThemeData chatTheme = LMChatTheme.theme;
    return LMChatTile(
      onTap: onTap,
      style: style ??
          LMChatTileStyle(
            backgroundColor: chatTheme.container,
            margin: 4,
            // margin: 12,
          ),
      leading: LMChatProfilePicture(
        style: LMChatProfilePictureStyle.basic().copyWith(
          backgroundColor: chatTheme.primaryColor,
          size: 48,
          fallbackTextStyle: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: chatTheme.onPrimary,
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
}
