import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatReactionBar extends StatelessWidget {
  /// The function to call when a reaction is made.
  final Function(String reaction)? onReaction;

  /// The style class of the widget
  final LMChatReactionBarStyle? style;

  const LMChatReactionBar({
    Key? key,
    this.onReaction,
    this.style, // Optional style parameter
  }) : // Default to the style class
        super(key: key);

  @override
  Widget build(BuildContext context) {
    LMChatReactionBarStyle effectiveStyle = style ??
        (LMChatTheme.theme.reactionBarStyle as LMChatReactionBarStyle?) ??
        LMChatReactionBarStyle.basic();
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveStyle.background ?? LMChatTheme.theme.container,
          borderRadius: BorderRadius.circular(style?.borderRadius ?? 6),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 2,
              color: LMChatTheme.theme.onContainer.withOpacity(0.1),
            )
          ],
        ),
        width: effectiveStyle.width ?? 80.w,
        height: effectiveStyle.height ?? 6.h,
        child: getListOfReactions(
          onTap: onReaction,
        ),
      ),
    );
  }
}

const List<String> reactionEmojis = ['\u2764', '😂', '😮', '😢', '😡', '👍'];

Widget getListOfReactions({required Function(String)? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: reactionEmojis
            .map(
              (e) => GestureDetector(
                onTap: () => onTap?.call(e),
                child: LMChatText(
                  e,
                  style: const LMChatTextStyle(
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            )
            .toList() +
        [
          GestureDetector(
            onTap: () => onTap?.call('Add'),
            child: const LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.add_reaction_outlined,
              style: LMChatIconStyle(
                size: 24,
              ),
            ),
          )
        ],
  );
}

class LMChatReactionBarStyle {
  final Color? background;
  final double? width;
  final double? height;
  final double? borderRadius;

  LMChatReactionBarStyle({
    this.background,
    this.width,
    this.height,
    this.borderRadius,
  });

  factory LMChatReactionBarStyle.basic() {
    return LMChatReactionBarStyle();
  }
}
