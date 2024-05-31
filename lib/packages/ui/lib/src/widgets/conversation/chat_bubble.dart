import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

part 'chat_bubble_content.dart';
part 'chat_bubble_footer.dart';
part 'chat_bubble_header.dart';
part 'chat_bubble_media.dart';
part 'chat_bubble_reply.dart';
part 'chat_bubble_sides.dart';
part 'chat_bubble_state.dart';

class LMChatBubble extends StatefulWidget {
  final LMChatConversationViewData conversation;
  final LMChatUserViewData currentUser;
  final LMChatUserViewData conversationUser;

  final bool? isSent;
  final LMChatIcon? replyIcon;
  final LMChatProfilePicture? avatar;
  final Function(LMChatConversationViewData)? onReply;
  final Function(String tag) onTagTap;

  final LMChatText? deletedText;
  final LMChatBubbleContentBuilder? contentBuilder;
  final LMChatBubbleStyle? style;

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
  });

  @override
  State<LMChatBubble> createState() => _LMChatBubbleState();
}

class _LMChatBubbleState extends State<LMChatBubble> {
  bool isSent = false;
  late LMChatConversationViewData conversation;
  late LMChatUserViewData currentUser;
  late LMChatUserViewData conversationUser;

  @override
  void initState() {
    conversation = widget.conversation;
    currentUser = widget.currentUser;
    conversationUser = widget.conversationUser;
    isSent = currentUser.id == conversationUser.id;
    super.initState();
  }

