import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/conversation/chat_bubble_clipper.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

part 'chat_bubble_content.dart';
part 'chat_bubble_footer.dart';
part 'chat_bubble_header.dart';
part 'chat_bubble_media.dart';
part 'chat_bubble_reply.dart';
part 'chat_bubble_sides.dart';
part 'chat_bubble_state.dart';

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

  /// The content builder.
  final LMChatBubbleContentBuilder? contentBuilder;

  /// The style of the bubble.
  final LMChatBubbleStyle? style;

  /// The selected state of the bubble.
  final bool isSelected;

  final Function(bool isSelected, State<LMChatBubble> state)? onTap;

  final Function(bool isSelected, State<LMChatBubble> state)? onLongPress;

  final bool Function()? isSelectableOnTap;

  /// The [LMChatBubble] widget constructor.
  /// used to display the chat bubble.
  const LMChatBubble({
    super.key,
    required this.conversation,
    required this.currentUser,
    required this.conversationUser,
    required this.onTagTap,
    this.style,
    this.contentBuilder,
    this.onReply,
    this.replyIcon,
    this.avatar,
    this.isSent,
    this.deletedText,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.isSelectableOnTap,
  });

  @override
  State<LMChatBubble> createState() => _LMChatBubbleState();
}

class _LMChatBubbleState extends State<LMChatBubble> {
  bool isSent = false;
  late LMChatConversationViewData conversation;
  late LMChatUserViewData currentUser;
  late LMChatUserViewData conversationUser;
  bool _isSelected = false;
  bool _isDeleted = false;
  final LMChatThemeData theme = LMChatTheme.theme;

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    currentUser = widget.currentUser;
    conversationUser = widget.conversationUser;
    isSent = currentUser.id == conversationUser.id;
    _isSelected = widget.isSelected;
    _isDeleted = conversation.deletedByUserId != null;
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
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = widget.style ?? LMChatTheme.theme.bubbleStyle;
    return Swipeable(
      dismissThresholds: const {SwipeDirection.startToEnd: 0.0},
      movementDuration: const Duration(milliseconds: 50),
      key: GlobalObjectKey(conversation.id),
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
      child: GestureDetector(
        onLongPress: () {
          if (_isDeleted) return;
          _isSelected = !_isSelected;
          widget.onLongPress?.call(_isSelected, this);
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
        child: Container(
          foregroundDecoration: BoxDecoration(
            color: _isSelected ? const Color.fromRGBO(0, 96, 86, 0.3) : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
          child: Row(
            mainAxisAlignment:
                isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSent) widget.avatar ?? const SizedBox(),
              const SizedBox(width: 6),
              AbsorbPointer(
                absorbing: conversation.deletedByUserId != null,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 2.h,
                    minWidth:
                        conversation.answer.split('\n').length > 4 ? 40.w : 5.w,
                    maxWidth: 60.w,
                  ),
                  child: PhysicalShape(
                    clipper: LMChatBubbleClipper(
                      isSent: isSent,
                    ),
                    color: inStyle.backgroundColor ?? theme.container,
                    child: Padding(
                      padding: isSent
                          ? EdgeInsets.only(
                              top: 1.h,
                              bottom: 1.h,
                              left: 2.w,
                              right: 4.w,
                            )
                          : EdgeInsets.only(
                              top: 1.h,
                              bottom: 1.h,
                              left: 4.w,
                              right: 2.w,
                            ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (inStyle.showHeader ?? true)
                            LMChatBubbleHeader(
                              conversationUser: widget.conversationUser,
                            ),
                          if (conversation.replyConversationObject != null &&
                              conversation.deletedByUserId == null)
                            LMChatBubbleReply(
                              replyToConversation:
                                  conversation.replyConversationObject!,
                              title: LMChatText(
                                currentUser.id ==
                                        conversation
                                            .replyConversationObject!.memberId
                                    ? "You"
                                    : conversation
                                        .replyConversationObject!.member!.name,
                                style: LMChatTextStyle(
                                  maxLines: 1,
                                  textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: theme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          conversation.deletedByUserId != null
                              ? widget.deletedText ??
                                  LMChatText(
                                    _getDeletedText(),
                                    style: LMChatTextStyle(
                                      textStyle:
                                          conversation.deletedByUserId != null
                                              ? TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: LMChatTheme
                                                      .theme.disabledColor,
                                                )
                                              : TextStyle(
                                                  fontSize: 14,
                                                  color: LMChatTheme
                                                      .theme.disabledColor,
                                                ),
                                    ),
                                  )
                              : widget.contentBuilder?.call(conversation) ??
                                  LMChatBubbleContent(
                                    conversation: conversation,
                                    onTagTap: widget.onTagTap,
                                  ),
                          const LMChatBubbleMedia(),
                          if (conversation.deletedByUserId == null &&
                              inStyle.showFooter == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: LMChatBubbleFooter(
                                conversation: conversation,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              if (isSent) widget.avatar ?? const SizedBox(),
            ],
          ),
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
}

class LMChatBubbleStyle {
  final double? width;
  final double? height;
  final double? borderWidth;
  final double? borderRadiusNum;
  final BorderRadius? borderRadius;

  final Color? borderColor;
  final Color? backgroundColor;
  final Color? sentColor;

  final bool? showActions;
  final bool? showHeader;
  final bool? showFooter;
  final bool? showSides;
  final bool? showAvatar;

  LMChatBubbleStyle({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderRadiusNum,
    this.borderWidth,
    this.height,
    this.sentColor,
    this.showActions,
    this.width,
    this.showAvatar,
    this.showFooter,
    this.showHeader,
    this.showSides,
  });

  LMChatBubbleStyle copyWith({
    double? width,
    double? height,
    double? borderWidth,
    double? borderRadiusNum,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    Color? sentColor,
    bool? showActions,
    bool? showSides,
    bool? showAvatar,
    bool? showHeader,
    bool? showFooter,
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
      showActions: showActions ?? this.showActions,
      showAvatar: showAvatar ?? this.showAvatar,
      showFooter: showFooter ?? this.showFooter,
      showHeader: showHeader ?? this.showHeader,
      showSides: showSides ?? this.showSides,
    );
  }

  factory LMChatBubbleStyle.basic() {
    return LMChatBubbleStyle(
      backgroundColor: LMChatDefaultTheme.container,
      showSides: true,
      showActions: true,
      showAvatar: true,
      showFooter: true,
      showHeader: true,
    );
  }
}
