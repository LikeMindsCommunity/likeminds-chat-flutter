import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/attachment/attachment_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/credentials/credentials.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A class to manage all media picking, and accessing
///
/// Gives access to functions that handles media picking natively
class LMChatMediaHandler {
  static final LMChatMediaHandler _instance = LMChatMediaHandler._internal();

  LMChatMediaHandler._internal();

  /// Returns the singleton instance of [LMChatMediaHandler].
  ///
  /// This getter provides access to the singleton instance of [LMChatMediaHandler],
  /// which is used to manage media picking and accessing.
  ///
  /// Returns a [LMChatMediaHandler] object.
  static LMChatMediaHandler get instance => _instance;

  final List<LMChatMediaModel> pickedMedia = [];

  /// Adds one or more media items to the pickedMedia list
  ///
  /// [media] can be a single LMChatMediaModel or a List<LMChatMediaModel>
  void addPickedMedia(dynamic media) {
    if (media is LMChatMediaModel) {
      pickedMedia.add(media);
    } else if (media is List<LMChatMediaModel>) {
      pickedMedia.addAll(media);
    } else if (media is LMChatAttachmentViewData) {
      pickedMedia.add(media.toMediaModel());
    } else if (media is List<LMChatAttachmentViewData>) {
      pickedMedia.addAll(media.map((e) => e.toMediaModel()).toList());
    } else {
      throw Exception('Incorrect format for adding media');
    }
  }

  /// Clears all items from the pickedMedia list
  void clearPickedMedia() {
    pickedMedia.clear();
  }

