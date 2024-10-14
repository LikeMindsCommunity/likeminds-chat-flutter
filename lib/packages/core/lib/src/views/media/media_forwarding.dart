import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/forwarding/builder.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

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

  final LMChatConversationViewData? replyConversation;

  final String? textFieldText;

  final String? chatroomName;

  ///{@macro lm_chat_media_forwarding_screen}
  const LMChatMediaForwardingScreen({
    super.key,
    required this.chatroomId,
    this.replyConversation,
    this.textFieldText,
    this.chatroomName,
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
  LMChatConversationViewData? replyConversation;
  String? textFieldText;

  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  final TextEditingController _textEditingController = TextEditingController();

  final LMChatMediaForwardingBuilderDelegate _screenBuilder =
      LMChatCore.config.mediaForwardingConfig.builder;

  List<LMChatTagViewData> tags = [];

  @override
  void initState() {
    super.initState();
    replyConversation = widget.replyConversation;
    textFieldText = widget.textFieldText;
    if (textFieldText != null) _textEditingController.text = textFieldText!;
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  void didUpdateWidget(covariant LMChatMediaForwardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    replyConversation = widget.replyConversation;
    textFieldText = widget.textFieldText;
    if (textFieldText != null) _textEditingController.text = textFieldText!;
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      onPopInvoked: (p0) {
        LMChatMediaHandler.instance.clearPickedMedia();
      },
      backgroundColor: LMChatTheme.theme.scaffold,
      appBar: _screenBuilder.appBarBuilder(
        context,
        _defAppBar(),
        LMChatMediaHandler.instance.pickedMedia.length,
        currPosition,
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: rebuildCurr,
              builder: (context, _, __) {
                return _buildMediaPreview();
              },
            ),
          ),
          _defChatBar(),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      children: [
        Expanded(
          child: _buildMainPreview(),
        ),
        if (mediaList.length > 1)
          _screenBuilder.mediaPreviewBuilder(
            context,
            LMChatMediaHandler.instance.pickedMedia,
            currPosition,
            _buildPreviewBar(),
          )
      ],
    );
  }

  Widget _buildMainPreview() {
    // Move the main preview logic here
    if (mediaList.first.mediaType == LMChatMediaType.image ||
        mediaList.first.mediaType == LMChatMediaType.video) {
      return Center(
        child: mediaList[currPosition].mediaType == LMChatMediaType.image
            ? _screenBuilder.image(context, _defImage())
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: _screenBuilder.video(context, _defVideo()),
              ),
      );
    } else if (mediaList.first.mediaType == LMChatMediaType.document) {
      return _screenBuilder.document(context, _defDocument());
    } else if (mediaList.first.mediaType == LMChatMediaType.gif) {
      return Center(child: _defaultGIF());
    }
    return const SizedBox();
  }

  Widget _buildPreviewBar() {
    return Container(
      decoration: BoxDecoration(
        color: LMChatTheme.theme.container,
        border: Border(
          top: BorderSide(
            color: LMChatTheme.theme.disabledColor,
            width: 0.1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 2.w,
      ),
      child: SizedBox(
        height: 15.w,
        child: _defPreviewList(),
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
    return Column(
      children: [
        if (replyConversation != null)
          _screenBuilder.replyWidget(
            context,
            _defReplyConversationWidget(),
          ),
        Container(
          constraints: BoxConstraints(
            minHeight: 8.w,
            maxHeight: 24.h,
          ),
          decoration: BoxDecoration(
            color: LMChatTheme.theme.container,
            borderRadius: replyConversation != null
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  )
                : BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      // Handle text change if needed
                    },
                    onTagSelected: (tag) {
                      tags.add(tag);
                      LMChatAnalyticsBloc.instance.add(
                        LMChatFireAnalyticsEvent(
                          eventName: LMChatAnalyticsKeys.userTagsSomeone,
                          eventProperties: {
                            'community_id': widget.chatroomId,
                            'chatroom_name': widget.chatroomName,
                            'tagged_user_id': tag.sdkClientInfoViewData?.uuid,
                            'tagged_user_name': tag.name,
                          },
                        ),
                      );
                    },
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
              if (mediaList.isNotEmpty &&
                  mediaList.first.mediaType != LMChatMediaType.gif)
                _screenBuilder.attachmentButton(
                  context,
                  _defAttachmentButton(),
                )
            ],
          ),
        ),
      ],
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
        if ((mediaList.first.mediaType == LMChatMediaType.image) ||
            (mediaList.first.mediaType == LMChatMediaType.video)) {
          await LMChatMediaHandler.instance.pickMedia();
        } else if (mediaList.first.mediaType == LMChatMediaType.document) {
          await LMChatMediaHandler.instance.pickDocuments();
        }

        mediaList = LMChatMediaHandler.instance.pickedMedia;
        rebuildCurr.value = !rebuildCurr.value;
      },
    );
  }

  /// Sends a post with the selected media to the server.
  ///
  /// This function is called when the user taps the send button.
  /// It sends a [LMChatPostMultiMediaConversationEvent] event to the
  /// [LMChatConversationBloc] with the selected media and the chatroom id.
  /// It also pops the current route.
  void _onSend() {
    if (_textEditingController.text.trim().isEmpty) {
      toast("Text can't be empty");
      return;
    }

    // Encode tags in the message
    String result = LMChatTaggingHelper.encodeString(
      _textEditingController.text,
      tags,
    ).trim();

    LMChatConversationBloc.instance.add(
      LMChatPostMultiMediaConversationEvent(
        (PostConversationRequestBuilder()
              ..replyId(replyConversation?.id)
              ..attachmentCount(mediaList.length)
              ..chatroomId(widget.chatroomId)
              ..temporaryId(DateTime.now().millisecondsSinceEpoch.toString())
              ..text(result)
              ..hasFiles(true))
            .build(),
        LMChatMediaHandler.instance.pickedMedia.copy(),
      ),
    );
    LMChatMediaHandler.instance.clearPickedMedia();
    Navigator.pop(context, true);
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

  LMChatGIF _defaultGIF() => LMChatGIF(
        media: mediaList.first,
        autoplay: true,
        style: LMChatGIFStyle(
          width: 100.w,
        ),
      );

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
        child: Stack(
          // Use Stack to overlay the remove button
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
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
            Visibility(
              visible: currPosition == index,
              child: Positioned(
                // Position the remove button
                top: 2,
                right: 4,
                child: InkWell(
                  onTap: () => _removeMedia(index),
                  child: LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: CupertinoIcons.xmark,
                    style: LMChatIconStyle(
                      color: LMChatTheme.theme.onContainer,
                      boxPadding: const EdgeInsets.all(4),
                      size: 12,
                      boxSize: 18,
                      boxBorderRadius: 12,
                      backgroundColor: LMChatTheme.theme.container,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeMedia(int index) {
    setState(() {
      mediaList.removeAt(index);
      if (currPosition >= mediaList.length) {
        currPosition =
            mediaList.length - 1; // Adjust current position if needed
      }
      rebuildCurr.value = !rebuildCurr.value; // Trigger rebuild
    });
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

  LMChatDocumentPreview _defDocument() {
    return LMChatDocumentPreview(
      media: mediaList[currPosition],
      style: LMChatDocumentPreviewStyle(
        maxHeight: 50.h,
      ),
    );
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
        style: const LMChatVideoStyle(),
      );

  Widget _defVideoThumbnail(int index) {
    return mediaList[index].thumbnailFile != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LMChatImage(
              imageFile: mediaList[index].thumbnailFile!,
              style: LMChatImageStyle(
                boxFit: BoxFit.cover,
                width: 15.w,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: FutureBuilder(
              future: getVideoThumbnail(mediaList[index]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LMChatMediaShimmerWidget();
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

  LMChatBarHeader _defReplyConversationWidget() {
    String userText = replyConversation?.member?.name ?? '';
    final currentUser = LMChatLocalPreference.instance.getUser();
    if (replyConversation?.memberId == currentUser.id) {
      userText = 'You';
    }
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic(),
      titleText: userText,
      onCanceled: () {
        setState(() {
          replyConversation = null;
        });
      },
      subtitle: LMChatText(
        LMChatTaggingHelper.convertRouteToTag(replyConversation?.answer) ?? "",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
