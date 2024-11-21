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
/// The function returns a [Widget] widget.
/// {@endtemplate}
typedef LMChatButtonBuilder = Widget Function(LMChatButton olButton);

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

/// {@template lm_chat_image_widget_builder}
/// The image widget builder function for the chat screen.
/// This function is called to build the image widget for the chat screen.
/// The [LMChatImageBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The image attachment.
/// - [LMChatImage] oldWidget: The old image widget.
/// The function returns an [Widget].
/// {@endtemplate}
typedef LMChatImageBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatImage oldWidget,
);

/// {@template lm_chat_video_widget_builder}
/// The video widget builder function for the chat screen.
/// This function is called to build the video widget for the chat screen.
/// The [LMChatVideoBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The video attachment.
/// - [LMChatVideo] oldWidget: The old video widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatVideoBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatVideo oldWidget,
);

/// {@template lm_chat_gif_widget_builder}
/// The gif widget builder function for the chat screen.
/// This function is called to build the gif widget for the chat screen.
/// The [LMChatGIFBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The video attachment.
/// - [LMChatGIF] oldWidget: The old video widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatGIFBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatGIF oldWidget,
);

/// {@template lm_chat_voice_note_widget_builder}
/// The voice note widget builder function for the chat screen.
/// This function is called to build the voice note widget for the chat screen.
/// The [LMChatVoiceNoteBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The voice note attachment.
/// - [LMChatVoiceNote] oldWidget: The old audio widget.
/// The function returns an [Widget].
/// {@endtemplate}
typedef LMChatVoiceNoteBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatVoiceNote oldWidget,
);

/// {@template lm_chat_document_widget_builder}
/// The document widget builder function for the chat screen.
/// This function is called to build the document widget for the chat screen.
/// The [LMChatDocumentTilePreviewBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The document attachment.
/// - [LMChatDocumentTilePreview] oldWidget: The old document widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatDocumentTilePreviewBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatDocumentTilePreview oldWidget,
);

/// {@template lm_chat_document_widget_builder}
/// The document widget builder function for the chat screen.
/// This function is called to build the document widget for the chat screen.
/// The [LMChatDocumentPreviewBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The document attachment.
/// - [LMChatDocumentPreview] oldWidget: The old document widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatDocumentPreviewBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatDocumentPreview oldWidget,
);

/// {@template lm_chat_document_thumbnail_widget_builder}
/// The document thumbnail widget builder function for the chat screen.
/// This function is called to build the document thumbnail widget for the chat screen.
/// The [LMChatDocumentThumbnailBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The document attachment.
/// - [LMChatDocumentThumbnail] oldWidget: The old document thumbnail widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatDocumentThumbnailBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatDocumentThumbnail oldWidget,
);

/// {@template lm_chat_document_tile_widget_builder}
/// The document tile widget builder function for the chat screen.
/// This function is called to build the document tile widget for the chat screen.
/// The [LMChatDocumentTileBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatAttachmentViewData] attachment: The document attachment.
/// - [LMChatDocumentTile] oldWidget: The old document tile widget.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatDocumentTileBuilder = Widget Function(
  BuildContext context,
  LMChatAttachmentViewData attachment,
  LMChatDocumentTile oldWidget,
);

/// {@template lm_chat_text_builder}
/// The text builder function for the chat screen.
/// This function is called to build the text for the chat screen.
/// The [LMChatTextBuilder] function takes two parameters:
/// - [BuildContext] context: The context.
/// - [LMChatText] text: The text.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatTextBuilder = Widget Function(
  BuildContext,
  LMChatText,
);

/// {@template lm_chat_poll_builder}
/// The poll builder function for the chat screen.
/// This function is called to build the poll for the chat screen.
/// The [LMChatPollBuilder] function takes three parameters:
/// - [BuildContext] context: The context.
/// - [LMChatPoll] poll: The poll.
/// - [LMChatConversationViewData] conversation: The conversation.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatPollBuilder = Widget Function(
  BuildContext context,
  LMChatPoll poll,
  LMChatConversationViewData conversation,
);

/// {@template lm_chat_icon_builder}
/// The icon builder function for the chat screen.
/// This function is called to build the icon for the chat screen.
/// The [LMChatIconBuilder] function takes two parameters:
/// - [BuildContext] context: The context.
/// - [LMChatIcon] icon: The icon.
/// The function returns a [Widget].
/// {@endtemplate}
typedef LMChatIconBuilder = Widget Function(
  BuildContext context,
  LMChatIcon icon,
);
