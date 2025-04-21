import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [AttachmentViewDataConvertor] is an extension on [Attachment] class.
/// It converts [Attachment] to [LMChatAttachmentViewData].
extension AttachmentViewDataConvertor on Attachment {
  /// Converts [Attachment] to [LMChatAttachmentViewData]
  LMChatAttachmentViewData toAttachmentViewData() {
    final LMChatAttachmentViewDataBuilder attachmentBuilder =
        LMChatAttachmentViewDataBuilder()
          ..answerId(answerId)
          ..attachmentFile(attachmentFile)
          ..attachmentBytes(attachmentBytes)
          ..createdAt(createdAt)
          ..dimensions(dimensions)
          ..fileUrl(fileUrl)
          ..height(height)
          ..width(width)
          ..id(id)
          ..index(index)
          ..locationLat(locationLat)
          ..locationLong(locationLong)
          ..locationName(locationName)
          ..meta(meta)
          ..name(name)
          ..thumbnailFile(thumbnailFile)
          ..thumbnailBytes(thumbnailBytes)
          ..thumbnailUrl(thumbnailUrl)
          ..type(type)
          ..url(url);

    return attachmentBuilder.build();
  }
}

/// [AttachmentConvertor] is an extension on [LMChatAttachmentViewData] class.
/// It converts [LMChatAttachmentViewData] to [Attachment].
extension AttachmentConvertor on LMChatAttachmentViewData {
  /// Converts [LMChatAttachmentViewData] to [Attachment]
  Attachment toAttachment() {
    return Attachment(
      id: id,
      createdAt: createdAt,
      locationLat: locationLat,
      locationLong: locationLong,
      type: type,
      answerId: answerId,
      attachmentFile: attachmentFile,
      attachmentBytes: attachmentBytes,
      dimensions: dimensions,
      height: height,
      width: width,
      index: index,
      locationName: locationName,
      meta: meta,
      name: name,
      thumbnailFile: thumbnailFile,
      thumbnailBytes: thumbnailBytes,
      thumbnailUrl: thumbnailUrl,
      url: url,
    );
  }
}

/// [MediaConvertor] is an extension on [LMChatAttachmentViewData] class.
/// It converts [LMChatAttachmentViewData] to [LMChatMediaModel].
extension MediaConvertor on LMChatAttachmentViewData {
  /// Converts [LMChatAttachmentViewData] to [LMChatMediaModel]
  LMChatMediaModel toMediaModel() {
    return LMChatMediaModel(
      mediaType: mapStringToMediaType(type!),
      mediaUrl: url ?? fileUrl,
      mediaFile: attachmentFile,
      mediaBytes: attachmentBytes,
      thumbnailUrl: thumbnailUrl,
      thumbnailFile: thumbnailFile,
      thumbnailBytes: thumbnailBytes,
      meta: meta,
      height: height,
      width: width,
    );
  }
}

/// [MediaConvertor] is an extension on [LMChatAttachmentViewData] class.
/// It converts [LMChatAttachmentViewData] to [LMChatMediaModel].
extension ViewDataConvertor on LMChatMediaModel {
  /// Converts [LMChatAttachmentViewData] to [LMChatMediaModel]
  LMChatAttachmentViewData toAttachmentViewData() {
    final LMChatAttachmentViewDataBuilder attachmentBuilder =
        LMChatAttachmentViewDataBuilder()
          ..attachmentFile(mediaFile)
          ..attachmentBytes(mediaBytes)
          ..fileUrl(mediaUrl)
          ..height(height)
          ..width(width)
          ..meta(meta)
          ..thumbnailFile(thumbnailFile)
          ..thumbnailBytes(thumbnailBytes)
          ..thumbnailUrl(thumbnailUrl)
          ..type(mapMediaTypeToString(mediaType))
          ..url(mediaUrl);

    return attachmentBuilder.build();
  }
}
