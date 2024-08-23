import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:video_player/video_player.dart';

class LMChatVideo extends StatefulWidget {
  final LMChatMediaModel media;
  const LMChatVideo({
    super.key,
    required this.media,
  });

  @override
  State<LMChatVideo> createState() => _LMChatVideoState();
}

class _LMChatVideoState extends State<LMChatVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.media.mediaUrl != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.media.mediaUrl!,
        ),
      )..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.file(widget.media.mediaFile!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        Center(
          child: LMChatButton(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            icon: _controller.value.isPlaying
                ? const LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: Icons.pause,
                    style: LMChatIconStyle(
                      size: 36,
                    ),
                  )
                : const LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: Icons.play_arrow,
                    style: LMChatIconStyle(
                      size: 36,
                    ),
                  ),
            style: const LMChatButtonStyle(
              height: 42,
              width: 42,
            ),
          ),
        )
      ],
    );
  }
}
