import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A class to manage all media picking, and accessing
///
/// Gives access to functions that handles media picking natively
class LMChatMediaHandler {
  /// A function that returns a List of videos from device storage
  static Future<LMResponse<List<LMChatMediaModel>>> pickVideos(
      int currentMediaLength) async {
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

  /// A function that returns an image from device storage
  static Future<LMResponse<LMChatMediaModel>> pickSingleImage() async {
    final FilePickerResult? list = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      compressionQuality: 0,
    );
    const double sizeLimit = 5;

    if (list != null && list.files.isNotEmpty) {
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
      LMChatMediaModel mediaFile;

      mediaFile = LMChatMediaModel(
          mediaType: LMChatMediaType.image,
          mediaFile: File(list.files.first.path!),
          meta: {
            'file_name': list.files.first.name,
          });

      return LMResponse(success: true, data: mediaFile);
    } else {
      return LMResponse(success: true);
    }
  }

  /// A function that returns a List of images from device storage
  static Future<LMResponse<List<LMChatMediaModel>>> pickImages(
      int mediaCount) async {
    final FilePickerResult? list = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      compressionQuality: 0,
    );
    const double sizeLimit = 5;

    if (list != null && list.files.isNotEmpty) {
      if (mediaCount + list.files.length > 10) {
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

      return LMResponse(success: true, data: attachedImages);
    } else {
      return LMResponse(success: true);
    }
  }

  /// A function that returns a List of documents from device storage
  static Future<LMResponse<List<LMChatMediaModel>>> pickDocuments(
      int currentMediaLength) async {
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
        List<LMChatMediaModel> attachedFiles = [];
        for (var pickedFile in pickedFiles.files) {
          if (getFileSizeInDouble(pickedFile.size) > 100) {
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

            attachedFiles.add(documentFile);
          }
        }

        return LMResponse(success: true, data: attachedFiles);
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
}
