import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/media/configurations/preview/builder.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_media_preview_screen}
/// A screen to preview media before adding attachments to a conversation
///
/// Creates a new instance for [LMChatMediaPreviewScreen]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatMediaForwardingScreenConfig]
/// {@endtemplate}
class LMChatMediaPreviewScreen extends StatefulWidget {
  /// required conversation object to fetch media and title
  final LMChatConversationViewData? conversation;

  /// {@macro lm_chat_media_preview_screen}
  const LMChatMediaPreviewScreen({
    super.key,
    this.conversation,
  });

  @override
  State<LMChatMediaPreviewScreen> createState() =>
      _LMChatMediaPreviewScreenState();
}

class _LMChatMediaPreviewScreenState extends State<LMChatMediaPreviewScreen> {
  int currPosition = 0;
  List<LMChatMediaModel> mediaList = [];

  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);

  final LMChatMediaPreviewBuilderDelegate _screenBuilder =
      LMChatCore.config.mediaPreviewConfig.builder;

  @override
  void initState() {
    super.initState();
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  void didUpdateWidget(covariant LMChatMediaPreviewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    mediaList = LMChatMediaHandler.instance.pickedMedia;
  }

  @override
  void deactivate() {
    LMChatMediaHandler.instance.clearPickedMedia();
    super.deactivate();
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
      body: ValueListenableBuilder(
        valueListenable: rebuildCurr,
        builder: (context, _, __) {
          return getMediaPreview();
        },
      ),
    );
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
          icon: Icons.cancel_outlined,
        ),
      ),
      title: LMChatText(
        widget.conversation == null
            ? "Attachments"
            : widget.conversation!.member!.name,
        style: LMChatTextStyle(
          maxLines: 1,
          padding: const EdgeInsets.only(top: 2),
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      subtitle: ValueListenableBuilder(
        valueListenable: rebuildCurr,
        builder: (c, x, s) {
          return LMChatText(
            "${currPosition + 1} of ${mediaList.length} attachments",
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
    );
  }

  Widget getMediaPreview() {
    // Updated to handle single attachment preview
    if (mediaList.isNotEmpty) {
      if (mediaList.first.mediaType == LMChatMediaType.image ||
          mediaList.first.mediaType == LMChatMediaType.video) {
        return Column(
          children: [
            const Spacer(),
            Center(
              child: mediaList[currPosition].mediaType == LMChatMediaType.image
                  ? _screenBuilder.image(
                      context,
                      _defImage(),
                      mediaList[currPosition],
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: _screenBuilder.video(
                        context,
                        _defVideo(),
                        mediaList[currPosition],
                      ),
                    ),
            ),
            const Spacer(),
            _screenBuilder.mediaPreviewBuilder(
              context,
              LMChatMediaHandler.instance.pickedMedia.copy(),
              currPosition,
              _defPreviewBar(),
            ),
          ],
        );
      }
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
        left: 2.w,
        right: 5.0,
        top: 2.h,
        bottom: 4.h,
      ),
      child: SizedBox(
        height: 15.w,
        child: _defPreviewList(),
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
              : _defVideoThumbnail(index),
        ),
      ),
    );
  }

  LMChatImage _defImage() {
    return LMChatImage(
      imageUrl: mediaList[currPosition].mediaUrl,
      imageFile: mediaList[currPosition].mediaFile,
      style: const LMChatImageStyle(
        boxFit: BoxFit.cover,
      ),
    );
  }

  LMChatImage _defImageThumbnail(int index) {
    return LMChatImage(
      imageUrl: mediaList[index].thumbnailUrl ?? mediaList[index].mediaUrl,
      imageFile: mediaList[index].thumbnailFile ?? mediaList[index].mediaFile,
      style: LMChatImageStyle(
        boxFit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8.0),
        width: 100.w,
      ),
    );
  }

  LMChatVideo _defVideo() => LMChatVideo(
        media: mediaList[currPosition],
        key: ObjectKey(mediaList[currPosition].hashCode),
      );

  Widget _defVideoThumbnail(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LMChatImage(
            imageUrl: mediaList[index].thumbnailUrl,
            imageFile: mediaList[index].thumbnailFile,
            style: const LMChatImageStyle(
              boxFit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
