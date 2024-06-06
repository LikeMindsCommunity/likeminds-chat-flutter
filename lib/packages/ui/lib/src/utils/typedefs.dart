import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/models/chatroom/chatroom_view_data.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

typedef LMChatErrorHandler = Function(String, StackTrace);

typedef LMChatHomeAppBarBuilder = LMChatAppBar Function(
  LMChatUserViewData currentUser,
  LMChatAppBar oldAppBar,
);

typedef LMChatroomAppBarBuilder = LMChatAppBar Function(
  LMChatRoomViewData chatrooom,
  LMChatAppBar oldAppBar,
);

typedef LMChatroomTileBuilder = LMChatTile Function(
  LMChatRoomViewData chatroom,
  LMChatTile oldTile,
);

typedef LMChatBubbleBuilder = Widget Function(
  LMChatConversationViewData conversation,
  LMChatUserViewData user,
  LMChatBubble oldBubble,
);

typedef LMChatStateBubbleBuilder = Widget Function(
  String message,
  LMChatStateBubble oldStateBubble,
);

typedef LMChatContextWidgetBuilder = Widget Function(BuildContext context);

typedef LMChatroomChatBarBuilder = Widget Function(
  LMChatRoomViewData chatroom,
  Function onMessageSent,
);
