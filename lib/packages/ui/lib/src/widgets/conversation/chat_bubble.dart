import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
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
  final Conversation conversation;
  final User currentUser;
  final User conversationUser;
  final LMChatIcon? replyIcon;
  final LMChatProfilePicture? avatar;
  final Function(Conversation)? onReply;
  final Function(String tag) onTagTap;
  final bool? isSent;

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
  });

  @override
  State<LMChatBubble> createState() => _LMChatBubbleState();
}

class _LMChatBubbleState extends State<LMChatBubble> {
  bool isSent = false;
  late Conversation conversation;
  late User currentUser;
  late User conversationUser;

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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const LMChatBubbleHeader(),
                            conversation.deletedByUserId != null
                                ? LMChatText(
                                    "Deleted message",
                                    style: LMChatTextStyle(
                                      textStyle:
                                          conversation.deletedByUserId != null
                                              ? const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                )
                                              : const TextStyle(
                                                  fontSize: 14,
                                                ),
                                    ),
                                  )
                                : LMChatBubbleContent(
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
  final Color? background;

  LMChatBubbleStyle({this.background});
}

// // // lm_chat_bubble.dart
// // import 'package:flutter/material.dart';
// // import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
// // import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
// // import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
// // import 'package:likeminds_chat_flutter_ui/src/widgets/profile/profile_picture.dart';
// // import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
// // import 'package:swipe_to_action/swipe_to_action.dart';

// // // part 'chat_bubble_components.dart';

// // /// {@template lm_chat_bubble}
// // /// A widget that displays a chat bubble in a conversation.
// // ///
// // /// This widget provides a customizable chat bubble with various components
// // /// such as header, content, footer, media, and reactions.
// // ///
// // /// It also supports features like replying, editing, and long-pressing.
// // /// {@endtemplate}
// // class LMChatBubble extends StatefulWidget {
// //   /// {@macro lm_chat_bubble}
// //   const LMChatBubble({
// //     super.key,
// //     required this.conversation,
// //     required this.sender,
// //     required this.currentUser,
// //     // this.style,
// //     this.replyingTo,
// //     this.onReply,
// //     this.onEdit,
// //     this.onLongPress,
// //     // this.headerBuilder,
// //     // this.contentBuilder,
// //     // this.footerBuilder,
// //     // this.mediaBuilder,
// //     // this.reactionBuilder,
// //   });

// //   final Conversation conversation;
// //   final Conversation? replyingTo;
// //   final User sender;
// //   final User currentUser;
// //   // final LMChatBubbleStyle? style;

// //   final Function(Conversation replyingTo)? onReply;
// //   final Function(Conversation editConversation)? onEdit;
// //   final Function(Conversation conversation)? onLongPress;

// //   // final LMChatBubbleHeaderBuilder? headerBuilder;
// //   // final LMChatBubbleContentBuilder? contentBuilder;
// //   // final LMChatBubbleFooterBuilder? footerBuilder;
// //   // final LMChatBubbleMediaBuilder? mediaBuilder;
// //   // final LMChatBubbleReactionBuilder? reactionBuilder;

// //   @override
// //   State<LMChatBubble> createState() => _LMChatBubbleState();
// // }

// // class _LMChatBubbleState extends State<LMChatBubble> {
// //   late bool isSent;
// //   late bool isDeleted;
// //   late bool isEdited;

// //   @override
// //   void initState() {
// //     super.initState();
// //     isSent = widget.conversation.userId == widget.currentUser.id;
// //     isDeleted = widget.conversation.deletedByUserId != null;
// //     isEdited = widget.conversation.isEdited ?? false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder(
// //       color: Colors.red,
// //     );
// //     //     dismissThresholds: const {SwipeDirection.startToEnd: 0.2},
// //     //     movementDuration: const Duration(milliseconds: 50),
// //     //     key: ValueKey(widget.conversation.id),
// //     //     onSwipe: (direction) {
// //     //       if (widget.onReply != null) {
// //     //         widget.onReply!(widget.replyingTo ?? widget.conversation);
// //     //       }
// //     //     },
// //     //     background: LMChatSwipeBackground(
// //     //       onReply: widget.onReply,
// //     //       replyingTo: widget.replyingTo,
// //     //       conversation: widget.conversation,
// //     //     ),
// //     //     direction: SwipeDirection.startToEnd,
// //     //     child: LMChatBubbleContent(
// //     //       conversation: widget.conversation,
// //     //       sender: widget.sender,
// //     //       currentUser: widget.currentUser,
// //     //       isSent: isSent,
// //     //       isDeleted: isDeleted,
// //     //       isEdited: isEdited,
// //     //       replyingTo: widget.replyingTo,
// //     //       style: widget.style,
// //     //       headerBuilder: widget.headerBuilder,
// //     //       contentBuilder: widget.contentBuilder,
// //     //       footerBuilder: widget.footerBuilder,
// //     //       mediaBuilder: widget.mediaBuilder,
// //     //       reactionBuilder: widget.reactionBuilder,
// //     //       onEdit: widget.onEdit,
// //     //       onLongPress: widget.onLongPress,
// //     //     ),
// //     //   );
// //     // }
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
// import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
// import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
// import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
// import 'package:swipe_to_action/swipe_to_action.dart';

// class LMChatBubble extends StatefulWidget {
//   const LMChatBubble({
//     super.key,
//     required this.conversation,
//     required this.sender,
//     required this.currentUser,
//     this.title,
//     this.content,
//     this.footer,
//     this.avatar,
//     this.replyingTo,
//     this.replyIcon,
//     this.reactionButton,
//     this.outsideTitle,
//     this.outsideFooter,
//     this.menuBuilder,
//     this.onReply,
//     this.onEdit,
//     this.onLongPress,
//     this.width,
//     this.height,
//     this.borderWidth,
//     this.borderRadius,
//     this.borderRadiusNum,
//     this.borderColor,
//     this.backgroundColor,
//     this.sentColor,
//     this.isSent,
//     this.showActions,
//     this.replyItem,
//     this.mediaWidget,
//     this.deletedText,
//   });

//   final Conversation conversation;
//   final Conversation? replyingTo;
//   final User sender;
//   final User currentUser;

//   final LMChatText? title;
//   final LMChatContent? content;
//   final List<LMChatText>? footer;
//   final LMChatProfilePicture? avatar;
//   final LMChatIcon? replyIcon;
//   final LMChatIconButton? reactionButton;
//   final LMReplyItem? replyItem;
//   final LMChatText? outsideTitle;
//   final Widget? outsideFooter;
//   final Widget? mediaWidget;
//   final LMMenu Function(Widget child)? menuBuilder;
//   final Function(Conversation replyingTo)? onReply;
//   final Function(Conversation editConversation)? onEdit;
//   final Function(Conversation conversation)? onLongPress;

//   final double? width;
//   final double? height;
//   final double? borderWidth;
//   final double? borderRadiusNum;

//   final BorderRadius? borderRadius;

//   final Color? borderColor;
//   final Color? backgroundColor;
//   final Color? sentColor;

//   final bool? isSent;
//   final bool? showActions;

//   final LMChatText? deletedText;

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
