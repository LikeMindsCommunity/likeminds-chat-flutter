import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

typedef LMChatErrorHandler = Function(String, StackTrace);

typedef LMChatHomeAppBarBuilder = LMChatAppBar Function(
  User currentUser,
  LMChatAppBar oldAppBar,
);

typedef LMChatroomAppBarBuilder = LMChatAppBar Function(
  ChatRoom chatrooom,
  LMChatAppBar oldAppBar,
);

typedef LMChatroomTileBuilder = LMChatTile Function(
  ChatRoom chatroom,
  LMChatTile oldTile,
);

typedef LMChatBubbleBuilder = Widget Function(
  Conversation conversation,
  User user,
  LMChatBubble oldBubble,
);

typedef LMChatStateBubbleBuilder = Widget Function(
  String message,
  LMChatStateBubble oldStateBubble,
);

typedef LMChatContextWidgetBuilder = Widget Function(BuildContext context);

typedef LMChatroomChatBarBuilder = Widget Function(
  ChatRoom chatroom,
  Function onMessageSent,
);
