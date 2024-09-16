part of 'chat_bubble.dart';

class LMChatBubbleMedia extends StatelessWidget {
  final List<LMChatAttachmentViewData> attachments;
  final int count;
  final bool attachmentUploaded;
  final LMChatConversationViewData conversation;

  final LMChatImageBuilder? imageBuilder;
  final LMChatVideoBuilder? videoBuilder;
  final LMChatGIFBuilder? gifBuilder;

  final LMChatDocumentThumbnailBuilder? documentThumbnailBuilder;
  final LMChatDocumentTilePreviewBuilder? documentTilePreviewBuilder;

  const LMChatBubbleMedia({
    super.key,
    required this.conversation,
    required this.attachments,
    required this.count,
    required this.attachmentUploaded,
    this.imageBuilder,
    this.videoBuilder,
    this.gifBuilder,
    this.documentThumbnailBuilder,
    this.documentTilePreviewBuilder,
  });

  LMChatBubbleMedia copyWith({
    List<LMChatAttachmentViewData>? attachments,
    int? count,
    bool? attachmentUploaded,
    LMChatConversationViewData? conversation,
    LMChatImageBuilder? imageBuilder,
    LMChatVideoBuilder? videoBuilder,
    LMChatGIFBuilder? gifBuilder,
    LMChatDocumentThumbnailBuilder? documentThumbnailBuilder,
    LMChatDocumentTilePreviewBuilder? documentTilePreviewBuilder,
  }) {
    return LMChatBubbleMedia(
      conversation: conversation ?? this.conversation,
      attachments: attachments ?? this.attachments,
      count: count ?? this.count,
      attachmentUploaded: attachmentUploaded ?? this.attachmentUploaded,
      imageBuilder: imageBuilder ?? this.imageBuilder,
      videoBuilder: videoBuilder ?? this.videoBuilder,
      gifBuilder: gifBuilder ?? this.gifBuilder,
      documentThumbnailBuilder:
          documentThumbnailBuilder ?? this.documentThumbnailBuilder,
      documentTilePreviewBuilder:
          documentTilePreviewBuilder ?? this.documentTilePreviewBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return count > 0
        ? Column(
            children: [
              const SizedBox(height: 4),
              getContent(context) ?? const SizedBox.shrink(),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget? getContent(BuildContext context) {
    // If conversation has media but not uploaded yet
    // show local files
    Widget? mediaWidget;
    if (count > 0 &&
        conversation.deletedByUserId == null &&
        attachments.isNotEmpty) {
      if (attachments.first.type ==
              mapMediaTypeToString(LMChatMediaType.image) ||
          attachments.first.type ==
              mapMediaTypeToString(LMChatMediaType.video)) {
        mediaWidget = _defaultMediaWidget(context);
      } else if (attachments.first.type ==
          mapMediaTypeToString(LMChatMediaType.document)) {
        switch (attachments.length) {
          case 1:
            mediaWidget = LMChatDocumentThumbnail(
              media: attachments.first.toMediaModel(),
              style: LMChatDocumentThumbnailStyle(height: 140, width: 55.w),
              showOverlay: true,
            );
          default:
            mediaWidget = LMChatDocumentTilePreview(
              mediaList: attachments.map((e) => e.toMediaModel()).toList(),
              style: LMChatDocumentTilePreviewStyle(
                tileStyle: LMChatDocumentTileStyle(
                  width: 55.w,
                ),
              ),
            );
        }
      } else if (conversation.ogTags != null) {
        mediaWidget = const SizedBox.shrink();
      } else if (attachments.first.type ==
          mapMediaTypeToString(LMChatMediaType.gif)) {
        mediaWidget = LMChatGIF(media: attachments.first.toMediaModel());
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
    if (attachments.first.attachmentFile != null) {
      return getImageFileMessage(context, attachments, imageBuilder);
    }
    return getImageMessage(context, attachments, imageBuilder);
  }
}