  /// Picks multiple video files from the device storage
  ///
  /// [currentMediaLength] is the current number of media items already selected
  /// Returns an [LMResponse] containing a list of [LMChatMediaModel] for videos
  /// Enforces a size limit of 100MB per video file
  Future<LMResponse<List<LMChatMediaModel>>> pickVideos(
      {int mediaCount = 0}) async {
    try {
      List<LMChatMediaModel> videoFiles = [];
      final FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.video,
      );

      if (pickedFiles == null || pickedFiles.files.isEmpty) {
        return LMResponse(success: true);
      }

      const double sizeLimit = 100;
      if (mediaCount + pickedMedia.length + pickedFiles.files.length > 10) {
        return LMResponse(
            success: false,
            errorMessage:
                'A total of 10 attachments can be added to a message');
      }
      for (PlatformFile pFile in pickedFiles.files) {
        double fileSize = getFileSizeInDouble(pFile.size);

        if (fileSize > sizeLimit) {
          return LMResponse(
              success: false,
              errorMessage:
                  'Max file size allowed: ${sizeLimit.toStringAsFixed(2)}MB');
        } else {
          LMChatMediaModel videoFile;
          if (kIsWeb) {
            videoFile = LMChatMediaModel(
              mediaType: LMChatMediaType.video,
              mediaFile: File(pFile.path!),
              size: fileSize.toInt(),
              duration: 10,
              meta: {
                'file_name': pFile.name,
              },
            );
          } else {
            videoFile = LMChatMediaModel(
              mediaType: LMChatMediaType.video,
              mediaFile: File(pFile.path!),
              size: fileSize.toInt(),
              duration: 10,
              meta: {
                'file_name': pFile.name,
              },
            );
          }
          videoFiles.add(videoFile);
          addPickedMedia(videoFile);
        }
        return LMResponse(success: true, data: videoFiles);
      }
      return LMResponse(success: true);
    } on Exception catch (err) {
      return LMResponse(
        success: false,
        errorMessage: 'An error occurred\n${err.toString()}',
      );
    }
  }

  /// Picks a single image file from the device storage
  ///
  /// Returns an [LMResponse] containing an [LMChatMediaModel] for the selected image
  /// Enforces a size limit of 5MB for the image file
  Future<LMResponse<LMChatMediaModel>> pickSingleImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    const double sizeLimit = 5;

    if (image == null) {
      return LMResponse(
        success: false,
        errorMessage: 'No image selected.',
      );
    }

    final Uint8List uint8List = await File(image.path).readAsBytes();
    int intBytes = uint8List.fold(
        0, (previousValue, element) => (previousValue << 8) | element);
    ui.Image imageFile = await decodeImageFromList(uint8List);
    double fileSize = getFileSizeInDouble(intBytes);
    if (fileSize > sizeLimit) {
      return LMResponse(
        success: false,
        errorMessage:
            'Max file size allowed: ${sizeLimit.toStringAsFixed(2)}MB',
      );
    }

    LMChatMediaModel mediaFile = LMChatMediaModel(
        mediaType: LMChatMediaType.image,
        height: imageFile.height,
        width: imageFile.width,
        mediaFile: File(image.path),
        size: intBytes,
        meta: {
          'file_name': image.name,
        });

    return LMResponse(success: true, data: mediaFile);
  }

  /// Picks multiple image files from the device storage
  ///
  /// [mediaCount] is the current number of media items already selected
  /// Returns an [LMResponse] containing a list of [LMChatMediaModel] for images
  /// Enforces a size limit of 5MB per image file and a maximum of 10 total attachments
  Future<LMResponse<List<LMChatMediaModel>>> pickImages(
      {int mediaCount = 0}) async {
    final FilePickerResult? list = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      compressionQuality: 0,
    );
    const double sizeLimit = 5;

    if (list != null && list.files.isNotEmpty) {
      if (mediaCount + pickedMedia.length + list.files.length > 10) {
        return LMResponse(
            success: false,
            errorMessage:
                'A total of 10 attachments can be added to a message');
      }
      for (PlatformFile image in list.files) {
        int fileBytes = image.size;
        double fileSize = getFileSizeInDouble(fileBytes);
        if (fileSize > sizeLimit) {
          return LMResponse(
            success: false,
            errorMessage:
                'Max file size allowed: ${sizeLimit.toStringAsFixed(2)}MB',
          );
        }
      }

      List<LMChatMediaModel> attachedImages;

      attachedImages = list.files.map((e) {
        return LMChatMediaModel(
            mediaType: LMChatMediaType.image,
            mediaFile: File(e.path!),
            meta: {
              'file_name': e.name,
            });
      }).toList();

      addPickedMedia(attachedImages);
      return LMResponse(success: true, data: attachedImages);
    } else {
      return LMResponse(success: true);
    }
  }

  Future<LMResponse<List<LMChatMediaModel>>> pickMedia(
      {int mediaCount = 0}) async {
    final FilePickerResult? list = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );

    List<LMChatMediaModel> attachedMedia = [];
    if (list != null && list.files.isNotEmpty) {
      if (mediaCount + pickedMedia.length + list.files.length > 10) {
        return LMResponse(
            success: false,
            errorMessage:
                'A total of 10 attachments can be added to a message');
      }
      for (PlatformFile file in list.files) {
        if (checkFileType(file)) {
          // image case
          const double sizeLimit = 5;
          int fileBytes = file.size;
          double fileSize = getFileSizeInDouble(fileBytes);
          if (fileSize > sizeLimit) {
            return LMResponse(
              success: false,
              errorMessage:
                  'Max file size allowed: ${sizeLimit.toStringAsFixed(2)}MB',
            );
          }
          attachedMedia.add(
            LMChatMediaModel(
              mediaType: LMChatMediaType.image,
              mediaFile: File(file.path!),
              meta: {
                'file_name': file.name,
              },
            ),
          );
        } else {
          // video case
          const double sizeLimit = 100;
          int fileBytes = file.size;
          double fileSize = getFileSizeInDouble(fileBytes);
          if (fileSize > sizeLimit) {
            return LMResponse(
              success: false,
              errorMessage:
                  'Max file size allowed: ${sizeLimit.toStringAsFixed(2)}MB',
            );
          }
          attachedMedia.add(
            LMChatMediaModel(
              mediaType: LMChatMediaType.video,
              mediaFile: File(file.path!),
              meta: {
                'file_name': file.name,
              },
            ),
          );
        }
      }

      addPickedMedia(attachedMedia);
      return LMResponse(success: true, data: attachedMedia);
    } else {
      return LMResponse(success: true);
    }
  }

  /// Picks multiple document files (PDFs) from the device storage
  ///
  /// [currentMediaLength] is the current number of media items already selected
  /// Returns an [LMResponse] containing a list of [LMChatMediaModel] for documents
  /// Enforces a size limit of 100MB per document file
  Future<LMResponse<List<LMChatMediaModel>>> pickDocuments(
      {int mediaCount = 0}) async {
    try {
      final pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        dialogTitle: 'Select files',
        allowedExtensions: [
          'pdf',
        ],
      );
      if (pickedFiles != null) {
        for (var pickedFile in pickedFiles.files) {
          final size = getFileSizeInDouble(pickedFile.size);
          if (size > 100) {
            return LMResponse(
                success: false,
                errorMessage: 'File size should be smaller than 100MB');
          } else {
            LMChatMediaModel documentFile;
            documentFile = LMChatMediaModel(
                mediaType: LMChatMediaType.document,
                mediaFile: File(pickedFile.path!),
                size: pickedFile.size,
                meta: {
                  'file_name': pickedFile.name,
                });

            pickedMedia.add(documentFile);
          }
        }

        return LMResponse(success: true, data: pickedMedia);
      } else {
        return LMResponse(success: true);
      }
    } on Exception catch (err) {
      return LMResponse(
        success: false,
        errorMessage: 'An error occurred\n${err.toString()}',
      );
    }
  }

  bool checkFileType(PlatformFile file) {
    return photoExtentions.contains(file.extension);
  }

  Future<LMResponse<LMChatMediaModel>> pickGIF(BuildContext context) async {
    try {
      GiphyGif? gif = await GiphyGet.getGif(
        context: context, //Required
        apiKey: GIPHY_API_KEY, //Required.
        lang: GiphyLanguage.english, //Optional - Language for query.
        randomID: "lm-gif", // Optional - An ID/proxy for a specific user.
        tabColor:
            LMChatTheme.theme.primaryColor, // Optional- default accent color.
        debounceTimeInMilliseconds:
            350, // Optional- time to pause between search keystrokes
      );

      if (gif == null) {
        return LMResponse.error(errorMessage: "No GIF picked up");
      }

      LMChatMediaModel pickedGif = LMChatMediaModel(
          mediaType: LMChatMediaType.gif,
          mediaUrl: gif.images?.original?.url,
          height: int.tryParse(gif.images?.fixedHeight?.height ?? "0"),
          width: int.tryParse(gif.images?.fixedHeight?.width ?? "0"),
          meta: {
            "title": gif.title ?? "GIF from GIPHY",
            "url": gif.url,
          });

      addPickedMedia(pickedGif);
      return LMResponse(success: true, data: pickedGif);
    } catch (e) {
      debugPrint(e.toString());
      return LMResponse.error(errorMessage: "An error in picking up GIF");
    }
  }
}
