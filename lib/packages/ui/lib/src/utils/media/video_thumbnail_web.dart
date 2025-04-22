// Add this conditional import to prevent web code from being included in mobile builds
library video_thumbnail_web;

import 'dart:typed_data';
import 'dart:convert';
import 'dart:html' if (dart.library.io) 'dart:ui' as html;
import 'video_thumbnail.dart';

class VideoThumbnailGeneratorWeb implements VideoThumbnailGenerator {
  @override
  Future<Uint8List> generateThumbnailFromBytes(Uint8List videoBytes, {double timeSeconds = 1.0}) async {
    
    // Web-specific implementation
    final blob = html.Blob([videoBytes], 'video/mp4');
    final videoUrl = html.Url.createObjectUrlFromBlob(blob);
    
    final video = html.VideoElement()
      ..src = videoUrl
      ..autoplay = false
      ..muted = true
      ..controls = false
      ..style.display = 'none';

    html.document.body!.append(video);

    await video.onLoadedMetadata.first;

    video.currentTime = timeSeconds;
    await video.onSeeked.first;

    final canvas = html.CanvasElement(width: video.videoWidth, height: video.videoHeight);
    final ctx = canvas.context2D;
    ctx.drawImage(video, 0, 0);

    final dataUrl = canvas.toDataUrl('image/png');
    html.Url.revokeObjectUrl(videoUrl);
    video.remove();

    final base64Data = dataUrl.split(',').last;
    return base64Decode(base64Data);
  }
}


VideoThumbnailGeneratorWeb getVideoThumbnailInstance() {
  return VideoThumbnailGeneratorWeb();
}
