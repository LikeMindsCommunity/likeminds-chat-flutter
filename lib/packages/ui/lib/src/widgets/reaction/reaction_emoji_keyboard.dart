import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';

class LMChatReactionKeyboard extends StatelessWidget {
  final TextEditingController? textController;

  final Function(String emoji)? onEmojiSelected;

  const LMChatReactionKeyboard({
    super.key,
    this.textController,
    this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) async {
          onEmojiSelected?.call(emoji.emoji);
        },
        onBackspacePressed: null,
        textEditingController:
            textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          bottomActionBarConfig: BottomActionBarConfig(
            buttonIconColor: Colors.grey,
            backgroundColor: LMChatTheme.theme.container,
            showSearchViewButton: false,
            // iconColorSelected: Colors.blue,
            // backspaceColor: Colors.blue,
            // indicatorColor: Colors.blue,
          ),
          searchViewConfig: const SearchViewConfig(
            backgroundColor: Color(0xFFF2F2F2),
          ),
          categoryViewConfig: const CategoryViewConfig(
            initCategory: Category.RECENT,
            recentTabBehavior: RecentTabBehavior.RECENT,
          ),
          skinToneConfig: const SkinToneConfig(
            dialogBackgroundColor: LMChatDefaultTheme.whiteColor,
            indicatorColor: LMChatDefaultTheme.greyColor,
            enabled: true,
          ),
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.30
                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            recentsLimit: 28,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ), // Needs to be const Widget
            loadingIndicator:
                const SizedBox.shrink(), // Needs to be const Widget
            // tabIndicatorAnimDuration: kTabScrollDuration,
            // categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            backgroundColor: LMChatTheme.theme.container,
          ),
        ),
      ),
    );
  }
}
