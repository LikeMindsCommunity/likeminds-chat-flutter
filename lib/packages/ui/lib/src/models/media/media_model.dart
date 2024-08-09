import 'dart:io';

import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';

enum LMChatMediaType {
  video,
  image,
  document,
  link,
  audio,
  gif,
  voiceNote,
}

class LMChatMediaModel {
  File? mediaFile;
  LMChatMediaType mediaType;
  String? mediaUrl;
  int? width;
  int? height;
  String? thumbnailUrl;
  File? thumbnailFile;
  int? pageCount;
  int? size; // In bytes
  double? duration;
  LMChatOGTagsViewData? ogTags;
  Map<String, dynamic>? meta;

  LMChatMediaModel({
    this.mediaFile,
    required this.mediaType,
    this.mediaUrl,
    this.height,
    this.pageCount,
    this.size,
    this.thumbnailFile,
    this.thumbnailUrl,
    this.width,
    this.duration,
    this.ogTags,
    this.meta,
  });
}

String mapMediaTypeToString(LMChatMediaType mediaType) {
  switch (mediaType) {
    case LMChatMediaType.image:
      return kAttachmentTypeImage;
    case LMChatMediaType.video:
      return kAttachmentTypeVideo;
    case LMChatMediaType.document:
      return kAttachmentTypePDF;
    case LMChatMediaType.audio:
      return kAttachmentTypeAudio;
    case LMChatMediaType.gif:
      return kAttachmentTypeGIF;
    case LMChatMediaType.voiceNote:
      return kAttachmentTypeVoiceNote;
    case LMChatMediaType.link:
      return kAttachmentTypeLink;
    default:
      return kAttachmentTypeImage;
  }
}

LMChatMediaType mapStringToMediaType(String mediaType) {
  switch (mediaType) {
    case kAttachmentTypeImage:
      return LMChatMediaType.image;
    case kAttachmentTypeVideo:
      return LMChatMediaType.video;
    case kAttachmentTypePDF:
      return LMChatMediaType.document;
    case kAttachmentTypeAudio:
      return LMChatMediaType.audio;
    case kAttachmentTypeGIF:
      return LMChatMediaType.gif;
    case kAttachmentTypeVoiceNote:
      return LMChatMediaType.voiceNote;
    case kAttachmentTypeLink:
      return LMChatMediaType.link;
    default:
      return LMChatMediaType.image;
  }
}
