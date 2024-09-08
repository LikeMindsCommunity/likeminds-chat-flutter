import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays a thumbnail for a document.
class LMChatDocumentThumbnail extends StatefulWidget {
  /// The document to display.
  final LMChatMediaModel media;

  const LMChatDocumentThumbnail({
    super.key,
    required this.media,
  });

  @override
  State<LMChatDocumentThumbnail> createState() =>
      _LMChatDocumentThumbnailState();
}

/// The state for the LMChatDocumentThumbnail widget.
class _LMChatDocumentThumbnailState extends State<LMChatDocumentThumbnail> {
  /// The URL of the file.
  String? url;

  /// The file object.
  File? file;

  /// A future that loads the file.
  Future? loadedFile;

  /// The widget that displays the document file.
  Widget? documentFile;

  /// Loads the file from the URL or local storage.
  Future loadFile() async {
    url = widget.media.mediaUrl;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile;
      // _fileName = basenameWithoutExtension(file!.path);
    } else {
      final String url = widget.media.mediaUrl!;
      // _fileName = basenameWithoutExtension(url);
      file = await DefaultCacheManager().getSingleFile(url);
    }

    // _fileSize = getFileSizeString(bytes: widget.media.size ?? 0);
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
              size: Size(pageSize.width, pageSize.height),
            ),
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
                  child: LMChatDocumentTile(
                    media: widget.media,
                    style: LMChatDocumentTileStyle(
                      padding: EdgeInsets.zero,
                      width: 54.w,
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

/// A widget that displays a tile for a document.
class LMChatDocumentTile extends StatefulWidget {
  /// The document to display.
  final LMChatMediaModel media;

  /// The title of the document.
  final Widget? title;

  /// The subtitle of the document.
  final Widget? subtitle;

  /// The icon to display for the document.
  final LMChatIcon? documentIcon;

  /// The style for the document tile.
  final LMChatDocumentTileStyle? style;

  const LMChatDocumentTile({
    super.key,
    required this.media,
    this.style,
    this.title,
    this.subtitle,
    this.documentIcon,
  });

  @override
  State<LMChatDocumentTile> createState() => _LMChatDocumentTileState();
}

/// The state for the LMChatDocumentTile widget.
class _LMChatDocumentTileState extends State<LMChatDocumentTile> {
  /// The name of the file.
  String? _fileName;

  /// The extension of the file.
  final String _fileExtension = 'pdf';

  /// The size of the file.
  String? _fileSize;

  /// A future that loads the file.
  Future? loadedFile;

  late LMChatDocumentTileStyle style;

  /// Loads the file from the URL or local storage.
  Future loadFile() async {
    File file;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile!;
    } else {
      final String url = widget.media.mediaUrl!;
      file = File(url);
    }
    _fileSize = getFileSizeString(bytes: widget.media.size ?? 0);
    _fileName = basenameWithoutExtension(file.path);
    return file;
  }

  @override
  void initState() {
    super.initState();
    loadedFile = loadFile();
    style = widget.style ?? LMChatDocumentTileStyle();
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
                padding: const EdgeInsets.symmetric(
                  vertical: kPaddingXSmall,
                ),
                child: Container(
                  height: style.height ?? 72,
                  width: style.width ?? 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: LMChatDefaultTheme.greyColor),
                    borderRadius: BorderRadius.circular(kBorderRadiusMedium),
                    color: LMChatTheme.theme.container.withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: style.padding ??
                        const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: kPaddingXSmall,
                        ),
                    child: Row(
                      mainAxisAlignment: style.rowMainAxisAlignment ??
                          MainAxisAlignment.center,
                      children: [
                        kHorizontalPaddingMedium,
                        widget.documentIcon ?? _defaultDocumentIcon(),
                        kHorizontalPaddingMedium,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: style.crossAxisAlignment ??
                                CrossAxisAlignment.start,
                            mainAxisAlignment: style.mainAxisAlignment ??
                                MainAxisAlignment.center,
                            children: [
                              widget.title ?? _defaultTitle(),
                              kVerticalPaddingSmall,
                              widget.subtitle ?? _defaultSubtitle()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return getDocumentTileShimmer();
          }
        });
  }

  Row _defaultSubtitle() {
    return Row(
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
    );
  }

  LMChatText _defaultTitle() {
    return LMChatText(
      _fileName ?? '',
      style: const LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 12,
          color: LMChatDefaultTheme.greyColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  LMChatIcon _defaultDocumentIcon() {
    return const LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.picture_as_pdf_outlined,
      style: LMChatIconStyle(
        size: 28,
        boxSize: 32,
        boxPadding: EdgeInsets.zero,
        color: LMChatDefaultTheme.greyColor,
      ),
    );
  }
}

/// Defines the style properties for a document tile in the LMChat UI.
class LMChatDocumentTileStyle {
  /// The height of the document tile.
  final double? height;

  /// The width of the document tile.
  final double? width;

  /// The border of the document tile.
  final Border? border;

  /// The border radius of the document tile.
  final BorderRadius? borderRadius;

  /// The cross-axis alignment of the document tile's content.
  final CrossAxisAlignment? crossAxisAlignment;

  /// The main-axis alignment of the document tile's content.
  final MainAxisAlignment? mainAxisAlignment;

  /// The main-axis alignment of the row within the document tile.
  final MainAxisAlignment? rowMainAxisAlignment;

  /// The padding of the document tile.
  final EdgeInsets? padding;

  /// The background color of the document tile.
  final Color? backgroundColor;

  /// The color of the icon in the document tile.
  final Color? iconColor;

  /// The color of the text in the document tile.
  final Color? textColor;

  /// The style for the title text in the document tile.
  final LMChatTextStyle? titleStyle;

  /// The style for the subtitle text in the document tile.
  final LMChatTextStyle? subtitleStyle;

  /// Constructor for LMChatDocumentTileStyle.
  LMChatDocumentTileStyle({
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.rowMainAxisAlignment,
    this.padding,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.titleStyle,
    this.subtitleStyle,
  });
}

/// Factory function that returns a widget to display a document preview.
Widget documentPreviewFactory(List<LMChatMediaModel> mediaList) {
  switch (mediaList.length) {
    case 1:
      return LMChatDocumentThumbnail(media: mediaList.first);
    default:
      return GetMultipleDocPreview(mediaList: mediaList);
  }
}

/// Returns a shimmer effect for a document tile.
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

/// A widget that displays multiple document previews.
class GetMultipleDocPreview extends StatefulWidget {
  /// The list of documents to display.
  final List<LMChatMediaModel> mediaList;

  const GetMultipleDocPreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<GetMultipleDocPreview> createState() => GetMultipleDocPreviewState();
}

/// The state for the GetMultipleDocPreview widget.
class GetMultipleDocPreviewState extends State<GetMultipleDocPreview> {
  /// The list of documents to display.
  List<LMChatMediaModel>? mediaList;

  /// A notifier that triggers a rebuild of the widget.
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);

  /// The number of documents to display initially.
  int length = 2;

  /// Callback for when the "more" button is tapped.
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
              itemBuilder: (context, index) => LMChatDocumentTile(
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

/// A widget that displays a document preview with multiple attachments.
class LMChatDocumentPreview extends StatefulWidget {
  /// The list of documents to display.
  final List<LMChatMediaModel> mediaList;

  const LMChatDocumentPreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<LMChatDocumentPreview> createState() => _LMChatDocumentPreviewState();
}

/// The state for the DocumentFactory widget.
class _LMChatDocumentPreviewState extends State<LMChatDocumentPreview> {
  /// The list of documents to display.
  List<LMChatMediaModel>? mediaList;

  /// A notifier that triggers a rebuild of the widget.
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);

  /// The result of the document preview.
  String? result;

  /// The current position in the list of documents.
  int currPosition = 0;

  /// Checks if there are multiple attachments.
  bool checkIfMultipleAttachments() {
    return mediaList!.length > 1;
  }

  @override
  void dispose() {
    rebuildCurr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    mediaList = widget.mediaList;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 60.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: getDocumentThumbnail(
                      mediaList![currPosition].mediaFile!,
                    ),
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
                bottom: 2.h,
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
                                            width: 3.0,
                                          )
                                        : null),
                                width: 15.w,
                                height: 15.w,
                                child: getDocumentThumbnail(
                                  mediaList![index].mediaFile!,
                                ),
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
