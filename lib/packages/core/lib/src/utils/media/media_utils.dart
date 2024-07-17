import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

enum LMChatMediaType { photo, video, document, audio, gif, voiceNote, link }

String mapMediaTypeToString(LMChatMediaType mediaType) {
  switch (mediaType) {
    case LMChatMediaType.photo:
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
      return 'link';
    default:
      return kAttachmentTypeImage;
  }
}

LMChatMediaType mapStringToMediaType(String mediaType) {
  switch (mediaType) {
    case kAttachmentTypeImage:
      return LMChatMediaType.photo;
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
    case 'link':
      return LMChatMediaType.link;
    default:
      return LMChatMediaType.photo;
  }
}

class LMChatMedia {
  File? mediaFile;
  LMChatMediaType mediaType;
  String? mediaUrl;
  int? width;
  int? height;
  String? thumbnailUrl;
  File? thumbnailFile;
  int? pageCount;
  int? size; // In bytes
  OgTags? ogTags;

  LMChatMedia({
    this.mediaFile,
    required this.mediaType,
    this.mediaUrl,
    this.height,
    this.pageCount,
    this.size,
    this.thumbnailFile,
    this.thumbnailUrl,
    this.width,
    this.ogTags,
  });

  static LMChatMedia fromJson(dynamic json) => LMChatMedia(
      mediaType: mapStringToMediaType(json['type']),
      height: json['height'] as int?,
      mediaUrl: json['url'] ?? json['file_url'],
      size: json['meta']?['size'],
      width: json['width'] as int?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      pageCount: json['meta']?['number_of_page'] as int?,
      ogTags: OgTags.fromEntity(OgTagsEntity.fromJson(json['og_tags'] ?? {})));
}

Widget mediaErrorWidget({bool isPP = false}) {
  return Container(
    color:
        isPP ? LMChatTheme.theme.primaryColor : LMChatDefaultTheme.whiteColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.error_outline,
          style: LMChatIconStyle(
            size: 10,
            color: isPP
                ? LMChatDefaultTheme.whiteColor
                : LMChatDefaultTheme.blackColor,
          ),
        ),
        isPP ? const SizedBox() : const SizedBox(height: 12),
        isPP
            ? const SizedBox()
            : LMChatText(
                "An error occurred fetching media",
                style: LMChatTextStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 8,
                    color: isPP
                        ? LMChatDefaultTheme.whiteColor
                        : LMChatDefaultTheme.blackColor,
                  ),
                ),
              )
      ],
    ),
  );
}

Widget mediaShimmer({bool? isPP}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade100,
    highlightColor: Colors.grey.shade200,
    period: const Duration(seconds: 2),
    direction: ShimmerDirection.ltr,
    child: isPP != null && isPP
        ? const CircleAvatar(backgroundColor: Colors.white)
        : Container(
            color: Colors.white,
            width: 180,
            height: 180,
          ),
  );
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  var i = (log(bytes) / log(1000)).floor();
  return "${((bytes / pow(1000, i)).toStringAsFixed(decimals))} ${suffixes[i]}";
}

// Returns file size in double in MBs
double getFileSizeInDouble(int bytes) {
  return (bytes / pow(1000, 2));
}

