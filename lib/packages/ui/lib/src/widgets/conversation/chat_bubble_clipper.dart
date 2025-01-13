import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

// import '../bubble_type.dart';

/// This class is a sample of a custom clipper that creates a visually
/// appealing chat bubble.
///
/// The chat bubble is shaped as shown in the following illustration:
class LMChatBubbleClipper extends CustomClipper<Path> {
  ///The values assigned to the clipper types [BubbleType.sendBubble] and
  ///[BubbleType.receiverBubble] are distinct.
  final bool isSent;

  ///The radius, which creates the curved appearance of the chat widget,
  ///has a default value of 10.
  final double radius;

  /// The "nip" creates the curved shape of the chat widget
  /// and has a default nipHeight of 10.
  final double nipHeight;

  /// The "nip" creates the curved shape of the chat widget
  /// and has a default nipWidth of 15.
  final double nipWidth;

  /// The "nip" creates the curved shape of the chat widget
  /// and has a default nipRadius of 3.
  final double nipRadius;

  final LMChatConversationViewType conversationViewType;

  LMChatBubbleClipper({
    this.isSent = true,
    this.radius = 10,
    this.nipHeight = 10,
    this.nipWidth = 10,
    this.nipRadius = 3,
    required this.conversationViewType,
  });

  @override
  Path getClip(Size size) {
    var path = Path();

    if (isSent) {
      if (conversationViewType == LMChatConversationViewType.bottom) {
        path.lineTo(size.width - nipWidth - radius, 0);
        path.arcToPoint(Offset(size.width - nipWidth, radius),
            radius: Radius.circular(radius));
        path.lineTo(size.width - nipWidth, size.height - radius);
        path.arcToPoint(Offset(size.width - nipWidth - radius, size.height),
            radius: Radius.circular(radius));
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: Radius.circular(radius));
        path.lineTo(0, radius);
        path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      } else {
        path.lineTo(size.width - radius - nipWidth - radius / 2, 0);
        path.arcToPoint(
            Offset(size.width - nipWidth - radius / 2, nipHeight / 2),
            radius: Radius.circular(radius));
        path.arcToPoint(Offset(size.width, 0),
            radius: const Radius.circular(30));
        path.arcToPoint(Offset(size.width - nipWidth, nipHeight + radius),
            radius: const Radius.circular(30), clockwise: false);
        path.lineTo(size.width - nipWidth, size.height - radius);
        path.arcToPoint(Offset(size.width - nipWidth - radius, size.height),
            radius: Radius.circular(radius));
        path.lineTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height - radius),
            radius: Radius.circular(radius));
        path.lineTo(0, radius);
        path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      }
    } else {
      if (conversationViewType == LMChatConversationViewType.bottom) {
        path.moveTo(nipWidth + radius, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: Radius.circular(radius));
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: Radius.circular(radius));
        path.lineTo(radius + nipWidth, size.height);
        path.arcToPoint(Offset(nipWidth, size.height - radius),
            radius: Radius.circular(radius));
        path.lineTo(nipWidth, radius);
        path.arcToPoint(Offset(radius + nipWidth, 0),
            radius: Radius.circular(radius));
      } else {
        path.arcToPoint(Offset(nipWidth + radius / 2, nipHeight / 2),
            radius: Radius.circular(30));
        path.arcToPoint(Offset(nipWidth + radius + radius / 2, 0),
            radius: Radius.circular(radius));
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: Radius.circular(radius));
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: Radius.circular(radius));
        path.lineTo(nipWidth + radius, size.height);
        path.arcToPoint(Offset(nipWidth, size.height - radius),
            radius: Radius.circular(radius));
        path.lineTo(nipWidth, nipHeight + radius);
        path.arcToPoint(Offset(0, 0),
            radius: Radius.circular(30), clockwise: false);
      }
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}