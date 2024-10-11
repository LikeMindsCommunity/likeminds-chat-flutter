import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// A list of emojis representing different reactions.
const List<String> reactionEmojis = ['\u2764', '😂', '😮', '😢', '😡', '👍'];

/// {@template lm_chat_reaction_bar}
/// A widget that displays a bar for selecting reactions.
/// {@endtemplate}
class LMChatReactionBar extends StatelessWidget {
  /// The function to call when a reaction is made.
  final Function(String reaction)? onReaction;

  /// The style class of the widget.
  final LMChatReactionBarStyle? style;

  ///{@macro lm_chat_reaction_bar}
  const LMChatReactionBar({
    Key? key,
    this.onReaction,
    this.style,
  }) : super(key: key);

  /// Creates a copy of the current instance with the given parameters.
  LMChatReactionBar copyWith({
    Function(String reaction)? onReaction,
    LMChatReactionBarStyle? style,
  }) {
    return LMChatReactionBar(
      key: key,
      onReaction: onReaction ?? this.onReaction,
      style: style ?? this.style,
    );
  }

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
          borderRadius: BorderRadius.circular(effectiveStyle.borderRadius ?? 6),
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
          effectiveStyle: effectiveStyle, // Pass effectiveStyle here
        ),
      ),
    );
  }

  Widget getListOfReactions(
      {required Function(String)? onTap,
      required LMChatReactionBarStyle effectiveStyle}) {
    // Add effectiveStyle parameter
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: reactionEmojis
              .map(
                (e) => GestureDetector(
                  onTap: () => onTap?.call(e),
                  child: LMChatText(
                    e,
                    style: LMChatTextStyle(
                      textStyle: TextStyle(
                        fontSize: effectiveStyle.size ?? 24,
                      ),
                    ),
                  ),
                ),
              )
              .toList() +
          [
            GestureDetector(
              onTap: () => onTap?.call('Add'),
              child: LMChatIcon(
                type: LMChatIconType.icon,
                icon: Icons.add_reaction_outlined,
                style: effectiveStyle.addIconStyle ??
                    LMChatIconStyle(
                      size: effectiveStyle.size ?? 24,
                    ),
              ),
            )
          ],
    );
  }
}

/// A class that defines the style for the reaction bar in the chat interface.
class LMChatReactionBarStyle {
  /// The background color of the reaction bar.
  final Color? background;

  /// The width of the reaction bar.
  final double? width;

  /// The height of the reaction bar.
  final double? height;

  /// The border radius of the reaction bar's corners.
  final double? borderRadius;

  /// The size of the reaction icons within the bar.
  final double? size;

  /// The style of the add icon in reaction bar
  final LMChatIconStyle? addIconStyle;

  /// Creates an instance of [LMChatReactionBarStyle].
  LMChatReactionBarStyle({
    this.background,
    this.width,
    this.height,
    this.size,
    this.borderRadius,
    this.addIconStyle,
  });

  /// A factory constructor that returns a basic instance of [LMChatReactionBarStyle].
  factory LMChatReactionBarStyle.basic() {
    return LMChatReactionBarStyle();
  }
}
