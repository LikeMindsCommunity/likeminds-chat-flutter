import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/attachment/attachment_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_handler.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/media/media_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/permission_handler.dart';
import 'package:likeminds_chat_flutter_core/src/utils/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

/// {@template lm_chat_media_forwarding_screen}
/// A screen to preview media before attaching of LMChat
///
/// Creates a new instance for [LMChatMediaForwardingScreen]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatMediaForwardingScreenConfig]
/// {@endtemplate}
class LMChatMediaForwardingScreen extends StatefulWidget {
  final int chatroomId;

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
  List<LMChatMediaModel> mediaList = [];
  final TextEditingController _textEditingController = TextEditingController();
  int currPosition = 0;
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  LMChatConversationBloc? conversationBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LMChatTheme.theme.scaffold,
      appBar: _defAppBar(),
      body: ValueListenableBuilder(
          valueListenable: rebuildCurr,
          builder: (context, _, __) {
            return getMediaPreview();
          }),
      bottomSheet: BottomSheet(
        onClosing: () {},
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: 1.h,
            top: 1.h,
            left: 3.w,
            right: 3.w,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 8.w,
                    maxHeight: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPaddingSmall,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 3.w,
                        ),
                        child: SizedBox(
                          height: 4.h,
                          child: LMChatButton(
                            icon: const LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.attachment,
                            ),
                            onTap: () async {
                              if (await handlePermissions(1)) {
                                LMChatMediaType mediaType = mediaList.isNotEmpty
                                    ? mediaList.first.mediaType
                                    : LMChatMediaType.image;
                                List<LMChatMediaModel> pickedMediaFiles =
                                    (mediaType == LMChatMediaType.document
                                            ? await LMChatMediaHandler
                                                .pickDocuments(mediaList.length)
                                            : mediaType == LMChatMediaType.video
                                                ? await LMChatMediaHandler
                                                    .pickVideos(
                                                        mediaList.length)
                                                : await LMChatMediaHandler
                                                    .pickImages(
                                                        mediaList.length))
                                        .data!;
                                if (pickedMediaFiles.isNotEmpty) {
                                  if (mediaList.length +
                                          pickedMediaFiles.length >
                                      10) {
                                    toast('Only 10 attachments can be sent');
                                    return;
                                  }
                                  // for (LMChatMediaModel media
                                  //     in pickedMediaFiles) {
                                  //   if (getFileSizeInDouble(media.size!) >
                                  //       100) {
                                  //     toast(
                                  //       'File size should be smaller than 100MB',
                                  //     );
                                  //     pickedMediaFiles.remove(media);
                                  //   }
                                  // }
                                  mediaList.addAll(pickedMediaFiles);
                                }
                                rebuildCurr.value = !rebuildCurr.value;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  LMChatConversationBloc.instance.add(
                    LMChatPostMultiMediaConversationEvent(
                      (PostConversationRequestBuilder()
                            ..attachmentCount(mediaList.length)
                            ..chatroomId(widget.chatroomId)
                            ..temporaryId(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString())
                            ..text('Dummy text')
                            ..hasFiles(true))
                          .build(),
                      mediaList,
                    ),
                  );
                },
                child: Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: const Center(
                    child: LMChatIcon(
                      type: LMChatIconType.icon,
                      icon: Icons.send_outlined,
                      style: LMChatIconStyle(
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        gap: 12,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      leading: LMChatButton(
        onTap: () {
          Navigator.pop(context);
        },
        icon: const LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.cancel_outlined,
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LMChatText(
            "Participants",
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          kVerticalPaddingSmall,
          Text(
            '_memberCountText',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget getMediaPreview() {
    if (mediaList.first.mediaType == LMChatMediaType.image ||
        mediaList.first.mediaType == LMChatMediaType.video) {
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 60.h),
              child: Center(
                child:
                    mediaList[currPosition].mediaType == LMChatMediaType.image
                        ? Image.file(
                            mediaList[currPosition].mediaFile!,
                            fit: BoxFit.cover,
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.h,
                            ),
                            child: Container(),
                          ),
              ),
            ),
            const Spacer(),
            Container(
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
                bottom: 12.h,
              ),
              child: true
                  ? SizedBox(
                      height: 15.w,
                      width: 100.w,
                      child: Center(
                        child: ListView.builder(
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
                                          color:
                                              LMChatDefaultTheme.disabledColor,
                                          width: 4.0,
                                          // strokeAlign:
                                          //     BorderSide.strokeAlignOutside,
                                        )
                                      : null),
                              width: 15.w,
                              height: 15.w,
                              child: mediaList[index].mediaType ==
                                      LMChatMediaType.image
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        mediaList[index].mediaFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  // check if thumbnail file is there in the media object
                                  // if not then get the thumbnail from the video file
                                  : mediaList[index].thumbnailFile != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.file(
                                            mediaList[index].thumbnailFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: FutureBuilder(
                                            future: getVideoThumbnail(
                                                mediaList[index]
                                                    .toAttachmentViewData()),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return mediaShimmer();
                                              } else if (snapshot.data !=
                                                  null) {
                                                return Image.file(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                );
                                              } else {
                                                return SizedBox(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: LMChatTheme
                                                        .theme.secondaryColor,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      );
    } else if (mediaList.first.mediaType == LMChatMediaType.document) {
      return Container();
    }
    return const SizedBox();
  }
}
