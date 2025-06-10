import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/media/video_thumbnail.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/media/error.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

/// Builds a widget to display the attachment tiles for a chat item.
///
/// This function takes a list of media files and a conversation object,
/// and returns a widget that shows the appropriate UI for the attachments.
/// If there are no media files and no answer text, an empty SizedBox is returned.
/// If there are no media files but there is answer text, it displays the answer text.
/// If there are media files, it determines the type of media and displays
/// the corresponding icon and text based on the media type.
///
/// [mediaFiles] - A list of media files associated with the chat item.
/// [conversation] - The conversation data that may contain answer text.
///
/// Returns a [Widget] that represents the attachment tile.
Widget getChatItemAttachmentTile(
  BuildContext context,
  String message,
  List<LMChatAttachmentViewData> mediaFiles,
  LMChatConversationViewData conversation, {
  String? prefix,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final imageWidth = width < 500 ? width * 0.35 : width * 0.25;
  String answerText = LMChatTaggingHelper.convertRouteToTag(conversation.answer,
          withTilde: false) ??
      '';
  if (conversation.ogTags != null) {
    return Row(
      children: [
        LMChatText(
          prefix ?? '',
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
        LMChatText(
          message,
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
        LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.link,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            size: 16,
          ),
        ),
      ],
    );
  }
  if (conversation.state == 10) {
    return Row(
      children: [
        LMChatText(
          message,
          style: LMChatTextStyle(
            textStyle: TextStyle(
              color: LMChatTheme.theme.onContainer,
            ),
          ),
        ),
        const SizedBox(width: 4),
        LMChatIcon(
          type: LMChatIconType.svg,
          assetPath: kPollIcon,
          style: LMChatIconStyle(
            size: 14,
            color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            boxPadding: const EdgeInsets.only(
              right: 4,
            ),
          ),
        ),
        SizedBox(
          width: width * 0.5,
          child: LMChatText(
            answerText,
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: LMChatTheme.theme.onContainer.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
  if (mediaFiles.isEmpty && conversation.answer.isEmpty) {
    return const SizedBox();
  } else if (mediaFiles.isEmpty) {
    return Row(
      children: [
        LMChatText(
          prefix ?? '',
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
        LMChatText(
          answerText,
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  } else {
    IconData iconData = Icons.camera_alt;
    String text = '';
    if (mapStringToMediaType(mediaFiles.first.type!) ==
        LMChatMediaType.voiceNote) {
      return Row(
        children: [
          LMChatText(
            prefix ?? '',
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: LMChatTheme.theme.onContainer.withOpacity(0.8),
              ),
            ),
          ),
          LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.mic,
            style: LMChatIconStyle(
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
              size: 16,
            ),
          ),
          LMChatDefaultTheme.kHorizontalPaddingSmall,
          LMChatText(
            "Voice Message",
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                overflow: TextOverflow.ellipsis,
                color: LMChatTheme.theme.onContainer.withOpacity(0.8),
              ),
            ),
          ),
        ],
      );
    } else if (mapStringToMediaType(mediaFiles.first.type!) ==
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
      int gifCount = 0;
      for (LMChatAttachmentViewData media in mediaFiles) {
        if (mapStringToMediaType(media.type!) == LMChatMediaType.video) {
          videoCount++;
        } else if (mapStringToMediaType(media.type!) == LMChatMediaType.gif) {
          gifCount++;
        } else {
          imageCount++;
        }
      }
      if (videoCount != 0 && imageCount != 0) {
        return Row(
          children: <Widget>[
            LMChatText(
              prefix ?? '',
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                ),
              ),
            ),
            LMChatText(
              videoCount.toString(),
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.video_camera_back,
              style: LMChatIconStyle(
                color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                size: 16,
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingMedium,
            LMChatText(
              imageCount.toString(),
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.image,
              style: LMChatIconStyle(
                color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                size: 16,
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingSmall,
            Expanded(
              child: LMChatText(
                answerText,
                style: LMChatTextStyle(
                  maxLines: 1,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                    color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                  ),
                ),
              ),
            )
          ],
        );
      } else if (videoCount == 0 && gifCount == 0) {
        iconData = Icons.image;
        if (conversation.answer.isEmpty) {
          text = mediaFiles.length > 1 ? "Images" : "Image";
        } else {
          text = answerText;
        }
      } else if (imageCount == 0 && gifCount == 0) {
        iconData = Icons.video_camera_back;
        if (conversation.answer.isEmpty) {
          text = mediaFiles.length > 1 ? "Videos" : "Video";
        } else {
          text = answerText;
        }
      } else if (gifCount > 0) {
        iconData = Icons.image;
        text = gifCount > 1 ? "GIFs" : "GIF";
      }
    }
    return Row(
      children: <Widget>[
        LMChatText(
          prefix ?? '',
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
        mediaFiles.length > 1
            ? LMChatText(
                '${mediaFiles.length}',
                style: LMChatTextStyle(
                  maxLines: 1,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                    color: LMChatTheme.theme.onContainer.withOpacity(0.8),
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
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            size: 16,
            boxSize: 16,
          ),
        ),
        LMChatDefaultTheme.kHorizontalPaddingSmall,
        SizedBox(
          width: imageWidth,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: LMChatTheme.theme.onContainer.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}

Future<File?> getVideoThumbnail(LMChatMediaModel media) async {
  String? thumbnailPath = await VideoThumbnail.thumbnailFile(
    video: media.mediaFile!.path,
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
  media.width = image.width;
  media.height = image.height;
  media.thumbnailFile ??= thumbnailFile;

  return thumbnailFile;
}

Future<Uint8List?> getVideoThumbnailBytes(LMChatMediaModel media) async {
  final thumbnailBytes = await VideoThumbnailGenerator.instance
      .generateThumbnailFromBytes(media.mediaBytes!);
  media.thumbnailBytes = thumbnailBytes;
  return thumbnailBytes;
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  if (bytes > 0) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1000)).floor();
    return "${((bytes / pow(1000, i)).toStringAsFixed(decimals))} ${suffixes[i]}";
  } else {
    return "0";
  }
}

// Returns file size in double in MBs
double getFileSizeInDouble(int bytes) {
  return (bytes / pow(1000, 2));
}

Widget getChatBubbleImage(
  LMChatAttachmentViewData mediaFile, {
  double? width,
  double? height,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
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
                    ? mediaFile.url ?? mediaFile.fileUrl ?? ''
                    : mediaFile.thumbnailUrl ?? '',
            fit: BoxFit.cover,
            height: height,
            width: width,
            errorWidget: (context, url, error) =>
                const LMChatMediaErrorWidget(),
            progressIndicatorBuilder: (context, url, progress) =>
                const LMChatMediaShimmerWidget(),
          ),
          mapStringToMediaType(mediaFile.type!) == LMChatMediaType.video &&
                  mediaFile.thumbnailUrl != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),
                    LMChatIcon(
                      type: LMChatIconType.icon,
                      icon: Icons.play_arrow,
                      style: LMChatIconStyle(
                        color: LMChatDefaultTheme.whiteColor,
                        boxSize: 32,
                        backgroundColor:
                            LMChatDefaultTheme.blackColor.withOpacity(0.3),
                        size: 24,
                        boxBorderRadius: 16,
                        boxPadding: const EdgeInsets.all(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        children: [
                          LMChatIcon(
                            type: LMChatIconType.icon,
                            icon: Icons.video_camera_back_outlined,
                            style: LMChatIconStyle(
                              color: LMChatTheme.theme.onPrimary,
                              boxSize: 20,
                              size: 18,
                              boxPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(width: 4),
                          mediaFile.meta?["duration"] != null
                              ? LMChatText(
                                  mediaFile.meta?["duration"].toString() ?? '',
                                  style: LMChatTextStyle.basic().copyWith(
                                    backgroundColor:
                                        LMChatTheme.theme.onPrimary,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

Widget getFileImageTile(LMChatAttachmentViewData mediaFile,
    {double? width, double? height}) {
  if (mediaFile.attachmentFile == null &&
      mediaFile.thumbnailFile == null &&
      mediaFile.attachmentBytes == null &&
      mediaFile.thumbnailBytes == null) {
    return const LMChatMediaErrorWidget();
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
        kIsWeb
            ? Image.memory(
                mediaFile.thumbnailBytes ?? mediaFile.attachmentBytes!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const LMChatMediaErrorWidget(),
                height: height,
                width: width,
              )
            : Image.file(
                mapStringToMediaType(mediaFile.type!) == LMChatMediaType.image
                    ? mediaFile.attachmentFile!
                    : mediaFile.thumbnailFile!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const LMChatMediaErrorWidget(),
                height: height,
                width: width,
              ),
        mapStringToMediaType(mediaFile.type!) == LMChatMediaType.video &&
                (mediaFile.thumbnailFile != null ||
                    mediaFile.thumbnailBytes != null)
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
                  ),
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}

Widget getImageMessage(
  BuildContext context,
  List<LMChatAttachmentViewData>? conversationAttachments,
  LMChatImageBuilder? imageBuilder,
) {
  if (conversationAttachments == null || conversationAttachments.isEmpty) {
    return const SizedBox();
  }
  final width = MediaQuery.sizeOf(context).width;
  final imageWidth = width < 500 ? width * 0.45 : width * 0.27;
  if (conversationAttachments.length == 1) {
    return getChatBubbleImage(
      conversationAttachments.first,
      height: imageWidth,
      width: imageWidth,
    );
  } else if (conversationAttachments.length == 2) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getChatBubbleImage(
          conversationAttachments[0],
          height: imageWidth * 0.50,
          width: imageWidth * 0.50,
        ),
        kHorizontalPaddingSmall,
        getChatBubbleImage(
          conversationAttachments[1],
          height: imageWidth * 0.50,
          width: imageWidth * 0.50,
        ),
      ],
    );
  } else if (conversationAttachments.length == 3) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getChatBubbleImage(
          conversationAttachments[0],
          height: imageWidth * 0.5,
          width: imageWidth * 0.5,
        ),
        kHorizontalPaddingSmall,
        Container(
          height: imageWidth * 0.5,
          width: imageWidth * 0.5,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Stack(
            children: [
              getChatBubbleImage(
                conversationAttachments[1],
                height: imageWidth * 0.5,
                width: imageWidth * 0.5,
              ),
              Positioned(
                child: Container(
                  height: imageWidth * 0.5,
                  width: imageWidth * 0.5,
                  alignment: Alignment.center,
                  color: LMChatTheme.theme.container.withOpacity(0.5),
                  child: LMChatText(
                    '+2',
                    style: LMChatTextStyle(
                      textStyle: TextStyle(
                        color: LMChatTheme.theme.onContainer.withOpacity(0.8),
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
    );
  } else if (conversationAttachments.length == 4) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getChatBubbleImage(
              conversationAttachments[0],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
            kHorizontalPaddingSmall,
            getChatBubbleImage(
              conversationAttachments[1],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
          ],
        ),
        kVerticalPaddingSmall,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getChatBubbleImage(
              conversationAttachments[2],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
            kHorizontalPaddingSmall,
            getChatBubbleImage(
              conversationAttachments[3],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
          ],
        ),
      ],
    );
  } else {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getChatBubbleImage(
              conversationAttachments[0],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
            kHorizontalPaddingSmall,
            getChatBubbleImage(
              conversationAttachments[1],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
          ],
        ),
        kVerticalPaddingSmall,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getChatBubbleImage(
              conversationAttachments[2],
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
            ),
            kHorizontalPaddingSmall,
            Container(
              height: imageWidth * 0.5,
              width: imageWidth * 0.5,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
              child: Stack(
                children: [
                  getChatBubbleImage(
                    conversationAttachments[3],
                    height: imageWidth * 0.5,
                    width: imageWidth * 0.5,
                  ),
                  Positioned(
                    child: Container(
                      height: imageWidth * 0.5,
                      width: imageWidth * 0.5,
                      alignment: Alignment.center,
                      color: LMChatTheme.theme.container.withOpacity(0.5),
                      child: LMChatText(
                        '+2',
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            color:
                                LMChatTheme.theme.onContainer.withOpacity(0.8),
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
    );
  }
}

Widget getImageFileMessage(
  BuildContext context,
  List<LMChatAttachmentViewData> mediaFiles,
  LMChatImageBuilder? imageBuilder,
) {
  final width = MediaQuery.sizeOf(context).width;
  if (mediaFiles.length == 1) {
    return GestureDetector(
      child: getFileImageTile(
        mediaFiles.first,
        height: width * 0.55,
        width: width * 0.55,
      ),
    );
  } else if (mediaFiles.length == 2) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getFileImageTile(
            mediaFiles[0],
            height: width * 0.35,
            width: width * 0.35,
          ),
          LMChatDefaultTheme.kHorizontalPaddingSmall,
          getFileImageTile(
            mediaFiles[1],
            height: width * 0.25,
            width: width * 0.25,
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
            height: width * 0.25,
            width: width * 0.25,
          ),
          LMChatDefaultTheme.kHorizontalPaddingSmall,
          Container(
            height: width * 0.25,
            width: width * 0.25,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Stack(
              children: [
                getFileImageTile(
                  mediaFiles[1],
                  height: width * 0.25,
                  width: width * 0.25,
                ),
                Positioned(
                  child: Container(
                    height: width * 0.25,
                    width: width * 0.25,
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
                height: width * 0.25,
                width: width * 0.25,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[1],
                height: width * 0.25,
                width: width * 0.25,
              ),
            ],
          ),
          LMChatDefaultTheme.kVerticalPaddingSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[2],
                height: width * 0.25,
                width: width * 0.25,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[3],
                height: width * 0.25,
                width: width * 0.25,
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
                height: width * 0.25,
                width: width * 0.25,
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              getFileImageTile(
                mediaFiles[1],
                height: width * 0.25,
                width: width * 0.25,
              ),
            ],
          ),
          LMChatDefaultTheme.kVerticalPaddingSmall,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getFileImageTile(
                mediaFiles[2],
                height: width * 0.25,
                width: width * 0.25,
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
                      height: width * 0.25,
                      width: width * 0.25,
                    ),
                    Positioned(
                      child: Container(
                        height: width * 0.25,
                        width: width * 0.25,
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

/// Downloads a file from a URL and saves it locally
///
/// Parameters:
/// - fileUrl: Direct URL to the file on AWS storage
/// - media: Optional media model containing file information
///
/// Returns the local file path where the file was saved
Future<String> downloadFile({String? fileUrl, LMChatMediaModel? media}) async {
  try {
    final String url = fileUrl ?? media?.mediaUrl ?? '';
    if (url.isEmpty) {
      throw Exception('No URL provided for download');
    }

    if (kIsWeb) {
      // For web, we return the URL directly since we can't save files locally
      return url;
    } else {
      // Existing native platform implementation
      final String fileName = path.basename(url);
      final Directory tempDir = await getTemporaryDirectory();
      final String localPath = path.join(tempDir.path, fileName);

      if (await File(localPath).exists()) {
        return localPath;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      final File file = File(localPath);
      await file.writeAsBytes(response.bodyBytes);

      return localPath;
    }
  } catch (e) {
    throw Exception('Error downloading file: $e');
  }
}
