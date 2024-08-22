import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/utils/timer_service.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A custom builder which extends the [LMChatroomBuilderDelegate]
class CustomChatroomBuilder extends LMChatroomBuilderDelegate {
  @override
  PreferredSizeWidget appBarBuilder(
    context,
    chatroom,
    appBar,
  ) {
    return appBar.copyWith(
      subtitle: ValueListenableBuilder(
        valueListenable: rebuildTimer,
        builder: (c, value, w) {
          return LMChatText(
            "Timer left: 00:${value == 10 ? value : "0$value"}",
          );
        },
      ),
      leading: (appBar.leading as LMChatButton).copyWith(
        onTap: () {
          rebuilChatBar.value = !rebuilChatBar.value;
          rebuildTimer.value = 5;
          (appBar.leading as LMChatButton).onTap();
        },
      ),
    );
  }

  @override
  Widget chatBarBuilder(
    BuildContext context,
    chatBar,
  ) {
    return ValueListenableBuilder(
      valueListenable: rebuilChatBar,
      builder: (c, value, w) {
        return value == true ? const SizedBox.shrink() : w!;
      },
      child: chatBar,
    );
  }
}
