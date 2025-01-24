import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
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
  final Widget? documentIcon;

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

  /// Creates a copy of this widget with the given parameters replaced.
  LMChatDocumentTile copyWith({
    LMChatMediaModel? media,
    Widget? title,
    Widget? subtitle,
    Widget? documentIcon,
    LMChatDocumentTileStyle? style,
  }) {
    return LMChatDocumentTile(
      media: media ?? this.media,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      documentIcon: documentIcon ?? this.documentIcon,
      style: style ?? this.style,
    );
  }

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
      final String path = await downloadFile(media: widget.media);
      file = File(path);
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
                // get the file path and open the file
                final filePath = (snapshot.data as File).path;
                OpenFile.open(filePath, type: 'application/pdf');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kPaddingXSmall,
                ),
                child: Container(
                  height: style.height ?? 60,
                  width: style.width ?? 55.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: LMChatDefaultTheme.greyColor),
                    borderRadius: BorderRadius.circular(kBorderRadiusMedium),
                    color: LMChatTheme.theme.container,
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
            return LMChatDocumentShimmer(style: style.shimmerStyle);
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
      type: LMChatIconType.svg,
      assetPath: kDocumentIcon,
      style: style.iconStyle ??
          LMChatIconStyle(
            size: 28,
            boxSize: 32,
            boxPadding: EdgeInsets.zero,
            color: style.iconColor,
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

  /// The style class for the shimmer shown while loading
  final LMChatDocumentShimmerStyle? shimmerStyle;

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
    this.shimmerStyle,
  });

  /// Creates a copy of the current style with the given parameters.
  LMChatDocumentTileStyle copyWith({
    double? height,
    double? width,
    Border? border,
    BorderRadius? borderRadius,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisAlignment? rowMainAxisAlignment,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? iconColor,
    LMChatIconStyle? iconStyle,
    Color? textColor,
    LMChatTextStyle? titleStyle,
    LMChatTextStyle? subtitleStyle,
    LMChatDocumentShimmerStyle? shimmerStyle,
  }) {
    return LMChatDocumentTileStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      rowMainAxisAlignment: rowMainAxisAlignment ?? this.rowMainAxisAlignment,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      iconStyle: iconStyle ?? this.iconStyle,
      textColor: textColor ?? this.textColor,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      shimmerStyle: shimmerStyle ?? this.shimmerStyle,
    );
  }

  /// A factory constructor that returns a basic instance of [LMChatDocumentTileStyle].
  factory LMChatDocumentTileStyle.basic() {
    return LMChatDocumentTileStyle(
      height: 100.0,
      width: 100.0,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      rowMainAxisAlignment: MainAxisAlignment.start,
      padding: const EdgeInsets.all(8.0),
      backgroundColor: Colors.white,
      iconColor: Colors.black,
      textColor: Colors.black,
      titleStyle: LMChatTextStyle.basic(),
      subtitleStyle: LMChatTextStyle.basic(),
      shimmerStyle: LMChatDocumentShimmerStyle.basic(),
    );
  }
}
