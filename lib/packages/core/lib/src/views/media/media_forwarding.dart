import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_handler.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_utils.dart';
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
      appBar: AppBar(
        backgroundColor: LMChatTheme.theme.scaffold,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
          valueListenable: rebuildCurr,
          builder: (context, _, __) {
            return Container();
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
                              type: LMChatIconType.svg,
                              assetPath: 'attachmentIcon',
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
                                  for (LMChatMediaModel media
                                      in pickedMediaFiles) {
                                    if (getFileSizeInDouble(media.size!) >
                                        100) {
                                      toast(
                                        'File size should be smaller than 100MB',
                                      );
                                      pickedMediaFiles.remove(media);
                                    }
                                  }
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

  // Widget getMediaPreview() {
  //   if (mediaList.first.mediaType == MediaType.photo ||
  //       mediaList.first.mediaType == MediaType.video) {
  //     return Center(
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             height: 2.h,
  //           ),
  //           // ConstrainedBox(
  //           //   constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 60.h),
  //           //   child: Center(
  //           //     child: mediaList[currPosition].mediaType == MediaType.photo
  //           //         ? Image.file(
  //           //             mediaList[currPosition].mediaFile!,
  //           //             fit: BoxFit.cover,
  //           //           )
  //           //         : Padding(
  //           //             padding: EdgeInsets.symmetric(
  //           //               vertical: 2.h,
  //           //             ),
  //           //             child: chatVideoFactory(
  //           //                 mediaList[currPosition], flickManager!),
  //           //           ),
  //           //   ),
  //           // ),
  //           const Spacer(),
  //           Container(
  //             decoration: const BoxDecoration(
  //                 color: kWhiteColor,
  //                 border: Border(
  //                   top: BorderSide(
  //                     color: kGreyColor,
  //                     width: 0.1,
  //                   ),
  //                 )),
  //             padding: EdgeInsets.only(
  //               left: 5.0,
  //               right: 5.0,
  //               top: 2.h,
  //               bottom: 12.h,
  //             ),
  //             child: checkIfMultipleAttachments()
  //                 ? SizedBox(
  //                     height: 15.w,
  //                     width: 100.w,
  //                     child: Center(
  //                       child: ListView.builder(
  //                         padding: EdgeInsets.zero,
  //                         itemCount: mediaList.length,
  //                         scrollDirection: Axis.horizontal,
  //                         itemBuilder: (context, index) => GestureDetector(
  //                           onTap: () {
  //                             currPosition = index;
  //                             if (mediaList[index].mediaType ==
  //                                 MediaType.video) {
  //                               if (flickManager == null) {
  //                                 flickManager = FlickManager(
  //                                   videoPlayerController:
  //                                       VideoPlayerController.file(
  //                                           mediaList[index].mediaFile!),
  //                                   autoPlay: true,
  //                                   onVideoEnd: () {
  //                                     flickManager?.flickVideoManager
  //                                         ?.videoPlayerController!
  //                                         .setLooping(true);
  //                                   },
  //                                   autoInitialize: true,
  //                                 );
  //                               } else {
  //                                 flickManager?.handleChangeVideo(
  //                                   VideoPlayerController.file(
  //                                       mediaList[index].mediaFile!),
  //                                 );
  //                               }
  //                             }
  //                             rebuildCurr.value = !rebuildCurr.value;
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.symmetric(
  //                               horizontal: 3.0,
  //                             ),
  //                             clipBehavior: Clip.hardEdge,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(12.0),
  //                                 border: currPosition == index
  //                                     ? Border.all(
  //                                         color: secondary.shade400,
  //                                         width: 4.0,
  //                                         // strokeAlign:
  //                                         //     BorderSide.strokeAlignOutside,
  //                                       )
  //                                     : null),
  //                             width: 15.w,
  //                             height: 15.w,
  //                             child: mediaList[index].mediaType ==
  //                                     MediaType.photo
  //                                 ? ClipRRect(
  //                                     borderRadius: BorderRadius.circular(8.0),
  //                                     child: Image.file(
  //                                       mediaList[index].mediaFile!,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   )
  //                                 // check if thumbnail file is there in the media object
  //                                 // if not then get the thumbnail from the video file
  //                                 : mediaList[index].thumbnailFile != null
  //                                     ? ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.0),
  //                                         child: Image.file(
  //                                           mediaList[index].thumbnailFile!,
  //                                           fit: BoxFit.cover,
  //                                         ),
  //                                       )
  //                                     : ClipRRect(
  //                                         borderRadius:
  //                                             BorderRadius.circular(8.0),
  //                                         child: FutureBuilder(
  //                                           future: getVideoThumbnail(
  //                                               mediaList[index]),
  //                                           builder: (context, snapshot) {
  //                                             if (snapshot.connectionState ==
  //                                                 ConnectionState.waiting) {
  //                                               return mediaShimmer();
  //                                             } else if (snapshot.data !=
  //                                                 null) {
  //                                               return Image.file(
  //                                                 snapshot.data!,
  //                                                 fit: BoxFit.cover,
  //                                               );
  //                                             } else {
  //                                               return SizedBox(
  //                                                 child: Icon(
  //                                                   Icons.error,
  //                                                   color: secondary.shade400,
  //                                                 ),
  //                                               );
  //                                             }
  //                                           },
  //                                         ),
  //                                       ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 : const SizedBox(),
  //           )
  //         ],
  //       ),
  //     );
  //   } else if (mediaList.first.mediaType == MediaType.document) {
  //     return DocumentFactory(
  //       mediaList: mediaList,
  //       chatroomId: widget.chatroomId,
  //     );
  //   }
  //   return const SizedBox();
  // }
}
