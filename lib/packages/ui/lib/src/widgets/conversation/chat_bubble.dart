import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/media/attachment_convertor.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/conversation/chat_bubble_clipper.dart';
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

  final Widget Function(BuildContext context, Widget container)?
      chatBubbleContainerBuilder;

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
    this.chatBubbleContainerBuilder,
  });

  /// Creates a copy of this [LMChatBubble] but with the given fields replaced with the new values.
  /// If the new values are null, then the old values are used.
  LMChatBubble copyWith({
    LMChatConversationViewData? conversation,
    LMChatUserViewData? currentUser,
    LMChatUserViewData? conversationUser,
    List<LMChatAttachmentViewData>? attachments,
    List<LMChatReactionViewData>? reactions,
    Map<int, LMChatUserViewData>? userMeta,
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
    Widget Function(BuildContext context, LMChatBubbleHeader header)?
        headerBuilder,
    Widget Function(BuildContext context, LMChatBubbleContent content)?
        contentBuilder,
    Widget Function(BuildContext context, LMChatBubbleFooter footer)?
        footerBuilder,
    Widget Function(BuildContext context, LMChatText text)? deletedTextBuilder,
    bool? isDM,
    Widget Function(
            BuildContext context,
            List<LMChatAttachmentViewData>? attachments,
            LMChatBubbleMedia media)?
        mediaBuilder,
    Function(String reaction)? onReaction,
    Function(String reaction)? onRemoveReaction,
    Function(LMChatConversationViewData reply, LMChatBubbleReply oldWidget)?
        replyBuilder,
    Widget Function(LMChatOGTagsViewData ogTags,
            LMChatLinkPreview oldLinkPreviewWidget)?
        linkPreviewBuilder,
    Widget Function(List<LMChatReactionViewData> reactions,
            LMChatBubbleReactions oldWidget)?
        bubbleReactionsBuilder,
    Widget Function(LMChatReactionBar oldWidget)? reactionBarBuilder,
    VoidCallback? onReactionsTap,
    LMChatPoll? poll,
    LMChatPollBuilder? pollBuilder,
    LMChatAudioHandler? audioHandler,
    VoidCallback? onReplyTap,
    LMChatConversationActionInterface? actionHelper,
    Widget Function(BuildContext context, Widget container)?
        chatBubbleContainerBuilder,
  }) {
    return LMChatBubble(
      conversation: conversation ?? this.conversation,
      currentUser: currentUser ?? this.currentUser,
      conversationUser: conversationUser ?? this.conversationUser,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      userMeta: userMeta ?? this.userMeta,
      isSent: isSent ?? this.isSent,
      replyIcon: replyIcon ?? this.replyIcon,
      avatar: avatar ?? this.avatar,
      avatarBuilder: avatarBuilder ?? this.avatarBuilder,
      onReply: onReply ?? this.onReply,
      onTagTap: onTagTap ?? this.onTagTap,
      deletedText: deletedText ?? this.deletedText,
      style: style ?? this.style,
      isSelected: isSelected ?? this.isSelected,
      onTap: onTap ?? this.onTap,
      onMediaTap: onMediaTap ?? this.onMediaTap,
      onLongPress: onLongPress ?? this.onLongPress,
      isSelectableOnTap: isSelectableOnTap ?? this.isSelectableOnTap,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      contentBuilder: contentBuilder ?? this.contentBuilder,
      footerBuilder: footerBuilder ?? this.footerBuilder,
      deletedTextBuilder: deletedTextBuilder ?? this.deletedTextBuilder,
      isDM: isDM ?? this.isDM,
      mediaBuilder: mediaBuilder ?? this.mediaBuilder,
      onReaction: onReaction ?? this.onReaction,
      onRemoveReaction: onRemoveReaction ?? this.onRemoveReaction,
      replyBuilder: replyBuilder ?? this.replyBuilder,
      linkPreviewBuilder: linkPreviewBuilder ?? this.linkPreviewBuilder,
      bubbleReactionsBuilder:
          bubbleReactionsBuilder ?? this.bubbleReactionsBuilder,
      reactionBarBuilder: reactionBarBuilder ?? this.reactionBarBuilder,
      onReactionsTap: onReactionsTap ?? this.onReactionsTap,
      poll: poll ?? this.poll,
      pollBuilder: pollBuilder ?? this.pollBuilder,
      audioHandler: audioHandler ?? this.audioHandler,
      onReplyTap: onReplyTap ?? this.onReplyTap,
      actionHelper: actionHelper ?? this.actionHelper,
      chatBubbleContainerBuilder:
          chatBubbleContainerBuilder ?? this.chatBubbleContainerBuilder,
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
  late Size size;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.sizeOf(context);
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
        ? _defChatBubbleBuilder(inStyle, context, finalWidth)
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
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
                vertical: size.width * 0.002,
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
            child: _defChatBubbleBuilder(inStyle, context, finalWidth),
          );
  }

  Widget _defChatBubbleBuilder(
      LMChatBubbleStyle inStyle, BuildContext context, double finalWidth) {
    return GestureDetector(
      onLongPress: () {
        if (_isDeleted) return;
        // Only handle long press if not already selected
        if (!_isSelected) {
          setState(() {
            _isSelected = true;
          });
          widget.onLongPress?.call(_isSelected, this);
          reactionBarController.showMenu();

          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset bubblePosition = renderBox.localToGlobal(Offset.zero);
          final Size bubbleSize = renderBox.size;

          // Calculate menu position based on bubble width and alignment
          const double menuWidth = 180.0; // Fixed menu width
          double menuX;

          if (isSent) {
            // For sent messages (right aligned), position from right edge
            menuX = bubblePosition.dx + bubbleSize.width - menuWidth;
          } else {
            // For received messages (left aligned), position from left edge
            menuX = bubblePosition.dx;
          }

          final Offset offset = Offset(
            menuX,
            bubblePosition.dy + bubbleSize.height + 4, // 4px gap below bubble
          );

          widget.actionHelper?.showSelectionMenu(
            context,
            offset,
          );
        }
      },
      onTap: () {
        if (_isDeleted) return;

        setState(() {
          if (_isSelected) {
            _isSelected = false;
            widget.onTap?.call(_isSelected, this);
          } else {
            // Only allow selection on tap if explicitly enabled
            if (widget.isSelectableOnTap?.call() ?? false) {
              _isSelected = true;
              widget.onTap?.call(_isSelected, this);
            }
          }
        });
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(
              milliseconds: 300,
            ),
            foregroundDecoration: BoxDecoration(
              color: _isSelected
                  ? inStyle.selectedColor ??
                      const Color.fromRGBO(0, 96, 86, 0.3)
                  : null,
            ),
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: conversation.conversationViewType !=
                      LMChatConversationViewType.bottom
                  ? 6
                  : 0,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment:
                  isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSent) ...[
                  widget.avatarBuilder?.call(
                        context,
                        _defAvatar(!isSent),
                      ) ??
                      const SizedBox.shrink(),
                  // create a space between the bubble and the avatar
                  SizedBox(width: inStyle.gap),
                ],
                widget.chatBubbleContainerBuilder?.call(
                      context,
                      _defChatContainer(inStyle, context, finalWidth),
                    ) ??
                    _defChatContainer(inStyle, context, finalWidth),
                if (isSent) ...[
                  // create a space between the bubble and the avatar
                  SizedBox(width: inStyle.gap),
                  widget.avatarBuilder?.call(
                        context,
                        _defAvatar(isSent),
                      ) ??
                      const SizedBox.shrink(),
                ]
              ],
            ),
          ),
          _buildReactionButton(),
        ],
      ),
    );
  }

  Column _defChatContainer(
      LMChatBubbleStyle inStyle, BuildContext context, double finalWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsorbPointer(
          absorbing: _isDeleted,
          child: Container(
            decoration: inStyle.decoration ??
                BoxDecoration(
                  color:
                      !inStyle.enableClipper ? inStyle.backgroundColor : null,
                ),
            constraints: BoxConstraints(
                minHeight: size.height * 0.02,
                minWidth: conversation.answer.split('\n').length > 4
                    ? size.width * 0.4
                    : size.width * 0.05,
                maxWidth: (widget.attachments != null &&
                        widget.attachments!.isNotEmpty)
                    ? size.width * 0.6
                    : conversation.state == 10
                        ? size.width * 0.7
                        : size.width * 0.65),
            child: inStyle.enableClipper
                ? PhysicalShape(
                    clipper: inStyle.clipper ??
                        LMChatBubbleClipper(
                          isSent: isSent,
                          conversationViewType:
                              conversation.conversationViewType ??
                                  LMChatConversationViewType.top,
                        ),
                    color: inStyle.backgroundColor ?? _themeData.container,
                    child: _defBubble(inStyle, context, finalWidth),
                  )
                : _defBubble(inStyle, context, finalWidth),
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
    );
  }

  Padding _defBubble(
      LMChatBubbleStyle inStyle, BuildContext context, double finalWidth) {
    return Padding(
      padding: isSent
          ? EdgeInsets.only(
              top: _isDeleted ? size.height * 0.008 : size.height * 0.01,
              bottom: _isDeleted ? size.height * 0.012 : size.height * 0.01,
              left: size.width * 0.03,
              right: size.width * 0.03 + (inStyle.enableClipper ? 10 : 0),
            )
          : EdgeInsets.only(
              top: _isDeleted ? size.height * 0.008 : size.height * 0.01,
              bottom: _isDeleted ? size.height * 0.012 : size.height * 0.01,
              left: size.width * 0.033 + (inStyle.enableClipper ? 10 : 0),
              right: size.width * 0.03,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (inStyle.showHeader ?? true)
            widget.headerBuilder?.call(
                    context,
                    LMChatBubbleHeader(
                      conversationUser: widget.conversationUser,
                    )) ??
                LMChatBubbleHeader(
                  conversationUser: widget.conversationUser,
                ),
          // poll widget
          if (conversation.state == 10 && !_isDeleted) ...[
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
                  _defLinkPreviewWidget(conversation.ogTags!),
                ) ??
                _defLinkPreviewWidget(conversation.ogTags!),
          if (conversation.replyConversationObject != null &&
              conversation.deletedByUserId == null) ...[
            widget.replyBuilder?.call(
                    conversation.replyConversationObject!, _defReplyWidget()) ??
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
              child: !_isDeleted
                  ? widget.mediaBuilder?.call(
                        context,
                        widget.attachments ?? [],
                        LMChatBubbleMedia(
                          audioHandler: widget.audioHandler,
                          conversation: conversation,
                          attachments: widget.attachments ?? [],
                          count: conversation.attachments?.length ?? 0,
                          attachmentUploaded:
                              conversation.attachmentsUploaded ?? false,
                          onVoiceNoteDurationUpdate: kAttachmentTypeVoiceNote ==
                                  widget.attachments?.first.type
                              ? _handleVoiceNoteDurationUpdate
                              : null,
                        ),
                      ) ??
                      LMChatBubbleMedia(
                        audioHandler: widget.audioHandler,
                        conversation: conversation,
                        attachments: widget.attachments ?? [],
                        count: conversation.attachments?.length ?? 0,
                        attachmentUploaded:
                            conversation.attachmentsUploaded ?? false,
                        onVoiceNoteDurationUpdate: kAttachmentTypeVoiceNote ==
                                widget.attachments?.first.type
                            ? _handleVoiceNoteDurationUpdate
                            : null,
                      )
                  : const SizedBox.shrink(),
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
                          conversation: widget.attachments?.first.type == "gif"
                              ? conversation.copyWith(answer: _getGIFText())
                              : conversation,
                          onTagTap: widget.onTagTap,
                          style: theme.contentStyle,
                        ),
                      ) ??
                      LMChatBubbleContent(
                        conversation: widget.attachments?.first.type == "gif"
                            ? conversation.copyWith(answer: _getGIFText())
                            : conversation,
                        onTagTap: widget.onTagTap,
                        style: theme.contentStyle,
                      ),
          if (conversation.deletedByUserId == null &&
              inStyle.showFooter == true)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: kAttachmentTypeVoiceNote == widget.attachments?.first.type
                  ? ValueListenableBuilder<Duration>(
                      valueListenable: _voiceNoteDurationNotifier,
                      builder: (context, duration, _) {
                        final footerWidget = LMChatBubbleFooter(
                          conversation: conversation,
                          textWidth: finalWidth,
                          voiceDuration: LMChatText(
                            formatDuration(duration.inSeconds),
                            style: LMChatTextStyle(
                              textStyle: TextStyle(
                                fontSize: 12,
                                color: LMChatTheme.theme.onContainer
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
    );
  }

  LMChatBubbleReply _defReplyWidget() {
    return LMChatBubbleReply(
      onTap: widget.onReplyTap,
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
    if (conversation.state == 10) return size.width;

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
      return size.width * 0.65; // Full width if media or reply is present
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
    // If duration is 0, reset to initial duration from metadata
    if (duration.inSeconds == 0) {
      final initialDuration = Duration(
        seconds: int.tryParse(
              widget.attachments?.first.meta?["duration"]?.toString() ?? "0",
            ) ??
            0,
      );
      _voiceNoteDurationNotifier.value = initialDuration;
    } else {
      _voiceNoteDurationNotifier.value = duration;
    }
  }

  LMChatProfilePicture? _defAvatar(bool toShowAvatar) {
    if (toShowAvatar) return widget.avatar;
    return null;
  }
}

/// {@template lm_chat_bubble_style}
/// Style configuration for the chat bubble.
/// {@endtemplate}
class LMChatBubbleStyle {
  /// The background color of the chat bubble.
  /// It will be ignored if BoxDecoration is applied.
  final Color? backgroundColor;

  /// The decoration of the chat bubble.
  /// If set, the background color will be ignored.
  /// when using a decoration, make sure to set enableClipper to false.
  /// to get the desired shape.
  final BoxDecoration? decoration;

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

  /// The style of the link preview.
  final LMChatLinkPreviewStyle? linkPreviewStyle;

  /// Whether to enable clipper, it is enabled by default.
  /// The clipper will clip the chat bubble to the def
  /// If set to false, the clipper will be disabled and the box decoration will be applied.
  /// If set to true, the clipper will be enabled and the box decoration will not be applied.
  final bool enableClipper;

  /// The custom clipper for the chat bubble.
  /// to create a custom shape for the chat bubble.
  /// If set, the default clipper will be ignored.
  final CustomClipper<Path>? clipper;

  /// The gap between the chat bubble and the user avatar.
  /// This is only applicable when the avatar is shown.
  final double gap;

  /// {@macro lm_chat_bubble_style}
  LMChatBubbleStyle({
    this.backgroundColor,
    this.decoration,
    this.selectedColor,
    this.showActions,
    this.showAvatar,
    this.showFooter,
    this.showHeader,
    this.showSides,
    this.linkPreviewStyle,
    this.enableClipper = true,
    this.clipper,
    this.gap = 0,
  });

  /// Creates a copy of the current style with optional new values.
  /// If the new values are null, the old values are used.
  LMChatBubbleStyle copyWith({
    Color? backgroundColor,
    BoxDecoration? decoration,
    Color? selectedColor,
    bool? showActions,
    bool? showAvatar,
    bool? showFooter,
    bool? showHeader,
    bool? showSides,
    LMChatLinkPreviewStyle? linkPreviewStyle,
    bool? enableClipper,
    CustomClipper<Path>? clipper,
    double? gap,
  }) {
    return LMChatBubbleStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      decoration: decoration ?? this.decoration,
      selectedColor: selectedColor ?? this.selectedColor,
      showActions: showActions ?? this.showActions,
      showAvatar: showAvatar ?? this.showAvatar,
      showFooter: showFooter ?? this.showFooter,
      showHeader: showHeader ?? this.showHeader,
      showSides: showSides ?? this.showSides,
      linkPreviewStyle: linkPreviewStyle ?? this.linkPreviewStyle,
      enableClipper: enableClipper ?? this.enableClipper,
      clipper: clipper ?? this.clipper,
      gap: gap ?? this.gap,
    );
  }

  /// Creates a basic style with default values.
  factory LMChatBubbleStyle.basic() {
    return LMChatBubbleStyle(
      backgroundColor: LMChatTheme.isThemeDark
          ? LMChatDefaultDarkTheme.container.withAlpha(255)
          : LMChatDefaultTheme.container,
      selectedColor: const Color.fromRGBO(0, 96, 86, 0.3),
      showSides: true,
      showActions: true,
      showAvatar: true,
      showFooter: true,
      showHeader: true,
    );
  }
}