Widget getChatBubbleImage(LMChatMedia mediaFile,
    {double? width, double? height}) {
  return Container(
    height: height,
    width: width,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Stack(
      children: [
        CachedNetworkImage(
          imageUrl: mediaFile.mediaType == LMChatMediaType.photo
              ? mediaFile.mediaUrl ?? ''
              : mediaFile.thumbnailUrl ?? '',
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorWidget: (context, url, error) => mediaErrorWidget(),
          progressIndicatorBuilder: (context, url, progress) => mediaShimmer(),
        ),
        mediaFile.mediaType == LMChatMediaType.video &&
                mediaFile.thumbnailUrl != null
            ? Center(
                child: LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.play_arrow,
                  style: LMChatIconStyle(
                    color: LMChatDefaultTheme.blackColor,
                    boxSize: 32,
                    backgroundColor:
                        LMChatDefaultTheme.whiteColor.withOpacity(0.7),
                    size: 24,
                    boxBorderRadius: 16,
                    boxPadding: const EdgeInsets.all(6),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}

Widget getFileImageTile(LMChatMedia mediaFile,
    {double? width, double? height}) {
  if (mediaFile.mediaFile == null && mediaFile.thumbnailFile == null) {
    return mediaErrorWidget();
  }
  return Container(
    height: height,
    width: width,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3.0),
    ),
    child: Stack(
      children: [
        Image.file(
          mediaFile.mediaType == LMChatMediaType.photo
              ? mediaFile.mediaFile!
              : mediaFile.thumbnailFile!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => mediaErrorWidget(),
          height: height,
          width: width,
        ),
        mediaFile.mediaType == LMChatMediaType.video &&
                mediaFile.thumbnailFile != null
            ? Center(
                child: LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.play_arrow,
                  style: LMChatIconStyle(
                    color: LMChatDefaultTheme.blackColor,
                    boxSize: 36,
                    backgroundColor:
                        LMChatDefaultTheme.whiteColor.withOpacity(0.7),
                    size: 24,
                    boxBorderRadius: 18,
                    boxPadding: const EdgeInsets.all(8),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}

Widget getImageFileMessage(BuildContext context, List<LMChatMedia> mediaFiles) {
  if (mediaFiles.length == 1) {
    return GestureDetector(
      child: getFileImageTile(
        mediaFiles.first,
        height: 180,
        width: 180,
      ),
    );
  } else if (mediaFiles.length == 2) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getFileImageTile(
            mediaFiles[0],
            height: 120,
            width: 120,
          ),
          LMChatDefaultTheme.kHorizontalPaddingSmall,
          getFileImageTile(
            mediaFiles[1],
            height: 120,
            width: 120,
          )
        ],
      ),
    );
  } else if (mediaFiles.length == 3) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getFileImageTile(
            mediaFiles[0],
            height: 120,
            width: 120,
          ),
          LMChatDefaultTheme.kHorizontalPaddingSmall,
          Container(
            height: 120,
            width: 120,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Stack(
              children: [
                getFileImageTile(
                  mediaFiles[1],
                  height: 120,
                  width: 120,
                ),
                Positioned(
                  child: Container(
                    height: 72,
                    width: 72,
                    alignment: Alignment.center,
                    color: LMChatDefaultTheme.blackColor.withOpacity(0.5),
                    child: const LMChatText(
                      '+2',
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          color: LMChatDefaultTheme.whiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  } else if (mediaFiles.length == 4) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[0],
                height: 120,
                width: 120,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[1],
                height: 120,
                width: 120,
              ),
            ],
          ),
          LMChatDefaultTheme.kVerticalPaddingSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[2],
                height: 120,
                width: 120,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[3],
                height: 120,
                width: 120,
              ),
            ],
          ),
        ],
      ),
    );
  } else {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[0],
                height: 120,
                width: 120,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[1],
                height: 120,
                width: 120,
              ),
            ],
          ),
          LMChatDefaultTheme.kVerticalPaddingSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[2],
                height: 120,
                width: 120,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              Container(
                height: 120,
                width: 120,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
                child: Stack(
                  children: [
                    getFileImageTile(
                      mediaFiles[3],
                      height: 120,
                      width: 120,
                    ),
                    Positioned(
                      child: Container(
                        height: 120,
                        width: 120,
                        alignment: Alignment.center,
                        color: LMChatDefaultTheme.blackColor.withOpacity(0.5),
                        child: LMChatText(
                          '+${mediaFiles.length - 3}',
                          style: const LMChatTextStyle(
                            textStyle: TextStyle(
                              color: LMChatDefaultTheme.whiteColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
