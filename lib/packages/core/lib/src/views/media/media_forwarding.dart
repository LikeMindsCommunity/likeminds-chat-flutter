import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/builder.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_media_forwarding_screen}
/// A screen to preview media before adding attachments to a conversation
///
/// Creates a new instance for [LMChatMediaForwardingScreen]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatMediaForwardingScreenConfig]
/// {@endtemplate}
class LMChatMediaForwardingScreen extends StatefulWidget {
  /// Required chatrooom ID for th chatroom media is being sent to
  final int chatroomId;

  ///{@macro lm_chat_media_forwarding_screen}
  const LMChatMediaForwardingScreen({
    super.key,
    required this.chatroomId,
  });

  @override
  State<LMChatMediaForwardingScreen> createState() =>
      _LMChatMediaForwardingScreenState();
}

class _LMChatMediaForwardingScreenState
    extends State<LMChatMediaForwardingScreen> {
  int currPosition = 0;
  List<LMChatMediaModel> mediaList = [];
  LMChatConversationBloc? conversationBloc;

  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  final TextEditingController _textEditingController = TextEditingController();

  final LMChatMediaForwardingBuilderDelegate _screenBuilder =
      LMChatCore.config.mediaForwardingConfig.builder;

  @override
  void initState() {
    super.initState();
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  void didUpdateWidget(covariant LMChatMediaForwardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      backgroundColor: LMChatTheme.theme.scaffold,
      appBar: _screenBuilder.appBarBuilder(context, _defAppBar()),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: rebuildCurr,
              builder: (context, _, __) {
                return getMediaPreview();
              },
            ),
          ),
          _defChatBar(),
        ],
      ),
    );
  }

  Widget _defChatBar() {
    return Container(
      color: LMChatTheme.theme.shadowColor.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 2.h,
          top: 1.h,
          left: 3.w,
          right: 3.w,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: _defTextField(),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _screenBuilder.sendButton(
                context,
                _onSend,
                _defSendButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defTextField() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 8.w,
        maxHeight: 24.h,
      ),
      decoration: BoxDecoration(
        color: LMChatTheme.theme.container,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kPaddingSmall,
                vertical: 1.w,
              ),
              child: LMChatTextField(
                isDown: false,
                chatroomId: widget.chatroomId,
                style: Theme.of(context).textTheme.bodyMedium!,
                onChange: (value) {
                  // print(value);
                },
                onTagSelected: (tag) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintMaxLines: 1,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: "Type something..",
                ),
                controller: _textEditingController,
                focusNode: FocusNode(),
              ),
            ),
          ),
          _screenBuilder.attachmentButton(
            context,
            _defAttachmentButton(),
          )
        ],
      ),
    );
  }

  LMChatButton _defAttachmentButton() {
    return LMChatButton(
      icon: const LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.attachment,
      ),
      style: LMChatButtonStyle(
        height: 4.h,
        margin: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 3.w,
        ),
        backgroundColor: Colors.transparent,
      ),
      onTap: () async {
        if (mediaList.first.mediaType == LMChatMediaType.image) {
          await LMChatMediaHandler.instance.pickImages();
        } else if (mediaList.first.mediaType == LMChatMediaType.video) {
          await LMChatMediaHandler.instance.pickVideos();
        } else if (mediaList.first.mediaType == LMChatMediaType.document) {
          await LMChatMediaHandler.instance.pickDocuments();
        }

        mediaList = LMChatMediaHandler.instance.pickedMedia;
        rebuildCurr.value = !rebuildCurr.value;
      },
    );
  }

  void _onSend() {
    LMChatConversationBloc.instance.add(
      LMChatPostMultiMediaConversationEvent(
        (PostConversationRequestBuilder()
              ..attachmentCount(mediaList.length)
              ..chatroomId(widget.chatroomId)
              ..temporaryId(DateTime.now().millisecondsSinceEpoch.toString())
              ..text(_textEditingController.text)
              ..hasFiles(true))
            .build(),
        LMChatMediaHandler.instance.pickedMedia,
      ),
    );
    Navigator.pop(context);
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 60,
        gap: 12,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      leading: LMChatButton(
        onTap: () {
          LMChatMediaHandler.instance.clearPickedMedia();
          Navigator.pop(context);
        },
        icon: const LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.arrow_back,
        ),
      ),
      title: LMChatText(
        "Add Media",
        style: LMChatTextStyle(
          maxLines: 1,
          padding: const EdgeInsets.only(top: 2),
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  LMChatButton _defSendButton(BuildContext context) {
    return LMChatButton(
      onTap: _onSend,
      style: LMChatButtonStyle(
        backgroundColor: LMChatTheme.theme.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        borderRadius: 100,
        height: 6.h,
        width: 6.h,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.send,
        style: LMChatIconStyle(
          size: 28,
          boxSize: 36,
          boxPadding: const EdgeInsets.only(left: 2),
          color: LMChatTheme.theme.container,
        ),
      ),
    );
  }

  Widget getMediaPreview() {
    if (mediaList.first.mediaType == LMChatMediaType.image ||
        mediaList.first.mediaType == LMChatMediaType.video) {
      return Column(
        children: [
          SizedBox(height: 2.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 60.h),
            child: Center(
              child: mediaList[currPosition].mediaType == LMChatMediaType.image
                  ? _screenBuilder.image(
                      context,
                      _defImage(),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                      ),
                      child: _screenBuilder.video(
                        context,
                        _defVideo(),
                      ),
                    ),
            ),
          ),
          const Spacer(),
          _defPreviewBar()
        ],
      );
    } else if (mediaList.first.mediaType == LMChatMediaType.document) {
      return Column(
        children: [
          SizedBox(height: 2.h),
          _screenBuilder.document(context, _defDocument(mediaList)),
          const Spacer(),
          _defPreviewBar()
        ],
      );
    }
    return const SizedBox();
  }

  Container _defPreviewBar() {
    return Container(
      decoration: BoxDecoration(
          color: LMChatTheme.theme.container,
          border: Border(
            top: BorderSide(
              color: LMChatTheme.theme.disabledColor,
              width: 0.1,
            ),
          )),
      padding: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        top: 2.h,
        bottom: 2.h,
      ),
      child: SizedBox(
        height: 15.w,
        width: 100.w,
        child: Center(
          child: _defPreviewList(),
        ),
      ),
    );
  }

  ListView _defPreviewList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: mediaList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          currPosition = index;
          rebuildCurr.value = !rebuildCurr.value;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 3.0,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: currPosition == index
                  ? Border.all(
                      color: LMChatTheme.theme.secondaryColor,
                      width: 2.0,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                  : null),
          width: 15.w,
          height: 15.w,
          child: mediaList[index].mediaType == LMChatMediaType.image
              ? _defImageThumbnail(index)
              : mediaList[index].mediaType == LMChatMediaType.video
                  ? _defVideoThumbnail(index)
                  : _defDocumentThumbnail(index),
        ),
      ),
    );
  }

  LMChatImage _defImage() {
    return LMChatImage(
      imageFile: mediaList[currPosition].mediaFile!,
      style: const LMChatImageStyle(
        boxFit: BoxFit.cover,
      ),
    );
  }

  LMChatImage _defImageThumbnail(int index) {
    return LMChatImage(
      imageFile: mediaList[index].mediaFile!,
      style: const LMChatImageStyle(
        boxFit: BoxFit.cover,
      ),
    );
  }

  LMChatDocumentPreview _defDocument(List<LMChatMediaModel> mediaList) {
    return LMChatDocumentPreview(mediaList: mediaList);
  }

  LMChatDocumentThumbnail _defDocumentThumbnail(int index) {
    return LMChatDocumentThumbnail(
      media: mediaList[index],
      style: LMChatDocumentThumbnailStyle(
        height: 15.w,
        width: 15.w,
      ),
    );
  }

  LMChatVideo _defVideo() => LMChatVideo(
        media: mediaList[currPosition],
        key: ObjectKey(mediaList[currPosition].hashCode),
      );

  Widget _defVideoThumbnail(int index) {
    return mediaList[index].thumbnailFile != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LMChatImage(
              imageFile: mediaList[index].thumbnailFile!,
              style: const LMChatImageStyle(
                boxFit: BoxFit.cover,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: FutureBuilder(
              future: getVideoThumbnail(mediaList[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return mediaShimmer();
                } else if (snapshot.data != null) {
                  return Image.file(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                } else {
                  return SizedBox(
                    child: Icon(
                      Icons.error,
                      color: LMChatTheme.theme.secondaryColor,
                    ),
                  );
                }
              },
            ),
          );
  }
}
