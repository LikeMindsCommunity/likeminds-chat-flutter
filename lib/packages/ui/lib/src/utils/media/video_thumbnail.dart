import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';

Future<Uint8List> generateThumbnailFromBytes(Uint8List videoBytes, {double timeSeconds = 1.0}) async {
  // Create a Blob and object URL
  final blob = html.Blob([videoBytes], 'video/mp4'); // Adjust MIME type if needed
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
  html.Url.revokeObjectUrl(videoUrl); // Clean up
  video.remove();

  final base64Data = dataUrl.split(',').last;
  return base64Decode(base64Data);
}
