import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

const List<String> videoExtentions = [
  'mp4',
  'mov',
  'wmv',
  'avi',
  'mkv',
  'flv',
];

const List<String> photoExtentions = [
  'jpg',
  'jpeg',
  'png',
];

const List<String> mediaExtentions = [
  ...photoExtentions,
  ...videoExtentions,
];

Widget getChatItemAttachmentTile(
    List<LMChatAttachmentViewData> mediaFiles, Conversation conversation) {
  String answerText = LMChatTaggingHelper.convertRouteToTag(conversation.answer,
          withTilde: false) ??
      '';
  if (mediaFiles.isEmpty && conversation.answer.isEmpty) {
    return const SizedBox();
  } else if (mediaFiles.isEmpty) {
    return LMChatText(
      answerText,
      style: const LMChatTextStyle(
        maxLines: 1,
        textStyle: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  } else {
    IconData iconData = Icons.camera_alt;
    String text = '';
    if (mapStringToMediaType(mediaFiles.first.type!) ==
        LMChatMediaType.document) {
      iconData = Icons.insert_drive_file;
      if (conversation.answer.isEmpty) {
        text = mediaFiles.length > 1 ? "Documents" : "Document";
      } else {
        text = answerText;
      }
    } else {
      int videoCount = 0;
      int imageCount = 0;
      for (LMChatAttachmentViewData media in mediaFiles) {
        if (mapStringToMediaType(media.type!) == LMChatMediaType.video) {
          videoCount++;
        } else {
          imageCount++;
        }
      }
      if (videoCount != 0 && imageCount != 0) {
        return Row(
          children: <Widget>[
            LMChatText(
              videoCount.toString(),
              style: const LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            const LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.video_camera_back,
              style: LMChatIconStyle(
                color: LMChatDefaultTheme.greyColor,
                size: 16,
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingMedium,
            LMChatText(
              imageCount.toString(),
              style: const LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            const LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.image,
              style: LMChatIconStyle(
                color: LMChatDefaultTheme.greyColor,
                size: 16,
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            Expanded(
              child: LMChatText(
                answerText,
                style: const LMChatTextStyle(
                  maxLines: 1,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        );
      } else if (videoCount == 0) {
        iconData = Icons.image;
        if (conversation.answer.isEmpty) {
          text = mediaFiles.length > 1 ? "Images" : "Image";
        } else {
          text = answerText;
        }
      } else if (imageCount == 0) {
        iconData = Icons.video_camera_back;
        if (conversation.answer.isEmpty) {
          text = mediaFiles.length > 1 ? "Videos" : "Video";
        } else {
          text = answerText;
        }
      }
    }
    return Row(
      children: <Widget>[
        mediaFiles.length > 1
            ? LMChatText(
                '${mediaFiles.length}',
                style: const LMChatTextStyle(
                  maxLines: 1,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            : const SizedBox(),
        mediaFiles.length > 1
            ? LMChatDefaultTheme.kHorizontalPaddingSmall
            : const SizedBox(),
        LMChatIcon(
          type: LMChatIconType.icon,
          icon: iconData,
          style: const LMChatIconStyle(
            color: LMChatDefaultTheme.greyColor,
            size: 16,
            boxSize: 16,
          ),
        ),
        LMChatDefaultTheme.kHorizontalPaddingSmall,
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget getDocumentDetails(LMChatAttachmentViewData document) {
//   return SizedBox(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Text(
//           '${document.pageCount ?? ''} ${document.pageCount == null ? '' : (document.pageCount ?? 0) > 1 ? 'pages' : 'page'} ${document.pageCount == null ? '' : '●'} ${getFileSizeString(bytes: document.size!)} ● PDF',
//           style: const TextStyle(
//             color: LMChatDefaultTheme.whiteColor,
//           ),
//         )
//       ],
//     ),
//   );
// }

Future<File?> getVideoThumbnail(LMChatAttachmentViewData media) async {
  String? thumbnailPath = await VideoThumbnail.thumbnailFile(
    video: media.thumbnailFile!.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 300,
    quality: 50,
    timeMs: 100,
  ).onError((error, stackTrace) {
    debugPrint(error.toString());
    return null;
  });

  File? thumbnailFile;
  thumbnailFile = File(thumbnailPath!);
  ui.Image image = await decodeImageFromList(thumbnailFile.readAsBytesSync());
  // media.width = image.width;
  // media.height = image.height;
  // media. ??= thumbnailFile;

  return thumbnailFile;
}

LMChatMediaType getMediaTypeFromExtention(String extention) {
  if (videoExtentions.contains(extention)) {
    return LMChatMediaType.video;
  } else {
    return LMChatMediaType.image;
  }
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

Widget getChatBubbleImage(LMChatAttachmentViewData mediaFile,
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
          imageUrl:
              mapStringToMediaType(mediaFile.type!) == LMChatMediaType.image
                  ? mediaFile.url ?? ''
                  : mediaFile.thumbnailUrl ?? '',
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorWidget: (context, url, error) => mediaErrorWidget(),
          progressIndicatorBuilder: (context, url, progress) => mediaShimmer(),
        ),
        mapStringToMediaType(mediaFile.type!) == LMChatMediaType.video &&
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

Widget getFileImageTile(LMChatAttachmentViewData mediaFile,
    {double? width, double? height}) {
  if (mediaFile.attachmentFile == null && mediaFile.thumbnailFile == null) {
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
          mapStringToMediaType(mediaFile.type!) == LMChatMediaType.image
              ? mediaFile.attachmentFile!
              : mediaFile.thumbnailFile!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => mediaErrorWidget(),
          height: height,
          width: width,
        ),
        mapStringToMediaType(mediaFile.type!) == LMChatMediaType.video &&
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

Widget getImageFileMessage(
    BuildContext context, List<LMChatAttachmentViewData> mediaFiles) {
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
