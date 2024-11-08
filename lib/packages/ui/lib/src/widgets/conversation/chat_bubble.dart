import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/media/attachment_convertor.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/conversation/chat_bubble_clipper.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/media/voice_note.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:collection/collection.dart';

part 'chat_bubble_content.dart';
part 'chat_bubble_footer.dart';
part 'chat_bubble_header.dart';
part 'chat_bubble_media.dart';
part 'chat_bubble_reply.dart';
part 'chat_bubble_sides.dart';
part 'chat_bubble_state.dart';
part 'chat_bubble_reactions.dart';

/// {@template lm_chat_bubble}
/// The chat bubble widget.
/// This widget is used to display the chat bubble.
/// {@endtemplate}
class LMChatBubble extends StatefulWidget {
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

  /// The [LMChatBubble] widget constructor.
  /// used to display the chat bubble.
  const LMChatBubble({
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
  });

  /// Creates a copy of this [LMChatBubble] but with the given fields replaced with the new values.
  /// If the new values are null, then the old values are used.
  LMChatBubble copyWith({
    LMChatConversationViewData? conversation,
    LMChatUserViewData? currentUser,
    LMChatUserViewData? conversationUser,
    List<LMChatAttachmentViewData>? attachments,
    bool? isSent,
    LMChatIcon? replyIcon,
    LMChatProfilePicture? avatar,
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
  }) {
    return LMChatBubble(
      conversation: conversation ?? this.conversation,
      currentUser: currentUser ?? this.currentUser,
      conversationUser: conversationUser ?? this.conversationUser,
      attachments: attachments ?? this.attachments,
      isSent: isSent ?? this.isSent,
      onReply: onReply ?? this.onReply,
      onTagTap: onTagTap ?? this.onTagTap,
      replyIcon: replyIcon ?? this.replyIcon,
      avatar: avatar ?? this.avatar,
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
    );
  }

  @override
  State<LMChatBubble> createState() => _LMChatBubbleState();
}

class _LMChatBubbleState extends State<LMChatBubble> {
  late LMChatConversationViewData conversation;
  late LMChatUserViewData currentUser;
  late LMChatUserViewData conversationUser;
  late GlobalObjectKey _chatBubbleKey;

  bool isSent = false;
  bool _isSelected = false;
  bool _isDeleted = false;
  final LMChatThemeData _themeData = LMChatTheme.theme;

  final CustomPopupMenuController reactionBarController =
      CustomPopupMenuController();
  final LMChatThemeData theme = LMChatTheme.theme;
  List<LMChatReactionViewData>? reactions = [];

  // Add ValueNotifier for voice note duration
  late final ValueNotifier<Duration> _voiceNoteDurationNotifier;

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    currentUser = widget.currentUser;
    conversationUser = widget.conversationUser;
    isSent = currentUser.id == conversationUser.id;
    _isSelected = widget.isSelected;
    _isDeleted = conversation.deletedByUserId != null;
    _chatBubbleKey = GlobalObjectKey(conversation.id);
    reactions = widget.reactions;

