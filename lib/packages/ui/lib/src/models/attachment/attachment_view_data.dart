import 'dart:io';

class LMChatAttachmentViewData {
  final int? answerId;
  final int? createdAt;
  final dynamic dimensions;
  final String? fileUrl;
  final String? url;
  final File? attachmentFile;
  final dynamic height;
  final int? id;
  final int? index;
  final dynamic locationLat;
  final dynamic locationLong;
  final dynamic locationName;
  final dynamic meta;
  final String? name;
  final String? thumbnailUrl;
  final File? thumbnailFile;
  final String? type;
  final dynamic width;

  LMChatAttachmentViewData({
    required this.answerId,
    required this.createdAt,
    required this.dimensions,
    required this.fileUrl,
    required this.url,
    required this.attachmentFile,
    required this.height,
    required this.id,
    required this.index,
    required this.locationLat,
    required this.locationLong,
    required this.locationName,
    required this.meta,
    required this.name,
    required this.thumbnailUrl,
    required this.thumbnailFile,
    required this.type,
    required this.width,
  });
}
