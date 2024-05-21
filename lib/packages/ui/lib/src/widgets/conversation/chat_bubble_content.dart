// import 'package:flutter/material.dart';
// import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

part of 'chat_bubble.dart';

typedef LMChatBubbleContentBuilder = Widget Function(Conversation conversation);

class LMChatBubbleContent extends StatelessWidget {
  const LMChatBubbleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// class LMChatContent extends StatelessWidget {
//   const LMChatContent({
//     super.key,
//     required this.conversation,
//     this.visibleLines,
//     this.textStyle,
//     this.linkStyle,
//     this.tagStyle,
//     this.animation,
//   });

//   final Conversation conversation;

//   final int? visibleLines;
//   final TextStyle? textStyle;
//   final TextStyle? linkStyle;
//   final TextStyle? tagStyle;
//   final bool? animation;

//   @override
//   Widget build(BuildContext context) {
//     return conversation.answer.isNotEmpty
//         ? LMChatExpandableText(
//             conversation.answer,
//             expandText: "",
//             animation: animation ?? true,
//             maxLines: visibleLines ?? 4,
//             mentionStyle: tagStyle,
//             linkStyle: linkStyle ??
//                 const TextStyle(
//                   color: kLinkColor,
//                   fontSize: 14,
//                 ),
//             textAlign: TextAlign.left,
//             style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
//             linkEllipsis: true,
//           )
//         : const SizedBox();
//   }
// }
