import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentThumbnailFile extends StatefulWidget {
  final int? index;
  final LMChatMediaModel media;

  const DocumentThumbnailFile({
    Key? key,
    required this.media,
    this.index,
  }) : super(key: key);

  @override
  State<DocumentThumbnailFile> createState() => _DocumentThumbnailFileState();
}

class _DocumentThumbnailFileState extends State<DocumentThumbnailFile> {
  String? _fileName;
  final String _fileExtension = 'pdf';
  String? _fileSize;
  String? url;
  File? file;
  Future? loadedFile;
  Widget? documentFile;

  Future loadFile() async {
    url = widget.media.mediaUrl;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile;
      _fileName = basenameWithoutExtension(file!.path);
    } else {
      final String url = widget.media.mediaUrl!;
      _fileName = basenameWithoutExtension(url);
      file = await DefaultCacheManager().getSingleFile(url);
    }

    _fileSize = getFileSizeString(bytes: widget.media.size ?? 0);
    documentFile = PdfDocumentLoader.openFile(
      file!.path,
      pageNumber: 1,
      pageBuilder: (context, textureBuilder, pageSize) => SizedBox(
        child: Container(
          height: 140,
          width: 55.w,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadiusMedium),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: textureBuilder(
                allowAntialiasingIOS: true,
                backgroundFill: true,
                size: Size(pageSize.width, pageSize.height)),
          ),
        ),
      ),
    );
    return file;
  }

  @override
  void initState() {
    super.initState();
    loadedFile = loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadedFile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return InkWell(
            onTap: () async {
              if (widget.media.mediaUrl != null) {
                debugPrint(widget.media.mediaUrl);
                Uri fileUrl = Uri.parse(widget.media.mediaUrl!);
                launchUrl(fileUrl, mode: LaunchMode.externalApplication);
              } else {
                // OpenFilex.open(file!.path);
                debugPrint(file!.path);
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  child: documentFile!,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 70,
                    width: 54.w,
                    decoration: BoxDecoration(
                      color: LMChatTheme.theme.container.withOpacity(0.8),
                      border: Border.all(color: LMChatDefaultTheme.greyColor),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          kBorderRadiusMedium,
                        ),
                        bottomRight: Radius.circular(
                          kBorderRadiusMedium,
                        ),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: kPaddingLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kHorizontalPaddingMedium,
                        const LMChatIcon(
                          type: LMChatIconType.icon,
                          icon: Icons.insert_drive_file_outlined,
                          style: LMChatIconStyle(
                            size: 32,
                            boxSize: 32,
                            boxPadding: EdgeInsets.zero,
                          ),
                        ),
                        kHorizontalPaddingMedium,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: LMChatText(
                                  _fileName ?? '',
                                  style: const LMChatTextStyle(
                                    textAlign: TextAlign.left,
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      color: LMChatDefaultTheme.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                              kVerticalPaddingSmall,
                              Row(
                                children: [
                                  widget.media.pageCount != null
                                      ? Row(
                                          children: <Widget>[
                                            kHorizontalPaddingXSmall,
                                            LMChatText(
                                              "${widget.media.pageCount!} ${widget.media.pageCount! > 1 ? "Pages" : "Page"}",
                                              style: const LMChatTextStyle(
                                                textAlign: TextAlign.left,
                                                textStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: LMChatDefaultTheme
                                                      .greyColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            kHorizontalPaddingXSmall,
                                            const LMChatText(
                                              '·',
                                              style: LMChatTextStyle(
                                                textAlign: TextAlign.left,
                                                textStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: LMChatDefaultTheme
                                                      .greyColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  kHorizontalPaddingXSmall,
                                  LMChatText(
                                    _fileSize!.toUpperCase(),
                                    style: const LMChatTextStyle(
                                      textAlign: TextAlign.left,
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: LMChatDefaultTheme.greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  kHorizontalPaddingXSmall,
                                  const LMChatText(
                                    '·',
                                    style: LMChatTextStyle(
                                      textAlign: TextAlign.left,
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: LMChatDefaultTheme.greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  kHorizontalPaddingXSmall,
                                  LMChatText(
                                    _fileExtension.toUpperCase(),
                                    style: const LMChatTextStyle(
                                      textAlign: TextAlign.left,
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        color: LMChatDefaultTheme.greyColor,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        kHorizontalPaddingXSmall,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getDocumentTileShimmer();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class DocumentTile extends StatefulWidget {
  final LMChatMediaModel media;

  const DocumentTile({
    super.key,
    required this.media,
  });

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  String? _fileName;
  final String _fileExtension = 'pdf';
  String? _fileSize;
  File? file;
  Future? loadedFile;

  Future loadFile() async {
    File file;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile!;
    } else {
      final String url = widget.media.mediaUrl!;
      file = File(url);
    }
    _fileSize = getFileSizeString(bytes: widget.media.size!);
    _fileName = basenameWithoutExtension(file.path);
    return file;
  }

  @override
  void initState() {
    super.initState();
    loadedFile = loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadedFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return InkWell(
              onTap: () async {
                if (widget.media.mediaFile != null) {
                  OpenFilex.open(widget.media.mediaFile!.path);
                } else {
                  debugPrint(widget.media.mediaUrl);
                  Uri fileUrl = Uri.parse(widget.media.mediaUrl!);
                  launchUrl(fileUrl, mode: LaunchMode.externalApplication);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: kPaddingSmall),
                child: Container(
                  height: 70,
                  width: 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: LMChatDefaultTheme.greyColor),
                    borderRadius: BorderRadius.circular(kBorderRadiusMedium),
                    color: LMChatTheme.theme.container.withOpacity(0.8),
                  ),
                  padding: const EdgeInsets.symmetric(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kHorizontalPaddingMedium,
                      const LMChatIcon(
                        type: LMChatIconType.icon,
                        icon: Icons.insert_drive_file,
                        style: LMChatIconStyle(
                          size: 32,
                          boxSize: 32,
                          boxPadding: EdgeInsets.zero,
                          color: LMChatDefaultTheme.greyColor,
                        ),
                      ),
                      kHorizontalPaddingMedium,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LMChatText(
                              _fileName ?? '',
                              style: const LMChatTextStyle(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: LMChatDefaultTheme.greyColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            kVerticalPaddingSmall,
                            Row(
                              children: [
                                widget.media.pageCount != null
                                    ? Row(
                                        children: <Widget>[
                                          widget.media.pageCount == null
                                              ? const SizedBox()
                                              : kHorizontalPaddingXSmall,
                                          widget.media.pageCount == null
                                              ? const SizedBox()
                                              : LMChatText(
                                                  "${widget.media.pageCount!} ${widget.media.pageCount! > 1 ? "Pages" : "Page"}",
                                                  style: const LMChatTextStyle(
                                                    textStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: LMChatDefaultTheme
                                                          .greyColor,
                                                    ),
                                                  ),
                                                ),
                                          kHorizontalPaddingXSmall,
                                          const LMChatText(
                                            '·',
                                            style: LMChatTextStyle(
                                              textStyle: TextStyle(
                                                fontSize: 10,
                                                color: LMChatDefaultTheme
                                                    .greyColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                kHorizontalPaddingXSmall,
                                LMChatText(
                                  _fileSize!.toUpperCase(),
                                  style: const LMChatTextStyle(
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                      color: LMChatDefaultTheme.greyColor,
                                    ),
                                  ),
                                ),
                                kHorizontalPaddingXSmall,
                                const LMChatText(
                                  '·',
                                  style: LMChatTextStyle(
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                      color: LMChatDefaultTheme.greyColor,
                                    ),
                                  ),
                                ),
                                kHorizontalPaddingXSmall,
                                LMChatText(
                                  _fileExtension.toUpperCase(),
                                  style: const LMChatTextStyle(
                                    textStyle: TextStyle(
                                      fontSize: 10,
                                      color: LMChatDefaultTheme.greyColor,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return getDocumentTileShimmer();
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

// ChatBubble for Single Document Attachment
Widget getSingleDocPreview(LMChatMediaModel media) {
  return DocumentThumbnailFile(
    media: media,
  );
}

Widget documentPreviewFactory(List<LMChatMediaModel> mediaList) {
  switch (mediaList.length) {
    case 1:
      return getSingleDocPreview(mediaList.first);
    case 2:
      return getDualDocPreview(mediaList);
    default:
      return GetMultipleDocPreview(mediaList: mediaList);
  }
}

// ChatBubble for Two Document Attachment
/// A widget to display a list of two documents in a chat bubble.
///
/// The list of documents is passed as a parameter to this function.
/// The widget is a column with two document tiles.
/// The media list is expected to have two elements.
///
Widget getDualDocPreview(List<LMChatMediaModel> mediaList) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      DocumentTile(
        media: mediaList.first,
      ),
      DocumentTile(
        media: mediaList[1],
      )
    ],
  );
}

Widget getDocumentTileShimmer() {
  return Container(
    height: 78,
    width: 60.w,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        border: Border.all(color: LMChatDefaultTheme.greyColor, width: 1),
        borderRadius: BorderRadius.circular(kBorderRadiusMedium)),
    padding: const EdgeInsets.all(kPaddingLarge),
    child: Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
          height: 10.w,
          width: 10.w,
          color: LMChatTheme.theme.container,
        ),
        kHorizontalPaddingLarge,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: 30.w,
              color: LMChatTheme.theme.container,
            ),
            kVerticalPaddingMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 6,
                  width: 10.w,
                  color: LMChatTheme.theme.container,
                ),
                kHorizontalPaddingXSmall,
                Text(
                  '·',
                  style: TextStyle(
                    fontSize: kFontSmall,
                    color: LMChatTheme.theme.disabledColor,
                  ),
                ),
                kHorizontalPaddingXSmall,
                Container(
                  height: 6,
                  width: 10.w,
                  color: LMChatTheme.theme.container,
                ),
              ],
            )
          ],
        )
      ]),
    ),
  );
}

// ChatBubble for more than two Document Attachment

class GetMultipleDocPreview extends StatefulWidget {
  final List<LMChatMediaModel> mediaList;
  const GetMultipleDocPreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<GetMultipleDocPreview> createState() => GgetMultipleDocPreviewState();
}

class GgetMultipleDocPreviewState extends State<GetMultipleDocPreview> {
  List<LMChatMediaModel>? mediaList;
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  int length = 2;

  void onMoreButtonTap() {
    length = mediaList!.length;
    rebuildCurr.value = !rebuildCurr.value;
  }

  @override
  Widget build(BuildContext context) {
    mediaList = widget.mediaList;
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (context, index) => DocumentTile(
                media: mediaList![index],
              ),
            ),
            mediaList!.length > 2 && mediaList!.length != length
                ? const SizedBox(height: 8)
                : const SizedBox(),
            mediaList!.length > 2 && mediaList!.length != length
                ? GestureDetector(
                    onTap: onMoreButtonTap,
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      width: 72,
                      height: 24,
                      child: LMChatText(
                        '+ ${mediaList!.length - 2} more',
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            color: LMChatTheme.theme.secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}

class DocumentFactory extends StatefulWidget {
  final List<LMChatMediaModel> mediaList;
  const DocumentFactory({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<DocumentFactory> createState() => _DocumentFactoryState();
}

class _DocumentFactoryState extends State<DocumentFactory> {
  List<LMChatMediaModel>? mediaList;
  final TextEditingController _textEditingController = TextEditingController();
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  List<LMChatTagViewData> tags = [];
  String? result;
  int currPosition = 0;

  bool checkIfMultipleAttachments() {
    return mediaList!.length > 1;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    rebuildCurr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaList = widget.mediaList;
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 65.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getDocumentThumbnail(
                    mediaList![currPosition].mediaFile!,
                    size: Size(100.w, 52.h),
                  ),
                  kVerticalPaddingXLarge,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 80.w,
                        child: LMChatText(
                          basenameWithoutExtension(
                              mediaList![currPosition].mediaFile!.path),
                          style: const LMChatTextStyle(
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      kVerticalPaddingSmall,
                      getDocumentDetails(mediaList![currPosition]),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: LMChatTheme.theme.container,
                  border: const Border(
                    top: BorderSide(
                      color: LMChatDefaultTheme.greyColor,
                      width: 0.1,
                    ),
                  )),
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 2.h,
                bottom: 12.h,
              ),
              child: Column(
                children: [
                  checkIfMultipleAttachments()
                      ? SizedBox(
                          height: 15.w,
                          width: 100.w,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: mediaList!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                currPosition = index;
                                rebuildCurr.value = !rebuildCurr.value;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 6.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: currPosition == index
                                        ? Border.all(
                                            color: LMChatTheme
                                                .theme.secondaryColor,
                                            width: 5.0,
                                          )
                                        : null),
                                width: 15.w,
                                height: 15.w,
                                child: getDocumentThumbnail(
                                    mediaList![index].mediaFile!,
                                    size: Size(100.w, 58.h)),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