  @override
  void didUpdateWidget(LMChatBubble old) {
    conversation = widget.conversation;
    currentUser = widget.currentUser;
    conversationUser = widget.conversationUser;
    isSent = currentUser.id == conversationUser.id;
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = widget.style ?? LMChatTheme.theme.bubbleStyle;
    return Swipeable(
      dismissThresholds: const {SwipeDirection.startToEnd: 0.2},
      movementDuration: const Duration(milliseconds: 50),
      key: ValueKey(conversation.id),
      onSwipe: (direction) {
        // if (widget.onReply != null) {
        //   widget.onReply!(conversation!);
        // }
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
                    boxPadding: 0,
                  ),
                ),
          ],
        ),
      ),
      direction: SwipeDirection.startToEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: widget.avatar != null ? 48.0 : 18.0,
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.6.h,
                ),
                child: Row(
                  mainAxisAlignment:
                      isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !isSent
                        ? widget.avatar ?? const SizedBox()
                        : const SizedBox(),
                    const SizedBox(width: 4),
                    AbsorbPointer(
                      absorbing: conversation.deletedByUserId != null,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 2.h,
                          minWidth: 5.w,
                          maxWidth: 50.w,
                        ),
                        padding: EdgeInsets.all(
                          conversation.attachmentCount != 0 ? 8.0 : 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: inStyle.backgroundColor ??
                              LMChatTheme.theme.container,
                          borderRadius: inStyle.borderRadius ??
                              BorderRadius.circular(
                                inStyle.borderRadiusNum ?? 6,
                              ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const LMChatBubbleHeader(),
                            conversation.deletedByUserId != null
                                ? widget.deletedText ??
                                    LMChatText(
                                      "Deleted message",
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
                            IntrinsicWidth(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: LMChatBubbleFooter(
                                  conversation: conversation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    isSent
                        ? widget.avatar ?? const SizedBox()
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // );
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
    );
  }

  factory LMChatBubbleStyle.basic() {
    return LMChatBubbleStyle(
      backgroundColor: LMChatDefaultTheme.container,
      borderRadiusNum: 16,
    );
  }
}



//   @override
//   State<LMChatBubble> createState() => _LMChatBubbleState();
// }

// class _LMChatBubbleState extends State<LMChatBubble> {
//   Conversation? conversation;
//   Conversation? replyingTo;
//   User? sender;
//   User? currentUser;
//   bool isSent = false;
//   bool isDeleted = false;
//   bool isEdited = false;

//   @override
//   void initState() {
//     super.initState();
//     isSent = widget.isSent ?? false;
//     conversation = widget.conversation;
//     sender = widget.sender;
//     currentUser = widget.currentUser;
//     replyingTo = widget.replyingTo;
//     isEdited = widget.conversation.isEdited ?? false;
//     isDeleted = widget.conversation.deletedByUserId != null;
//   }

//   @override
//   void didUpdateWidget(LMChatBubble oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     setState(() {
//       conversation = widget.conversation;
//       sender = widget.sender;
//       replyingTo = widget.replyingTo;
//       currentUser = widget.currentUser;
//       isEdited = widget.conversation.isEdited ?? false;
//       isDeleted = widget.conversation.deletedByUserId != null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Swipeable(
//       dismissThresholds: const {SwipeDirection.startToEnd: 0.2},
//       movementDuration: const Duration(milliseconds: 50),
//       key: ValueKey(conversation!.id),
//       onSwipe: (direction) {
//         if (widget.onReply != null) {
//           widget.onReply!(conversation!);
//         }
//       },
//       background: Padding(
//         padding: EdgeInsets.only(
//           left: 2.w,
//           right: 2.w,
//           top: 0.2.h,
//           bottom: 0.2.h,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             widget.replyIcon ??
//                 const LMChatIcon(
//                   type: LMChatIconType.icon,
//                   icon: Icons.reply_outlined,
//                   color: kLinkColor,
//                   size: 28,
//                   boxSize: 28,
//                   boxPadding: 0,
//                 ),
//           ],
//         ),
//       ),
//       direction: SwipeDirection.startToEnd,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Column(
//             crossAxisAlignment:
//                 isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: widget.outsideTitle != null ? 10 : 0),
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: widget.avatar != null ? 48.0 : 28.0,
//                 ),
//                 child: widget.outsideTitle ?? const SizedBox(),
//               ),
//               const SizedBox(height: 2),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 6,
//                 ),
//                 child: Row(
//                   mainAxisAlignment:
//                       isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     !isSent
//                         ? widget.avatar ?? const SizedBox()
//                         : const SizedBox(),
//                     const SizedBox(width: 4),
//                     AbsorbPointer(
//                       absorbing: isDeleted,
//                       child: widget.menuBuilder != null
//                           ? widget.menuBuilder!(chatBubbleContent())
//                           : chatBubbleContent(),
//                     ),
//                     const SizedBox(width: 4),
//                     isSent
//                         ? widget.avatar ?? const SizedBox()
//                         : const SizedBox(),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   right: widget.avatar != null ? 48.0 : 24.0,
//                   left: widget.avatar != null ? 48.0 : 28.0,
//                 ),
//                 child: widget.outsideFooter ?? const SizedBox.shrink(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     // );
//   }

//   Container chatBubbleContent() {
//     return Container(
//       constraints: BoxConstraints(
//         minHeight: 4.h,
//         minWidth: 10.w,
//         maxWidth: 60.w,
//       ),
//       padding: EdgeInsets.all(
//         widget.mediaWidget != null ? 8.0 : 12.0,
//       ),
//       decoration: BoxDecoration(
//         color: widget.backgroundColor ?? Colors.white,
//         borderRadius: widget.borderRadius ??
//             BorderRadius.circular(
//               widget.borderRadiusNum ?? 6,
//             ),
//       ),
//       child: Column(
//         crossAxisAlignment:
//             isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           widget.replyItem == null
//               ? replyingTo != null
//                   ? isDeleted
//                       ? const SizedBox.shrink()
//                       : LMReplyItem(
//                           replyToConversation: replyingTo!,
//                           backgroundColor: Colors.white,
//                           highlightColor: Theme.of(context).primaryColor,
//                           title: LMChatText(
//                             text: replyingTo!.member!.name,
//                             textStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           subtitle: LMChatText(
//                             text: replyingTo!.answer,
//                             textStyle: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         )
//                   : const SizedBox.shrink()
//               : isDeleted
//                   ? const SizedBox.shrink()
//                   : widget.replyItem!,
//           replyingTo != null
//               ? const SizedBox(height: 8)
//               : const SizedBox.shrink(),
//           isSent ? const SizedBox() : widget.title ?? const SizedBox.shrink(),
//           isDeleted
//               ? const SizedBox.shrink()
//               : ((widget.mediaWidget != null && widget.content != null) ||
//                       widget.conversation.hasFiles!)
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 0, horizontal: 0),
//                       child: widget.mediaWidget,
//                     )
//                   : const SizedBox(),
//           isDeleted
//               ? widget.deletedText != null
//                   ? widget.deletedText!
//                   : conversation!.deletedByUserId == conversation!.userId
//                       ? LMChatText(
//                           currentUser!.id == conversation!.deletedByUserId
//                               ? "You deleted this message"
//                               : "This message was deleted",
//                           style: LMChatTextStyle(
//                             textStyle: widget.content!.textStyle!.copyWith(
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         )
//                       : LMChatText(
//                           text:
//                               "This message was deleted by a community managers",
//                           textStyle: widget.content!.textStyle!.copyWith(
//                             fontStyle: FontStyle.italic,
//                           ),
//                         )
//               : replyingTo != null
//                   ? Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           top: widget.mediaWidget != null ? 4.0 : 0,
//                         ),
//                         child: widget.content ??
//                             LMChatContent(
//                               conversation: widget.conversation,
//                               linkStyle: TextStyle(
//                                 color: Theme.of(context).primaryColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textStyle: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                       ),
//                     )
//                   : widget.mediaWidget != null
//                       ? Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 top: widget.mediaWidget != null ? 4.0 : 0),
//                             child: widget.content ??
//                                 LMChatContent(
//                                   conversation: widget.conversation,
//                                   linkStyle: TextStyle(
//                                     color: Theme.of(context).primaryColor,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   textStyle: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   visibleLines: 4,
//                                   animation: true,
//                                 ),
//                           ),
//                         )
//                       : Padding(
//                           padding: EdgeInsets.only(
//                               top: widget.mediaWidget != null ? 4.0 : 0),
//                           child: widget.content ??
//                               LMChatContent(
//                                 conversation: widget.conversation,
//                                 linkStyle: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 textStyle: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 visibleLines: 4,
//                                 animation: true,
//                               ),
//                         ),
//           if (widget.footer != null && widget.footer!.isNotEmpty && !isDeleted)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: widget.footer!,
//             ),
//           ((widget.conversation.hasFiles == null ||
//                       !widget.conversation.hasFiles!) ||
//                   (widget.conversation.attachmentsUploaded != null &&
//                       widget.conversation.attachmentsUploaded!) ||
//                   isDeleted)
//               ? const SizedBox()
//               : const LMChatIcon(
//                   type: LMChatIconType.icon,
//                   icon: Icons.timer_outlined,
//                   style: LMChatIconStyle(
//                     size: 12,
//                     boxSize: 18,
//                     boxPadding: 6,
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
