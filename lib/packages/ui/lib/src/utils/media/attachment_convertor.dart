import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [MediaConvertor] is an extension on [LMChatAttachmentViewData] class.
/// It converts [LMChatAttachmentViewData] to [LMChatMediaModel].
extension MediaConvertor on LMChatAttachmentViewData {
  /// Converts [LMChatAttachmentViewData] to [LMChatMediaModel]
  LMChatMediaModel toMediaModel() {
    return LMChatMediaModel(
      mediaType: mapStringToMediaType(type!),
      mediaUrl: url ?? fileUrl,
      mediaFile: attachmentFile,
      thumbnailUrl: thumbnailUrl,
      thumbnailFile: thumbnailFile,
      meta: meta,
      height: height,
      width: width,
    );
  }
}

// /// [MediaConvertor] is an extension on [LMChatAttachmentViewData] class.
// /// It converts [LMChatAttachmentViewData] to [LMChatMediaModel].
// extension ViewDataConvertor on LMChatMediaModel {
//   /// Converts [LMChatAttachmentViewData] to [LMChatMediaModel]
//   LMChatAttachmentViewData toAttachmentViewData() {
//     final LMChatAttachmentViewDataBuilder attachmentBuilder =
//         LMChatAttachmentViewDataBuilder()
//           ..attachmentFile(mediaFile)
//           ..fileUrl(mediaUrl)
//           ..height(height)
//           ..width(width)
//           ..meta(meta)
//           ..thumbnailFile(thumbnailFile)
//           ..thumbnailUrl(thumbnailUrl)
//           ..type(mapMediaTypeToString(mediaType))
//           ..url(mediaUrl);

//     return attachmentBuilder.build();
//   }
// }
