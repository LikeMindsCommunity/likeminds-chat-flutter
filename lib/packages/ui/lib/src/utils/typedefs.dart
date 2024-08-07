import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// {@template lm_context_widget_builder}
/// The context widget builder function for the chat screen.
/// This function is called to build the context widget for the chat screen.
/// The [LMContextWidgetBuilder] function takes one parameter:
/// - [BuildContext] context: The context.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMContextWidgetBuilder = Widget Function(BuildContext context);

/// {@template lm_chat_error_handler}
/// The error handler function for the chat.
/// This function is called when an error occurs in the chat.
/// The [LMChatErrorHandler] function takes two parameters:
/// - [String] errorMessage: The error message.
/// - [StackTrace] stackTrace: The stack
/// {@endtemplate}
typedef LMChatErrorHandler = Function(String, StackTrace);

/// {@template lm_chat_button_builder}
/// The button builder function for the chat.
/// This function is called to build the button for the chat.
/// The [LMChatButtonBuilder] function takes one parameter:
/// - [LMChatButton] olButton: The old button.
/// The function returns a [LMChatButton] widget.
/// {@endtemplate}
typedef LMChatButtonBuilder = LMChatButton Function(LMChatButton olButton);

/// {@template lm_chat_home_app_bar_builder}
/// The app bar builder function for the chat home screen.
/// This function is called to build the app bar for the chat home screen.
/// The [LMChatHomeAppBarBuilder] function takes two parameters:
/// - [LMChatUserViewData] currentUser: The current user.
/// - [LMChatAppBar] oldAppBar: The old app bar.
/// The function returns a [LMChatAppBar] widget.
/// {@endtemplate}
typedef LMChatHomeAppBarBuilder = LMChatAppBar Function(
  LMChatUserViewData currentUser,
  LMChatAppBar oldAppBar,
);

/// {@template lm_chat_home_tile_builder}
/// The tile builder function for the chat home screen.
/// This function is called to build the tile for the chat home screen.
/// The [LMChatHomeTileBuilder] function takes two parameters:
/// - [LMChatUserViewData] user: The user.
/// - [LMChatTile] oldTile: The old tile.
/// The function returns a [LMChatTile] widget.
/// {@endtemplate}

typedef LMChatroomAppBarBuilder = LMChatAppBar Function(
  LMChatRoomViewData chatrooom,
  LMChatAppBar oldAppBar,
);

/// {@template lm_chat_app_bar_builder}
/// The app bar builder function for the any screen.
/// This function is called to build the app bar for the chat screen.
/// The [LMChatAppBarBuilder] function takes one parameter:
/// - [LMChatAppBar] oldAppBar: The old app bar.
/// The function returns a [LMChatAppBar] widget.
/// {@endtemplate}
typedef LMChatAppBarBuilder = LMChatAppBar Function(
  LMChatAppBar oldAppBar,
);

/// {@template lm_chatroom_tile_builder}
/// The tile builder function for the chat room screen.
/// This function is called to build the tile for the chat room screen.
/// The [LMChatroomTileBuilder] function takes two parameters:
/// - [LMChatRoomViewData] chatroom: The chat room.
/// - [LMChatTile] oldTile: The old tile.
/// The function returns a [LMChatTile] widget.
/// {@endtemplate}

typedef LMChatroomTileBuilder = LMChatTile Function(
  LMChatRoomViewData chatroom,
  LMChatTile oldTile,
);

/// {@template lm_chat_bubble_builder}
/// this function is called to build the chat bubble for the chat screen.
/// The [LMChatBubbleBuilder] function takes three parameters:
/// - [LMChatConversationViewData] conversation: The conversation.
/// - [LMChatUserViewData] user: The user.
/// - [LMChatBubble] oldBubble: The old bubble.
/// The function returns a [LMChatBubble] widget.
/// {@endtemplate}
typedef LMChatBubbleBuilder = Widget Function(
  LMChatConversationViewData conversation,
  LMChatUserViewData user,
  LMChatBubble oldBubble,
);

/// {@template lm_chat_state_bubble_builder}
/// The state bubble builder function for the chat screen.
/// This function is called to build the state bubble for the chat screen.
/// The [LMChatStateBubbleBuilder] function takes two parameters:
/// - [String] message: The message.
/// - [LMChatStateBubble] oldStateBubble: The old state bubble.
/// The function returns a [LMChatStateBubble] widget.
/// {@endtemplate}
typedef LMChatStateBubbleBuilder = Widget Function(
  String message,
  LMChatStateBubble oldStateBubble,
);

/// {@template lm_chat_context_widget_builder}
/// The context widget builder function for the chat screen.
/// This function is called to build the context widget for the chat screen.
/// The [LMChatContextWidgetBuilder] function takes one parameter:
/// - [BuildContext] context: The context.
/// The function returns a [Widget].
/// {@endtemplate}

typedef LMChatContextWidgetBuilder = Widget Function(BuildContext context);

/// {@template lm_chatroom_chat_bar_builder}
/// The chat bar builder function for the chat room screen.
/// This function is called to build the chat bar for the chat room screen.
/// The [LMChatroomChatBarBuilder] function takes two parameters:
/// - [LMChatRoomViewData] chatroom: The chat room.
/// - [Function] onMessageSent: The on message sent function.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatroomChatBarBuilder = Widget Function(
  LMChatRoomViewData chatroom,
  Function onMessageSent,
);

/// {@template lm_chat_tile_builder}
/// The tile builder function for the chat screen.
/// This function is called to build the tile for the chat screen.
/// The [LMChatTileBuilder] function takes two parameters:
/// - [LMChatConversationViewData] conversation: The conversation.
/// - [LMChatTile] oldTile: The old tile.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatUserTileBuilder = Widget Function(
  BuildContext context,
  LMChatUserViewData user,
  LMChatUserTile oldUserTile,
);
