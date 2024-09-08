import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/shimmers/document_shimmer.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

///{@template lm_chat_document_tile}
/// A widget that displays a tile for a document.
///{@endtemplate}
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

  ///{@macro lm_chat_document_tile}
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
    _fileSize = getFileSizeString(
        bytes: widget.media.size ?? widget.media.meta?['size'] ?? 0);
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
            return const LMChatDocumentShimmer();
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
                          style: style.subtitleStyle ??
                              const LMChatTextStyle(
                                textStyle: TextStyle(
                                  fontSize: 10,
                                  color: LMChatDefaultTheme.greyColor,
                                ),
                              ),
                        ),
                  kHorizontalPaddingXSmall,
                  LMChatText(
                    '·',
                    style: style.subtitleStyle ??
                        const LMChatTextStyle(
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
          style: style.subtitleStyle ??
              const LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: LMChatDefaultTheme.greyColor,
                ),
              ),
        ),
        kHorizontalPaddingXSmall,
        LMChatText(
          '·',
          style: style.subtitleStyle ??
              const LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: LMChatDefaultTheme.greyColor,
                ),
              ),
        ),
        kHorizontalPaddingXSmall,
        LMChatText(
          _fileExtension.toUpperCase(),
          style: style.subtitleStyle ??
              const LMChatTextStyle(
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
      style: style.titleStyle ??
          const LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: 12,
              color: LMChatDefaultTheme.greyColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
    );
  }

  LMChatIcon _defaultDocumentIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.picture_as_pdf_outlined,
      style: style.iconStyle ??
          LMChatIconStyle(
            size: 28,
            boxSize: 32,
            boxPadding: EdgeInsets.zero,
            color: style.iconColor ?? LMChatDefaultTheme.greyColor,
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

  /// The style for the document icon in the document tile.
  final LMChatIconStyle? iconStyle;

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
    this.iconStyle,
    this.textColor,
    this.titleStyle,
    this.subtitleStyle,
  });
}
