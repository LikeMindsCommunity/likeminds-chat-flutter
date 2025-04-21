import 'dart:io';
import 'dart:typed_data';

import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';

/// Enumeration representing the type of media in a conversation
///
/// The supported media types are:
/// - [LMChatMediaType.video]: Represents a video media type.
/// - [LMChatMediaType.image]: Represents an image media type.
/// - [LMChatMediaType.document]: Represents a document media type.
/// - [LMChatMediaType.link]: Represents a link media type.
/// - [LMChatMediaType.audio]: Represents an audio media type.
/// - [LMChatMediaType.gif]: Represents a GIF media type.
/// - [LMChatMediaType.voiceNote]: Represents a voice note media type.
enum LMChatMediaType {
  /// Represents a video media type
  video,

  /// Represents an image media type
  image,

  /// Represents a document media type
  document,

  /// Represents a link media type
  link,

  /// Represents an audio media type
  audio,

  /// Represents a GIF media type
  gif,

  /// Represents a voice note media type
  voiceNote,
}

///{@template lm_chat_media_model}
/// [LMChatMediaModel] is a model class that represents media in a chat conversation.
/// It contains information about the media file, its type, dimensions, and additional metadata.
/// {@endtemplate}
class LMChatMediaModel {
  /// The media file associated with the chat
  File? mediaFile;

  /// The bytes of the media file associated with the chat
  Uint8List? mediaBytes;

  /// The type of media (e.g., image, video)
  LMChatMediaType mediaType;

  /// The URL of the media
  String? mediaUrl;

  /// The width of the media
  int? width;

  /// The height of the media
  int? height;

  /// The URL of the thumbnail image
  String? thumbnailUrl;

  /// The thumbnail file associated with the media
  File? thumbnailFile;

  /// The bytes of the thumbnail image
  Uint8List? thumbnailBytes;

  /// The number of pages (for documents)
  int? pageCount;

  /// The size of the media file in bytes
  int? size;

  /// The duration of the media (for audio/video)
  double? duration;

  /// Open Graph tags associated with the media
  LMChatOGTagsViewData? ogTags;

  /// Additional metadata related to the media
  Map<String, dynamic>? meta;

  /// The link associated with the media
  String? link;

  ///{@macro lm_chat_media_model}
  LMChatMediaModel({
    this.mediaFile,
    this.mediaBytes,
    required this.mediaType,
    this.mediaUrl,
    this.height,
    this.pageCount,
    this.size,
    this.thumbnailFile,
    this.thumbnailBytes,
    this.thumbnailUrl,
    this.width,
    this.duration,
    this.ogTags,
    this.meta,
    this.link,
  });

  /// copyWith method is used to create a new instance of `LMChatMediaModel` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatMediaModel copyWith({
    File? mediaFile,
    Uint8List? mediaBytes,
    LMChatMediaType? mediaType,
    String? mediaUrl,
    int? width,
    int? height,
    String? thumbnailUrl,
    File? thumbnailFile,
    Uint8List? thumbnailBytes,
    int? pageCount,
    int? size,
    double? duration,
    LMChatOGTagsViewData? ogTags,
    Map<String, dynamic>? meta,
    String? link,
  }) {
    return LMChatMediaModel(
      mediaFile: mediaFile ?? this.mediaFile,
      mediaBytes: mediaBytes ?? this.mediaBytes,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      thumbnailFile: thumbnailFile ?? this.thumbnailFile,
      thumbnailBytes: thumbnailBytes ?? this.thumbnailBytes,
      pageCount: pageCount ?? this.pageCount,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      ogTags: ogTags ?? this.ogTags,
      meta: meta ?? this.meta,
      link: link ?? this.link,
    );
  }
}

/// Maps the [LMChatMediaType] to its corresponding string representation.
///
/// This function takes a [LMChatMediaType] as input and returns the string
/// representation of the media type. The mapping is done using a switch statement.
/// The supported media types are:
/// - [LMChatMediaType.image]: Returns [kAttachmentTypeImage].
/// - [LMChatMediaType.video]: Returns [kAttachmentTypeVideo].
/// - [LMChatMediaType.document]: Returns [kAttachmentTypePDF].
/// - [LMChatMediaType.audio]: Returns [kAttachmentTypeAudio].
/// - [LMChatMediaType.gif]: Returns [kAttachmentTypeGIF].
/// - [LMChatMediaType.voiceNote]: Returns [kAttachmentTypeVoiceNote].
/// - [LMChatMediaType.link]: Returns [kAttachmentTypeLink].
/// If the input [LMChatMediaType] is not one of the supported types, it returns
/// [kAttachmentTypeImage] as the default value.
///
/// Returns:
/// - [String]: The string representation of the media type.
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

/// Maps the string representation of a media type to its corresponding [LMChatMediaType].
///
/// This function takes a [String] as input representing the media type and returns the corresponding [LMChatMediaType].
/// The supported media types are:
/// - [kAttachmentTypeImage]: Returns [LMChatMediaType.image].
/// - [kAttachmentTypeVideo]: Returns [LMChatMediaType.video].
/// - [kAttachmentTypePDF]: Returns [LMChatMediaType.document].
/// - [kAttachmentTypeAudio]: Returns [LMChatMediaType.audio].
/// - [kAttachmentTypeGIF]: Returns [LMChatMediaType.gif].
/// - [kAttachmentTypeVoiceNote]: Returns [LMChatMediaType.voiceNote].
/// - [kAttachmentTypeLink]: Returns [LMChatMediaType.link].
/// If the input [String] is not one of the supported types, it returns [LMChatMediaType.image] as the default value.
///
/// Parameters:
/// - [mediaType] (String): The string representation of the media type.
///
/// Returns:
/// - [LMChatMediaType]: The corresponding media type.
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
