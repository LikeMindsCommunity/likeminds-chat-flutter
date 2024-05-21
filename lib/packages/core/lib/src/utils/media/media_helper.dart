import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:pdf_bitmaps/pdf_bitmaps.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
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

String getDeletedText(Conversation conversation, User user) {
  return conversation.deletedByUserId == conversation.userId
      ? conversation.deletedByUserId == user.id
          ? 'This message was deleted'
          : "This message was deleted by user"
      : "This message was deleted by Admin";
}

LMChatText getDeletedTextWidget(Conversation conversation, User user,
    {int? maxLines}) {
  return LMChatText(
    getDeletedText(conversation, user),
    style: LMChatTextStyle(
      maxLines: maxLines,
      textStyle: TextStyle(
        color: LMChatTheme.theme.secondaryColor,
        fontStyle: FontStyle.italic,
        fontSize: 13,
      ),
    ),
  );
}

Widget getChatItemAttachmentTile(
    List<LMChatMedia> mediaFiles, Conversation conversation) {
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
    if (mediaFiles.first.mediaType == LMChatMediaType.document) {
      iconData = Icons.insert_drive_file;
      if (conversation.answer.isEmpty) {
        text = mediaFiles.length > 1 ? "Documents" : "Document";
      } else {
        text = answerText;
      }
    } else {
      int videoCount = 0;
      int imageCount = 0;
      for (LMChatMedia media in mediaFiles) {
        if (media.mediaType == LMChatMediaType.video) {
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
            boxPadding: 0,
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

Widget getDocumentThumbnail(File document, {Size? size}) {
  return PdfDocumentLoader.openFile(
    document.path,
    onError: (error) {},
    pageNumber: 1,
    pageBuilder: (context, textureBuilder, pageSize) {
      return textureBuilder(
        size: size,
      );
    },
  );
}

Widget getDocumentDetails(LMChatMedia document) {
  return SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${document.pageCount ?? ''} ${document.pageCount == null ? '' : (document.pageCount ?? 0) > 1 ? 'pages' : 'page'} ${document.pageCount == null ? '' : '●'} ${getFileSizeString(bytes: document.size!)} ● PDF',
          style: const TextStyle(
            color: LMChatDefaultTheme.whiteColor,
          ),
        )
      ],
    ),
  );
}

Future<File?> getVideoThumbnail(LMChatMedia media) async {
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

LMChatMediaType getMediaTypeFromExtention(String extention) {
  if (videoExtentions.contains(extention)) {
    return LMChatMediaType.video;
  } else {
    return LMChatMediaType.photo;
  }
}

Future<List<LMChatMedia>> pickImageFiles() async {
  FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.image,
    // allowedExtensions: videoExtentions,
  );
  List<LMChatMedia> mediaList = <LMChatMedia>[];
  if (pickedFiles == null) {
    return [];
  }
  if (pickedFiles.files.isNotEmpty) {
    for (int i = 0; i < pickedFiles.files.length; i++) {
      File file = File(pickedFiles.paths[i]!);
      LMChatMediaType mediaType =
          getMediaTypeFromExtention(pickedFiles.files[i].extension!);
      LMChatMedia media;
      if (mediaType == LMChatMediaType.photo) {
        ui.Image image = await decodeImageFromList(file.readAsBytesSync());
        media = LMChatMedia(
          mediaType: mediaType,
          height: image.height,
          width: image.width,
          mediaFile: file,
          size: pickedFiles.files[i].size,
        );
      } else {
        media = LMChatMedia(
          mediaType: mediaType,
          mediaFile: file,
          size: pickedFiles.files[i].size,
        );
      }
      getVideoThumbnail(media);
      mediaList.add(media);
    }
  }
  return mediaList;
}

Future<List<LMChatMedia>> pickVideoFiles() async {
  FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.video,
    // allowedExtensions: videoExtentions,
  );
  List<LMChatMedia> mediaList = <LMChatMedia>[];
  if (pickedFiles == null) {
    return [];
  }
  if (pickedFiles.files.isNotEmpty) {
    for (int i = 0; i < pickedFiles.files.length; i++) {
      File file = File(pickedFiles.paths[i]!);
      LMChatMediaType mediaType =
          getMediaTypeFromExtention(pickedFiles.files[i].extension!);
      LMChatMedia media;
      if (mediaType == LMChatMediaType.photo) {
        ui.Image image = await decodeImageFromList(file.readAsBytesSync());
        media = LMChatMedia(
          mediaType: mediaType,
          height: image.height,
          width: image.width,
          mediaFile: file,
          size: pickedFiles.files[i].size,
        );
      } else {
        media = LMChatMedia(
          mediaType: mediaType,
          mediaFile: file,
          size: pickedFiles.files[i].size,
        );
      }
      getVideoThumbnail(media);
      mediaList.add(media);
    }
  }
  return mediaList;
}

// Future<List<LMChatMedia>> pickMultipleMediaFiles() async{
//   final List<XFile> pickedFiles = await ImagePicker().pickMultipleMedia();
//    List<LMChatMedia> mediaList = <LMChatMedia>[];
//   if (pickedFiles.isEmpty) {
//     return [];
//   } else {
//     pickedFiles.forEach((element) {
//       File file = File(element.path);

//     });
//   }
// }

Future<List<LMChatMedia>> pickDocumentFiles() async {
  FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true, type: FileType.custom, allowedExtensions: ['pdf']);
  if (pickedFiles == null) {
    return [];
  }
  List<LMChatMedia> mediaList = <LMChatMedia>[];
  if (pickedFiles.files.isNotEmpty) {
    for (int i = 0; i < pickedFiles.files.length; i++) {
      File file = File(pickedFiles.paths[i]!);
      int? pageCount;
      if (Platform.isAndroid) {
        pageCount = await PdfBitmaps().pdfPageCount(
          params: PDFPageCountParams(pdfPath: file.path),
        );
      }
      LMChatMedia media = LMChatMedia(
        mediaType: LMChatMediaType.document,
        mediaFile: file,
        size: pickedFiles.files[i].size,
        pageCount: pageCount,
      );
      mediaList.add(media);
    }
  }
  return mediaList;
}
