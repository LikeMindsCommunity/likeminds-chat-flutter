part of 'chat_bubble.dart';

class LMChatBubbleMedia extends StatelessWidget {
  final List<LMChatAttachmentViewData> attachments;
  final int count;
  final bool attachmentUploaded;
  final LMChatConversationViewData conversation;

  const LMChatBubbleMedia({
    super.key,
    required this.conversation,
    required this.attachments,
    required this.count,
    required this.attachmentUploaded,
  });

  @override
  Widget build(BuildContext context) {
    return count > 0
        ? getContent(context) ?? const SizedBox.shrink()
        : const SizedBox.shrink();
  }

  Widget? getContent(BuildContext context) {
    // If conversation has media but not uploaded yet
    // show local files
    Widget? mediaWidget;
    if (attachmentUploaded && count > 0) {
      Widget? mediaWidget;
      if (attachments.first.type ==
              mapMediaTypeToString(LMChatMediaType.image) ||
          attachments.first.type ==
              mapMediaTypeToString(LMChatMediaType.video)) {
        mediaWidget = _defaultMediaWidget(context);
      } else if (attachments.first.type ==
          mapMediaTypeToString(LMChatMediaType.document)) {
        mediaWidget = const SizedBox.shrink();
      } else if (conversation.ogTags != null) {
        mediaWidget = const SizedBox.shrink();
      } else {
        mediaWidget = null;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          mediaWidget ?? const SizedBox.shrink(),
          conversation.answer.isEmpty
              ? const SizedBox.shrink()
              : kVerticalPaddingSmall,
        ],
      );
    }
    return null;
  }

  Widget _defaultMediaWidget(BuildContext context) {
    return getImageMessage(context, attachments);
  }
}
