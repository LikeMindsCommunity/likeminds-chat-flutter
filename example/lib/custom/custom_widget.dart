import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

class CustomWidget extends LMChatMediaPreviewBuilderDelegate {
  @override
  Widget attachmentButton(BuildContext context, LMChatButton attachmentButton) {
    return attachmentButton.copyWith(
        style: attachmentButton.style?.copyWith(backgroundColor: Colors.teal));
  }

  @override
  PreferredSizeWidget appBarBuilder(BuildContext context, LMChatAppBar appBar,
      int mediaLength, int currentIndex) {
    return appBar;
  }

  @override
  Widget image(
      BuildContext context, LMChatImage image, LMChatMediaModel mediaModel) {
    return image.copyWith(
      style: image.style?.copyWith(
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.teal,
        aspectRatio: 1,
        boxFit: BoxFit.cover,
        borderColor: Colors.amber,
      ),
      onMediaTap: () {
        print("This is tapped");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Scaffold()));
      },
    );
  }

  @override
  Widget video(
      BuildContext context, LMChatVideo video, LMChatMediaModel media) {
    // TODO: implement video
    return video.copyWith(
        muteButton: (button) {
          return ElevatedButton(
              onPressed: button.onTap, child: const Text("Mute"));
        },
        style: video.style?.copyWith(
          padding: const EdgeInsets.all(12.0),
          aspectRatio: 1,
          boxFit: BoxFit.cover,
          borderColor: Colors.amber,
        ));
  }
}