    // Initialize voice note duration from metadata if available
    final Duration initialDuration;
    if (!_isDeleted) {
      final voiceNoteAttachment = widget.attachments?.firstWhereOrNull(
          (attachment) => attachment.type == kAttachmentTypeVoiceNote);

      initialDuration = Duration(
        seconds: int.tryParse(
              voiceNoteAttachment?.meta?["duration"]?.toString() ?? "0",
            ) ??
            0,
      );
    } else {
      initialDuration = Duration.zero;
    }
    _voiceNoteDurationNotifier = ValueNotifier(initialDuration);
  }

  @override
  void didUpdateWidget(LMChatBubble old) {
    super.didUpdateWidget(old);
    conversation = widget.conversation;
    currentUser = widget.currentUser;
    conversationUser = widget.conversationUser;
    isSent = currentUser.id == conversationUser.id;
    _isSelected = widget.isSelected;
    _isDeleted = conversation.deletedByUserId != null;
    reactions = widget.reactions;

    // Update duration notifier if attachments change
    if (!_isDeleted &&
        widget.attachments?.first.meta?["duration"] !=
            old.attachments?.first.meta?["duration"]) {
      _voiceNoteDurationNotifier.value = Duration(
        seconds: int.tryParse(
              widget.attachments?.first.meta["duration"]?.toString() ?? "0",
            ) ??
            0,
      );
    }
  }

  @override
  void dispose() {
    _voiceNoteDurationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double finalWidth = calculateFinalWidth();

    final inStyle = widget.style ?? LMChatTheme.theme.bubbleStyle;
    return _isDeleted
        ? _defChatBubble(inStyle, context, finalWidth)
        : Swipeable(
            dismissThresholds: const {SwipeDirection.startToEnd: 0.0},
            movementDuration: const Duration(milliseconds: 50),
            key: ObjectKey(conversation.id),
            onSwipe: (direction) {
              if (widget.onReply != null &&
                  widget.conversation.deletedByUserId == null) {
                widget.onReply!(conversation);
              }
            },
            background: Padding(
              padding: EdgeInsets.only(
                left: 2.w,
                right: 2.w,
                top: 0.2.h,
                bottom: 0.2.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.replyIcon ??
                      LMChatIcon(
                        type: LMChatIconType.icon,
                        icon: Icons.reply_outlined,
                        style: LMChatIconStyle(
                          color: LMChatTheme.theme.primaryColor,
                          size: 28,
                          boxSize: 28,
                        ),
                      ),
                ],
              ),
            ),
            direction: SwipeDirection.startToEnd,
            child: _defChatBubble(inStyle, context, finalWidth),
          );
  }

  Widget _defChatBubble(
      LMChatBubbleStyle inStyle, BuildContext context, double finalWidth) {
    return GestureDetector(
      onLongPress: () {
        if (_isDeleted) return;
        _isSelected = !_isSelected;
        widget.onLongPress?.call(_isSelected, this);
        reactionBarController.showMenu();
      },
      onTap: () {
        if (_isDeleted) return;
        if (_isSelected) {
          _isSelected = false;
          widget.onTap?.call(_isSelected, this);
        } else {
          if (widget.isSelectableOnTap?.call() ?? false) {
            _isSelected = !_isSelected;
            widget.onTap?.call(_isSelected, this);
          }
        }
      },
      child: Stack(
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              color: _isSelected
                  ? inStyle.selectedColor ??
                      const Color.fromRGBO(0, 96, 86, 0.3)
                  : null,
            ),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
            child: Row(
              mainAxisAlignment:
                  isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isSent) widget.avatar ?? const SizedBox(),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AbsorbPointer(
                      absorbing: _isDeleted,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 2.h,
                          minWidth: conversation.answer.split('\n').length > 4
                              ? 40.w
                              : 5.w,
                          maxWidth: (widget.attachments != null &&
                                  widget.attachments!.isNotEmpty)
                              ? 60.w
                              : conversation.state == 10
                                  ? 70.w
                                  : 65.w,
                        ),
                        child: PhysicalShape(
                          clipper: LMChatBubbleClipper(
                            isSent: isSent,
                          ),
                          color:
                              inStyle.backgroundColor ?? _themeData.container,
                          child: Padding(
                            padding: isSent
                                ? EdgeInsets.only(
                                    top: _isDeleted ? 0.8.h : 1.h,
                                    bottom: _isDeleted ? 1.2.h : 1.h,
                                    left: 2.w,
                                    right: 4.w,
                                  )
                                : EdgeInsets.only(
                                    top: _isDeleted ? 0.8.h : 1.h,
                                    bottom: _isDeleted ? 1.2.h : 1.h,
                                    left: 4.w,
                                    right: 2.w,
                                  ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (inStyle.showHeader ?? true)
                                  widget.headerBuilder?.call(
                                          context,
                                          LMChatBubbleHeader(
                                            conversationUser:
                                                widget.conversationUser,
                                          )) ??
                                      LMChatBubbleHeader(
                                        conversationUser:
                                            widget.conversationUser,
                                      ),
                                // poll widget
                                if (conversation.state == 10 &&
                                    !_isDeleted) ...[
                                  widget.pollBuilder?.call(
                                        context,
                                        widget.poll ??
                                            LMChatPoll(
                                              pollData: conversation,
                                            ),
                                        conversation,
                                      ) ??
                                      widget.poll ??
                                      LMChatPoll(
                                        pollData: conversation,
                                      ),
                                ],
                                // link preview widget
                                if (conversation.ogTags != null &&
                                    conversation.deletedByUserId == null)
                                  widget.linkPreviewBuilder?.call(
                                        conversation.ogTags!,
                                        _defLinkPreviewWidget(
                                            conversation.ogTags!),
                                      ) ??
                                      _defLinkPreviewWidget(
                                          conversation.ogTags!),
                                if (conversation.replyConversationObject !=
                                        null &&
                                    conversation.deletedByUserId == null) ...[
                                  widget.replyBuilder?.call(
                                          conversation.replyConversationObject!,
                                          _defReplyWidget()) ??
                                      _defReplyWidget(),
                                  const SizedBox(height: 4),
                                ],
                                AbsorbPointer(
                                  absorbing: _isSelected,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.attachments != null) {
                                        widget.onMediaTap?.call();
                                      }
                                    },
                                    child: _isDeleted
                                        ? widget.mediaBuilder?.call(
                                              context,
                                              widget.attachments ?? [],
                                              LMChatBubbleMedia(
                                                audioHandler:
                                                    widget.audioHandler,
                                                conversation: conversation,
                                                attachments:
                                                    widget.attachments ?? [],
                                                count: conversation
                                                        .attachmentCount ??
                                                    0,
                                                attachmentUploaded: conversation
                                                        .attachmentsUploaded ??
                                                    false,
                                                onVoiceNoteDurationUpdate:
                                                    kAttachmentTypeVoiceNote ==
                                                            widget.attachments
                                                                ?.first.type
                                                        ? _handleVoiceNoteDurationUpdate
                                                        : null,
                                              ),
                                            ) ??
                                            LMChatBubbleMedia(
                                              audioHandler: widget.audioHandler,
                                              conversation: conversation,
                                              attachments:
                                                  widget.attachments ?? [],
                                              count: conversation
                                                      .attachmentCount ??
                                                  0,
                                              attachmentUploaded: conversation
                                                      .attachmentsUploaded ??
                                                  false,
                                              onVoiceNoteDurationUpdate:
                                                  kAttachmentTypeVoiceNote ==
                                                          widget.attachments
                                                              ?.first.type
                                                      ? _handleVoiceNoteDurationUpdate
                                                      : null,
                                            )
                                        : null,
                                  ),
                                ),
                                _isDeleted
                                    ? widget.deletedText ??
                                        widget.deletedTextBuilder?.call(
                                          context,
                                          _defDeletedWidget(),
                                        ) ??
                                        _defDeletedWidget()
                                    : conversation.state == 10
                                        ? const SizedBox.shrink()
                                        : widget.contentBuilder?.call(
                                              context,
                                              LMChatBubbleContent(
                                                conversation: widget.attachments
                                                            ?.first.type ==
                                                        "gif"
                                                    ? conversation.copyWith(
                                                        answer: _getGIFText())
                                                    : conversation,
                                                onTagTap: widget.onTagTap,
                                              ),
                                            ) ??
                                            LMChatBubbleContent(
                                              conversation: widget.attachments
                                                          ?.first.type ==
                                                      "gif"
                                                  ? conversation.copyWith(
                                                      answer: _getGIFText())
                                                  : conversation,
                                              onTagTap: widget.onTagTap,
                                            ),
                                if (conversation.deletedByUserId == null &&
                                    inStyle.showFooter == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: kAttachmentTypeVoiceNote ==
                                            widget.attachments?.first.type
                                        ? ValueListenableBuilder<Duration>(
                                            valueListenable:
                                                _voiceNoteDurationNotifier,
                                            builder: (context, duration, _) {
                                              final footerWidget =
                                                  LMChatBubbleFooter(
                                                conversation: conversation,
                                                textWidth: finalWidth,
                                                voiceDuration: LMChatText(
                                                  formatDuration(
                                                      duration.inSeconds),
                                                  style: LMChatTextStyle(
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: LMChatTheme
                                                          .theme.onContainer
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                              );

                                              return widget.footerBuilder?.call(
                                                    context,
                                                    footerWidget,
                                                  ) ??
                                                  footerWidget;
                                            },
                                          )
                                        : widget.footerBuilder?.call(
                                              context,
                                              LMChatBubbleFooter(
                                                conversation: conversation,
                                                textWidth: finalWidth,
                                              ),
                                            ) ??
                                            LMChatBubbleFooter(
                                              conversation: conversation,
                                              textWidth: finalWidth,
                                            ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.bubbleReactionsBuilder?.call(
                            reactions ?? [],
                            LMChatBubbleReactions(
                              conversation: conversation,
                              currentUser: currentUser,
                              userMeta: widget.userMeta ?? {},
                              onRemoveReaction: widget.onRemoveReaction,
                              reactions: reactions,
                              onReactionsTap: widget.onReactionsTap,
                            )) ??
                        LMChatBubbleReactions(
                          conversation: conversation,
                          currentUser: currentUser,
                          userMeta: widget.userMeta ?? {},
                          onRemoveReaction: widget.onRemoveReaction,
                          reactions: reactions,
                          onReactionsTap: widget.onReactionsTap,
                        ),
                  ],
                ),
                const SizedBox(width: 6),
                if (isSent) widget.avatar ?? const SizedBox(),
              ],
            ),
          ),
          _buildReactionButton(),
        ],
      ),
    );
  }

  LMChatBubbleReply _defReplyWidget() {
    return LMChatBubbleReply(
      replyToConversation: conversation.replyConversationObject!,
      title: LMChatText(
        currentUser.id == conversation.replyConversationObject!.memberId
            ? "You"
            : conversation.replyConversationObject!.member!.name,
        style: LMChatTextStyle(
          maxLines: 1,
          textStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: _themeData.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  LMChatLinkPreview _defLinkPreviewWidget(LMChatOGTagsViewData ogTags) {
    return LMChatLinkPreview(
      ogTags: ogTags,
      style: widget.style?.linkPreviewStyle ??
          LMChatLinkPreviewStyle.basic(
            inactiveColor: _themeData.inActiveColor,
            containerColor: _themeData.onContainer,
          ),
    );
  }

  LMChatText _defDeletedWidget() {
    return LMChatText(
      _getDeletedText(),
      style: LMChatTextStyle(
        textStyle: _isDeleted
            ? TextStyle(
                fontStyle: FontStyle.italic,
                color: LMChatTheme.theme.disabledColor,
              )
            : TextStyle(
                fontSize: 14,
                color: LMChatTheme.theme.disabledColor,
              ),
      ),
    );
  }

  String _getDeletedText() {
    return conversation.deletedByUserId == conversation.memberId
        ? conversation.deletedByUserId == currentUser.id
            ? 'You deleted this message'
            : "This message was deleted"
        : "This message was deleted by a community manager";
  }

  String _getGIFText() {
    String gifText = conversation.answer;
    const String gifMessageIndicator =
        "* This is a gif message. Please update your app *";

    if (gifText.endsWith(gifMessageIndicator)) {
      gifText = gifText
          .substring(0, gifText.length - gifMessageIndicator.length)
          .trim();
    }

    return gifText;
  }

  double calculateFinalWidth() {
    // if the conversation is a poll, return the max width
    if (conversation.state == 10) return double.infinity;

    // Get all lines of text
    final lines =
        LMChatTaggingHelper.convertRouteToTag(widget.conversation.answer)!
            .split('\n');

    // Measure width for each line
    double maxTextWidth = 0;
    for (String line in lines) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: line,
          style: const TextStyle(fontSize: 14),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      if (textPainter.width > maxTextWidth) {
        maxTextWidth = textPainter.width;
      }
    }
    maxTextWidth += 1; // Add padding

    // Determine the width to use
    if ((widget.attachments != null && widget.attachments!.isNotEmpty) ||
        conversation.replyId != null ||
        conversation.replyConversationObject != null) {
      return 65.w; // Full width if media or reply is present
    }

    if (conversation.ogTags != null) {
      return double.infinity; // Full width if link preview is present
    }

    if (widget.isDM == true) {
      return maxTextWidth; // Only consider text width for DM
    } else {
      // Measure the header width if a header is present and not a DM
      final headerPainter = TextPainter(
        text: TextSpan(
          text: conversationUser.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );
      headerPainter.layout();
      double headerWidth =
          conversation.memberId == currentUser.id ? 0 : headerPainter.width;

      return maxTextWidth > headerWidth ? maxTextWidth : headerWidth;
    }
  }

  Widget _buildReactionButton() {
    return IgnorePointer(
      child: SizedBox(
        height: getHeightOfWidget(_chatBubbleKey),
        child: CustomPopupMenu(
          pressType: PressType.longPress,
          controller: reactionBarController,
          arrowColor: Colors.transparent,
          barrierColor: Colors.transparent,
          position: PreferredPosition.top,
          verticalMargin: 4,
          menuBuilder: () =>
              widget.reactionBarBuilder?.call(LMChatReactionBar(
                onReaction: (reaction) {
                  widget.onReaction?.call(reaction);
                  reactionBarController.hideMenu();
                  if (_isSelected) {
                    _isSelected = false;
                    widget.onTap?.call(_isSelected, this);
                  } else {
                    if (widget.isSelectableOnTap?.call() ?? false) {
                      _isSelected = !_isSelected;
                      widget.onTap?.call(_isSelected, this);
                    }
                  }
                },
              )) ??
              LMChatReactionBar(
                onReaction: (reaction) {
                  widget.onReaction?.call(reaction);
                  reactionBarController.hideMenu();
                  if (_isSelected) {
                    _isSelected = false;
                    widget.onTap?.call(_isSelected, this);
                  } else {
                    if (widget.isSelectableOnTap?.call() ?? false) {
                      _isSelected = !_isSelected;
                      widget.onTap?.call(_isSelected, this);
                    }
                  }
                },
              ),
          child: const SizedBox(),
        ),
      ),
    );
  }

  String formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Update the duration handler to use ValueNotifier
  void _handleVoiceNoteDurationUpdate(Duration duration) {
    // Only update if the duration is greater than zero to avoid resetting to 0
    if (duration.inSeconds > 0) {
      _voiceNoteDurationNotifier.value = duration;
    }
  }
}

/// {@template lm_chat_bubble_style}
/// Style configuration for the chat bubble.
/// {@endtemplate}
class LMChatBubbleStyle {
  /// The width of the chat bubble.
  final double? width;

  /// The height of the chat bubble.
  final double? height;

  /// The width of the border.
  final double? borderWidth;

  /// The radius of the border.
  final double? borderRadiusNum;

  /// The border radius.
  final BorderRadius? borderRadius;

  /// The color of the border.
  final Color? borderColor;

  /// The background color of the chat bubble.
  final Color? backgroundColor;

  /// The color of the sent message.
  final Color? sentColor;

  /// The color when the chat bubble is selected.
  final Color? selectedColor;

  /// Whether to show action buttons.
  final bool? showActions;

  /// Whether to show the header.
  final bool? showHeader;

  /// Whether to show the footer.
  final bool? showFooter;

  /// Whether to show the sides.
  final bool? showSides;

  /// Whether to show the avatar.
  final bool? showAvatar;
  final LMChatLinkPreviewStyle? linkPreviewStyle;

  /// {@macro lm_chat_bubble_style}
  LMChatBubbleStyle({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderRadiusNum,
    this.borderWidth,
    this.height,
    this.sentColor,
    this.selectedColor,
    this.showActions,
    this.width,
    this.showAvatar,
    this.showFooter,
    this.showHeader,
    this.showSides,
    this.linkPreviewStyle,
  });

  /// Creates a copy of the current style with optional new values.
  LMChatBubbleStyle copyWith({
    double? width,
    double? height,
    double? borderWidth,
    double? borderRadiusNum,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    Color? sentColor,
    Color? selectedColor,
    bool? showActions,
    bool? showSides,
    bool? showAvatar,
    bool? showHeader,
    bool? showFooter,
    LMChatLinkPreviewStyle? linkPreviewStyle,
  }) {
    return LMChatBubbleStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadiusNum: borderRadiusNum ?? this.borderRadiusNum,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sentColor: sentColor ?? this.sentColor,
      selectedColor: selectedColor ?? this.selectedColor,
      showActions: showActions ?? this.showActions,
      showAvatar: showAvatar ?? this.showAvatar,
      showFooter: showFooter ?? this.showFooter,
      showHeader: showHeader ?? this.showHeader,
      showSides: showSides ?? this.showSides,
      linkPreviewStyle: linkPreviewStyle ?? this.linkPreviewStyle,
    );
  }

  /// Creates a basic style with default values.
  factory LMChatBubbleStyle.basic() {
    return LMChatBubbleStyle(
      backgroundColor: LMChatDefaultTheme.container,
      selectedColor: const Color.fromRGBO(0, 96, 86, 0.3),
      showSides: true,
      showActions: true,
      showAvatar: true,
      showFooter: true,
      showHeader: true,
    );
  }
}
