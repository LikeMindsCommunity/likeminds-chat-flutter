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

    //   if (mediaFiles[conversation.temporaryId] == null ||
    //       mediaFiles[conversation.temporaryId]!.isEmpty) {
    //     // return expandableText;
    //     if (conversation.ogTags != null) {
    //       return Container();
    //     } else {
    //       return null;
    //     }
    //   }
    //   if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
    //           LMChatMediaType.image ||
    //       mediaFiles[conversation.temporaryId]!.first.mediaType ==
    //           LMChatMediaType.video) {
    //     mediaWidget =
    //         getImageFileMessage(context, mediaFiles[conversation.temporaryId]!);
    //   } else if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
    //       LMChatMediaType.document) {
    //     mediaWidget =
    //         documentPreviewFactory(mediaFiles[conversation.temporaryId]!);
    //   } else if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
    //       LMChatMediaType.link) {
    //     mediaWidget = LMLinkPreview(
    //         onTap: () {
    //           launchUrl(
    //             Uri.parse(
    //                 mediaFiles[conversation.temporaryId]!.first.ogTags?.url ??
    //                     ''),
    //             mode: LaunchMode.externalApplication,
    //           );
    //         },
    //         linkModel: MediaModel(
    //             mediaType: LMLMChatMediaType.link,
    //             ogTags: mediaFiles[conversation.temporaryId]!.first.ogTags));
    //   } else {
    //     mediaWidget = null;
    //   }
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Stack(
    //         children: [
    //           mediaWidget ?? const SizedBox.shrink(),
    //           const Positioned(
    //             top: 0,
    //             bottom: 0,
    //             left: 0,
    //             right: 0,
    //             child: LMChatLoader(),
    //           )
    //         ],
    //       ),
    //       conversation.answer.isEmpty
    //           ? const SizedBox.shrink()
    //           : kVerticalPaddingXSmall,
    //     ],
    //   );
    // } else
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
