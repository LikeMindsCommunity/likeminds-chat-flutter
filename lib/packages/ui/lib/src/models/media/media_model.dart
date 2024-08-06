import 'dart:io';

import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

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

  // convert
  int mapMediaTypeToInt() {
    if (mediaType == LMChatMediaType.image) {
      return 1;
    } else if (mediaType == LMChatMediaType.video) {
      return 2;
    } else if (mediaType == LMChatMediaType.document) {
      return 3;
    } else if (mediaType == LMChatMediaType.link) {
      return 4;
    } else {
      throw 'no valid media type provided';
    }
  }
}

LMChatMediaType mapIntToMediaType(int attachmentType) {
  if (attachmentType == 1) {
    return LMChatMediaType.image;
  } else if (attachmentType == 2) {
    return LMChatMediaType.video;
  } else if (attachmentType == 3) {
    return LMChatMediaType.document;
  } else if (attachmentType == 4) {
    return LMChatMediaType.link;
  } else {
    throw 'no valid media type provided';
  }
}
