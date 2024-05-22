part of 'media_provider.dart';

enum LMChatVideoSourceType { network, file }

class LMChatGetVideoControllerRequest {
  final String postId;
  final String videoSource;
  final int position;
  final LMChatVideoSourceType videoType;
  final bool autoPlay;

  LMChatGetVideoControllerRequest._({
    required this.postId,
    required this.videoSource,
    required this.videoType,
    this.position = 0,
    this.autoPlay = false,
  });
}

class LMChatGetVideoControllerRequestBuilder {
  String? _postId;
  String? _videoSource;
  LMChatVideoSourceType? _videoType;
  bool _autoPlay = false;
  int _position = 0;

  void position(int position) {
    _position = position;
  }

  void postId(String postId) {
    _postId = postId;
  }

  void videoSource(String videoSource) {
    _videoSource = videoSource;
  }

  void videoType(LMChatVideoSourceType videoType) {
    _videoType = videoType;
  }

  void autoPlay(bool autoPlay) {
    _autoPlay = autoPlay;
  }

  LMChatGetVideoControllerRequest build() {
    return LMChatGetVideoControllerRequest._(
      postId: _postId!,
      videoSource: _videoSource!,
      videoType: _videoType!,
      autoPlay: _autoPlay,
      position: _position,
    );
  }
}
