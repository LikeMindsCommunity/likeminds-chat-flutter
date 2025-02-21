import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A custom chat bubble widget for displaying messages in a chat interface.
///
/// The `LMCustomChatBubble` widget is designed to provide a customizable
/// chat bubble that can be used to display text messages. It supports
/// various customization options such as background color, text color,
/// border radius, and padding.
///
/// Example usage:
/// ```dart
/// LMCustomChatBubble(
///   message: "Hello, how are you?",
///   backgroundColor: Colors.blue,
///   textColor: Colors.white,
///   borderRadius: BorderRadius.circular(8.0),
///   padding: EdgeInsets.all(10.0),
/// )
/// ```
///
/// Properties:
/// - `message`: The text message to be displayed inside the chat bubble.
/// - `backgroundColor`: The background color of the chat bubble.
/// - `textColor`: The color of the text inside the chat bubble.
/// - `borderRadius`: The border radius of the chat bubble.
/// - `padding`: The padding inside the chat bubble.
///
class LMCustomChatBubble extends StatelessWidget {
  /// [LMChatConversationViewData] is data of the conversation.
  final LMChatConversationViewData conversation;

  /// The current user.
  final LMChatUserViewData currentUser;

  /// The user of the conversation.
  final LMChatUserViewData conversationUser;

  /// The list of attachments for this chat bubble
  final List<LMChatAttachmentViewData>? attachments;

  /// The list of attachments for this chat bubble
  final List<LMChatReactionViewData>? reactions;

  /// The user meta for this chat bubble
  final Map<int, LMChatUserViewData>? userMeta;

  /// is the message sent by the current user.
  final bool? isSent;

  /// The reply icon.
  final LMChatIcon? replyIcon;

  /// The avatar of the user.
  final LMChatProfilePicture? avatar;

  /// The avatar builder for the user.
  final LMChatProfilePictureBuilder? avatarBuilder;

  /// The function to call when a reply is made.
  final Function(LMChatConversationViewData)? onReply;

  /// The function to call when a tag is tapped.
  final Function(String tag) onTagTap;

  /// The deleted text.
  final LMChatText? deletedText;

  /// The style of the bubble.
  final LMChatBubbleStyle? style;

  /// The selected state of the bubble.
  final bool isSelected;

  /// The function to call when the bubble is tapped.
  final Function(bool isSelected, State<LMChatBubble> state)? onTap;

  /// The function to call when the bubble media is tapped.
  final void Function()? onMediaTap;

  /// The function to call when the bubble is long pressed.
  final Function(bool isSelected, State<LMChatBubble> state)? onLongPress;

  /// The function to call when the bubble is selectable on tap.
  final bool Function()? isSelectableOnTap;

  /// The header builder.
  final Widget Function(BuildContext context, LMChatBubbleHeader header)?
      headerBuilder;

  /// The content builder.
  final Widget Function(BuildContext context, LMChatBubbleContent content)?
      contentBuilder;

  /// The footer builder.
  final Widget Function(BuildContext context, LMChatBubbleFooter footer)?
      footerBuilder;

  /// The deleted text builder.
  final Widget Function(BuildContext context, LMChatText text)?
      deletedTextBuilder;

  /// bool to check whether a message is a DM message
  final bool? isDM;

  /// The media builder.
  final Widget Function(
    BuildContext context,
    List<LMChatAttachmentViewData>? attachments,
    LMChatBubbleMedia media,
  )? mediaBuilder;

  /// The function to call when a reaction is made.
  final Function(String reaction)? onReaction;

  /// The function to call when a reaction is removed from bottom sheet.
  final Function(String reaction)? onRemoveReaction;

  /// The builder function to build a reply widget
  final Function(LMChatConversationViewData reply, LMChatBubbleReply oldWidget)?
      replyBuilder;

  /// The Link Preview widget builder.s
  final Widget Function(
    LMChatOGTagsViewData ogTags,
    LMChatLinkPreview oldLinkPreviewWidget,
  )? linkPreviewBuilder;

  /// Builder for bubble reactions
  final Widget Function(List<LMChatReactionViewData> reactions,
      LMChatBubbleReactions oldWidget)? bubbleReactionsBuilder;

  /// Builder for reactions bar on chat bubble
  final Widget Function(LMChatReactionBar oldWidget)? reactionBarBuilder;

  ///Callback for catching when reactions are tapped
  final VoidCallback? onReactionsTap;

  /// Poll Widget
  final LMChatPoll? poll;

  /// Poll Widget builder
  final LMChatPollBuilder? pollBuilder;

  /// Instance of [LMChatAudioHandler] to manage audio playback seamlessly
  final LMChatAudioHandler? audioHandler;

  /// Callback for reply tap
  final VoidCallback? onReplyTap;

  /// The action helper for the chat bubble
  final LMChatConversationActionInterface? actionHelper;

