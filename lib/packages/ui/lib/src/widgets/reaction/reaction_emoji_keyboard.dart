import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';

/// {@template lm_chat_reaction_keyboard}
///
/// A widget for choosing emojis from the keyboard
/// for reaction purposes, and more
///
/// {@endtemplate}
class LMChatReactionKeyboard extends StatelessWidget {
  /// The text editing controller for the emoji keyboard.
  final TextEditingController? textController;

  /// Callback function that is called when an emoji is selected.
  final Function(String emoji)? onEmojiSelected;

  /// The style configuration for the emoji keyboard.
  final LMChatReactionKeyboardStyle? style;

  /// {@macro lm_chat_reaction_keyboard}
  const LMChatReactionKeyboard({
    super.key,
    this.textController,
    this.onEmojiSelected,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? LMChatTheme.theme.reactionKeyboardStyle;
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height * 0.35,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) async {
          onEmojiSelected?.call(emoji.emoji);
        },
        onBackspacePressed: null,
        textEditingController: textController,
        config: Config(
          bottomActionBarConfig: BottomActionBarConfig(
            buttonIconColor: effectiveStyle.buttonIconColor ?? Colors.grey,
            backgroundColor:
                effectiveStyle.backgroundColor ?? LMChatTheme.theme.container,
            showSearchViewButton: false,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: effectiveStyle.searchViewBackgroundColor ??
                const Color(0xFFF2F2F2),
          ),
          categoryViewConfig: const CategoryViewConfig(
            initCategory: Category.RECENT,
            recentTabBehavior: RecentTabBehavior.RECENT,
          ),
          skinToneConfig: SkinToneConfig(
            dialogBackgroundColor: effectiveStyle.dialogBackgroundColor ??
                LMChatDefaultTheme.whiteColor,
            indicatorColor:
                effectiveStyle.indicatorColor ?? LMChatDefaultTheme.greyColor,
            enabled: true,
          ),
          emojiViewConfig: EmojiViewConfig(
            columns: effectiveStyle.columns ?? 7,
            emojiSizeMax: effectiveStyle.emojiSizeMax ??
                28 *
                    (foundation.defaultTargetPlatform == TargetPlatform.iOS
                        ? 1.30
                        : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: effectiveStyle.gridPadding ?? EdgeInsets.zero,
            recentsLimit: effectiveStyle.recentsLimit ?? 28,
            noRecents: effectiveStyle.noRecents ??
                const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
            loadingIndicator:
                effectiveStyle.loadingIndicator ?? const SizedBox.shrink(),
            buttonMode: ButtonMode.MATERIAL,
            backgroundColor:
                effectiveStyle.backgroundColor ?? LMChatTheme.theme.container,
          ),
        ),
      ),
    );
  }
}

class LMChatReactionKeyboardStyle {
  /// The color of the button icons in the keyboard.
  final Color? buttonIconColor;

  /// The background color of the emoji keyboard.
  final Color? backgroundColor;

  /// The background color of the search view.
  final Color? searchViewBackgroundColor;

  /// The background color of the dialog.
  final Color? dialogBackgroundColor;

  /// The color of the indicator.
  final Color? indicatorColor;

  /// The number of columns in the emoji grid.
  final int? columns;

  /// The maximum size of the emojis.
  final double? emojiSizeMax;

  /// The padding for the emoji grid.
  final EdgeInsets? gridPadding;

  /// The limit for recent emojis.
  final int? recentsLimit;

  /// The widget displayed when there are no recent emojis.
  final Widget? noRecents;

  /// The widget displayed as a loading indicator.
  final Widget? loadingIndicator;

  LMChatReactionKeyboardStyle({
    this.buttonIconColor,
    this.backgroundColor,
    this.searchViewBackgroundColor,
    this.dialogBackgroundColor,
    this.indicatorColor,
    this.columns,
    this.emojiSizeMax,
    this.gridPadding,
    this.recentsLimit,
    this.noRecents,
    this.loadingIndicator,
  });

  /// Creates a basic style configuration for the emoji keyboard.
  static LMChatReactionKeyboardStyle basic() {
    return LMChatReactionKeyboardStyle(
      buttonIconColor: Colors.grey,
      columns: 7,
      gridPadding: EdgeInsets.zero,
      recentsLimit: 28,
      noRecents: const Text(
        'No Recents',
        style: TextStyle(fontSize: 20, color: Colors.black26),
        textAlign: TextAlign.center,
      ),
      loadingIndicator: const SizedBox.shrink(),
    );
  }
}
