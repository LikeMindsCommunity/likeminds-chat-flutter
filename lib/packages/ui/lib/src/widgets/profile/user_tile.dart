import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatUserTile extends LMChatTile {
  final LMChatUserViewData user;
  @override
  final VoidCallback? onTap;
  @override
  final LMChatTileStyle? style;
  @override
  final Widget? title;
  @override
  final Widget? subtitle;

  const LMChatUserTile({
    Key? key,
    required this.user,
    this.onTap,
    this.style,
    this.title,
    this.subtitle,
  }) : super(
          key: key,
          onTap: onTap,
          style: style,
          title: title,
          subtitle: subtitle,
        );

  @override
  Widget build(BuildContext context) {
    LMChatThemeData feedTheme = LMChatTheme.theme;
    return LMChatTile(
      onTap: onTap,
      style: style ??
          LMChatTileStyle(
            backgroundColor: feedTheme.container,
            margin: 12,
          ),
      leading: LMChatProfilePicture(
        style: LMChatProfilePictureStyle.basic().copyWith(
          backgroundColor: feedTheme.primaryColor,
          size: 42,
          fallbackTextStyle: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: LMChatDefaultTheme.kFontMedium,
              fontWeight: FontWeight.w500,
              color: feedTheme.onPrimary,
            ),
          ),
        ),
        fallbackText: user.name,
        imageUrl: user.imageUrl,
        onTap: onTap,
      ),
      title: title ??
          LMChatText(
            user.name,
            style: const LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: LMChatDefaultTheme.kFontMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      subtitle: subtitle ??
          LMChatText(
            "@${user.name.toLowerCase().split(' ').join()} ",
            style: const LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: LMChatDefaultTheme.kFontSmall,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
    );
  }
}