  /// The [LMChatBubble] widget constructor.
  /// used to display the chat bubble.
  const LMCustomChatBubble({
    super.key,
    required this.conversation,
    required this.currentUser,
    required this.conversationUser,
    required this.onTagTap,
    this.audioHandler,
    this.reactions,
    this.userMeta,
    this.onRemoveReaction,
    this.attachments,
    this.style,
    this.contentBuilder,
    this.onReply,
    this.replyIcon,
    this.avatar,
    this.avatarBuilder,
    this.isSent,
    this.deletedText,
    this.isSelected = false,
    this.isDM,
    this.onTap,
    this.onMediaTap,
    this.onLongPress,
    this.isSelectableOnTap,
    this.headerBuilder,
    this.footerBuilder,
    this.deletedTextBuilder,
    this.mediaBuilder,
    this.onReaction,
    this.linkPreviewBuilder,
    this.poll,
    this.pollBuilder,
    this.bubbleReactionsBuilder,
    this.reactionBarBuilder,
    this.replyBuilder,
    this.onReactionsTap,
    this.onReplyTap,
    this.actionHelper,
  });

  /// Creates a copy of this [LMChatBubble] but with the given fields replaced with the new values.
  /// If the new values are null, then the old values are used.
  LMCustomChatBubble copyWith({
    LMChatConversationActionInterface? actionHelper,
    LMChatConversationViewData? conversation,
    LMChatUserViewData? currentUser,
    LMChatUserViewData? conversationUser,
    List<LMChatAttachmentViewData>? attachments,
    bool? isSent,
    LMChatIcon? replyIcon,
    LMChatProfilePicture? avatar,
    LMChatProfilePictureBuilder? avatarBuilder,
    Function(LMChatConversationViewData)? onReply,
    Function(String tag)? onTagTap,
    LMChatText? deletedText,
    LMChatBubbleStyle? style,
    bool? isSelected,
    Function(bool isSelected, State<LMChatBubble> state)? onTap,
    void Function()? onMediaTap,
    Function(bool isSelected, State<LMChatBubble> state)? onLongPress,
    bool Function()? isSelectableOnTap,
    Widget Function(BuildContext context, LMChatBubbleContent content)?
        contentBuilder,
    Widget Function(BuildContext context, LMChatBubbleHeader header)?
        headerBuilder,
    Widget Function(BuildContext context, LMChatBubbleFooter footer)?
        footerBuilder,
    Widget Function(BuildContext context, LMChatText text)? deletedTextBuilder,
    Widget Function(
      BuildContext context,
      List<LMChatAttachmentViewData>? attachments,
      LMChatBubbleMedia media,
    )? mediaBuilder,
    Function(String reaction)? onReaction,
    Widget Function(LMChatOGTagsViewData ogTags,
            LMChatLinkPreview oldLinkPreviewWidget)?
        linkPreviewBuilder,
    bool? isDM,
    LMChatPoll? poll,
    LMChatPollBuilder? pollBuilder,
    Widget Function(List<LMChatReactionViewData> reactions,
            LMChatBubbleReactions oldWidget)?
        bubbleReactionsBuilder,
    Widget Function(LMChatReactionBar oldWidget)? reactionBarBuilder,
    VoidCallback? onReplyTap,
  }) {
    return LMCustomChatBubble(
      actionHelper: actionHelper ?? this.actionHelper,
      conversation: conversation ?? this.conversation,
      currentUser: currentUser ?? this.currentUser,
      conversationUser: conversationUser ?? this.conversationUser,
      attachments: attachments ?? this.attachments,
      isSent: isSent ?? this.isSent,
      onReply: onReply ?? this.onReply,
      onTagTap: onTagTap ?? this.onTagTap,
      replyIcon: replyIcon ?? this.replyIcon,
      avatar: avatar ?? this.avatar,
      avatarBuilder: avatarBuilder ?? this.avatarBuilder,
      deletedText: deletedText ?? this.deletedText,
      style: style ?? this.style,
      isSelected: isSelected ?? this.isSelected,
      onTap: onTap ?? this.onTap,
      onMediaTap: onMediaTap ?? this.onMediaTap,
      onLongPress: onLongPress ?? this.onLongPress,
      isSelectableOnTap: isSelectableOnTap ?? this.isSelectableOnTap,
      contentBuilder: contentBuilder ?? this.contentBuilder,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      footerBuilder: footerBuilder ?? this.footerBuilder,
      deletedTextBuilder: deletedTextBuilder ?? this.deletedTextBuilder,
      mediaBuilder: mediaBuilder ?? this.mediaBuilder,
      onReaction: onReaction ?? this.onReaction,
      linkPreviewBuilder: linkPreviewBuilder ?? this.linkPreviewBuilder,
      isDM: isDM ?? this.isDM,
      poll: poll ?? this.poll,
      pollBuilder: pollBuilder ?? this.pollBuilder,
      bubbleReactionsBuilder:
          bubbleReactionsBuilder ?? this.bubbleReactionsBuilder,
      reactionBarBuilder: reactionBarBuilder ?? this.reactionBarBuilder,
      onReplyTap: onReplyTap ?? this.onReplyTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
