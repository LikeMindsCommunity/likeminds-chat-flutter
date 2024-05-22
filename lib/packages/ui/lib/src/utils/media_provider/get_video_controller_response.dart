part of 'media_provider.dart';

class LMChatGetPostVideoControllerResponse {
  final String postId;
  final VideoController videoPlayerController;

  const LMChatGetPostVideoControllerResponse._(
      {required this.postId, required this.videoPlayerController});
}
