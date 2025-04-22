import 'dart:typed_data';

import 'video_thumbnail_instance.dart'
    if (dart.library.js) 'video_thumbnail_web.dart';

/// Abstract class for generating video thumbnails
abstract class VideoThumbnailGenerator {
  static VideoThumbnailGenerator get instance => getVideoThumbnailInstance();
  
  /// Generates a thumbnail from video bytes
  /// 
  /// [videoBytes] The video file as bytes
  /// [timeSeconds] The timestamp in seconds to generate the thumbnail from
  /// Returns a [Uint8List] containing the thumbnail image data
  Future<Uint8List> generateThumbnailFromBytes(Uint8List videoBytes, {double timeSeconds = 1.0});
}