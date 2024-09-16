import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

class CustomChatMediaForwarding extends LMChatMediaForwardingBuilderDelegate {
  @override
  Widget image(BuildContext context, LMChatImage image) {
    // TODO: implement image
    return image.copyWith(
        onMediaTap: () {
          print("This is tapped");
        },
        style: const LMChatImageStyle(
          backgroundColor: Colors.teal,
          aspectRatio: 1,
          boxFit: BoxFit.cover,
          borderColor: Colors.amber,
        ));
  }

  @override
  Widget video(BuildContext context, LMChatVideo video) {
    // TODO: implement video
    return video.copyWith(
      style: const LMChatVideoStyle(
        borderColor: Colors.amber,
        aspectRatio: 1.9,
      ),
    );
  }

  @override
  Widget attachmentButton(BuildContext context, LMChatButton attachmentButton) {
    // TODO: implement attachmentButton
    return attachmentButton.copyWith(
      icon: const LMChatIcon(
        type: LMChatIconType.icon,
        icon: CupertinoIcons.add,
      ),
      style: const LMChatButtonStyle(backgroundColor: Colors.teal),
    );
  }

  @override
  Widget document(BuildContext context, LMChatDocumentPreview document) {
    // TODO: implement document
    return document.copyWith(
      style: const LMChatDocumentPreviewStyle(
        backgroundColor: Colors.amberAccent,
        fileNameStyle: LMChatTextStyle(
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0),
        borderRadius: BorderRadius.all(
          Radius.circular(300),
        ),
      ),
    );
  }

  @override
  Widget gif(BuildContext context, LMChatGIF gif) {
    // TODO: implement gif
    return gif.copyWith(
      style: const LMChatGIFStyle(),
      autoplay: false,
    );
  }
}
