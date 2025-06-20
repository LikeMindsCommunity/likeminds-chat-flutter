import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

///{@template lm_chat_document_preview}
/// A widget that displays a document preview with single attachment.
/// {@endtemplate}
class LMChatDocumentPreview extends StatefulWidget {
  /// The list of documents to display.
  final LMChatMediaModel media;

  /// The style for the document preview.
  final LMChatDocumentPreviewStyle? style;

  ///{@macro lm_chat_document_preview}
  const LMChatDocumentPreview({
    super.key,
    required this.media,
    this.style,
  });

  /// Creates a copy of this [LMChatDocumentPreview] but with the given fields replaced with the new values.
  LMChatDocumentPreview copyWith({
    LMChatMediaModel? media,
    LMChatDocumentPreviewStyle? style,
  }) {
    return LMChatDocumentPreview(
      media: media ?? this.media,
      style: style ?? this.style,
    );
  }

  @override
  State<LMChatDocumentPreview> createState() => _LMChatDocumentPreviewState();
}

/// The state for the DocumentFactory widget.
class _LMChatDocumentPreviewState extends State<LMChatDocumentPreview> {
  /// The list of documents to display.
  LMChatMediaModel? media;

  /// The result of the document preview.
  String? result;

  @override
  void initState() {
    super.initState();
    media = widget.media;
  }

  @override
  void didUpdateWidget(covariant LMChatDocumentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    media = widget.media;
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? LMChatDocumentPreviewStyle.basic();
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: style.borderRadius,
            ),
            clipBehavior: Clip.hardEdge,
            padding: style.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: LMChatDocumentThumbnail(
                    media: media!,
                    style: style.thumbnailStyle ??
                        LMChatDocumentThumbnailStyle.basic().copyWith(
                          width: size.width,
                          height: size.height * 0.8,
                        ),
                  ),
                ),
                kVerticalPaddingXLarge,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///{@template lm_chat_document_tile_preview}
/// A widget that displays multiple document previews.
/// {@endtemplate}
class LMChatDocumentTilePreview extends StatefulWidget {
  /// The list of documents to display.
  final List<LMChatMediaModel> mediaList;

  /// The style for the document tile preview.
  final LMChatDocumentTilePreviewStyle? style;

  ///{@macro lm_chat_document_tile_preview}
  const LMChatDocumentTilePreview({
    super.key,
    required this.mediaList,
    this.style,
  });

  @override
  State<LMChatDocumentTilePreview> createState() =>
      LMChatDocumentTilePreviewState();
}

/// The state for the GetMultipleDocPreview widget.
class LMChatDocumentTilePreviewState extends State<LMChatDocumentTilePreview> {
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
    final style = widget.style ?? LMChatDocumentTilePreviewStyle.basic();
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Container(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: style.borderRadius,
          ),
          padding: style.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) => LMChatDocumentTile(
                  media: mediaList![index],
                  style: style.tileStyle,
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
                        width: 64,
                        height: 24,
                        child: LMChatText(
                          '+ ${mediaList!.length - 2} more',
                          style: style.moreButtonStyle ??
                              LMChatTextStyle(
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
          ),
        );
      },
    );
  }
}

/// Defines the style properties for the LMChatDocumentPreview widget.
class LMChatDocumentPreviewStyle {
  /// Creates an LMChatDocumentPreviewStyle instance.
  const LMChatDocumentPreviewStyle({
    this.maxWidth,
    this.maxHeight,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.thumbnailStyle,
    this.fileNameStyle,
    this.detailsStyle,
  });

  /// The maximum width of the preview container.
  final double? maxWidth;

  /// The maximum height of the preview container.
  final double? maxHeight;

  /// The background color of the preview container.
  final Color? backgroundColor;

  /// The border radius of the preview container.
  final BorderRadius? borderRadius;

  /// The padding of the preview container.
  final EdgeInsets? padding;

  /// The style for the document thumbnail.
  final LMChatDocumentThumbnailStyle? thumbnailStyle;

  /// The style for the file name text.
  final LMChatTextStyle? fileNameStyle;

  /// The style for the document details.
  final LMChatTextStyle? detailsStyle;

  /// Creates a basic LMChatDocumentPreviewStyle with default values.
  factory LMChatDocumentPreviewStyle.basic() {
    return LMChatDocumentPreviewStyle(
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(16),
      fileNameStyle: const LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Creates a copy of this LMChatDocumentPreviewStyle but with the given fields replaced with the new values.
  LMChatDocumentPreviewStyle copyWith({
    double? maxWidth,
    double? maxHeight,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    LMChatDocumentThumbnailStyle? thumbnailStyle,
    LMChatTextStyle? fileNameStyle,
    LMChatTextStyle? detailsStyle,
  }) {
    return LMChatDocumentPreviewStyle(
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      thumbnailStyle: thumbnailStyle ?? this.thumbnailStyle,
      fileNameStyle: fileNameStyle ?? this.fileNameStyle,
      detailsStyle: detailsStyle ?? this.detailsStyle,
    );
  }
}

/// Defines the style properties for the LMChatDocumentTilePreview widget.
class LMChatDocumentTilePreviewStyle {
  /// Creates an LMChatDocumentTilePreviewStyle instance.
  const LMChatDocumentTilePreviewStyle({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.tileStyle,
    this.moreButtonStyle,
  });

  /// The background color of the tile preview container.
  final Color? backgroundColor;

  /// The border radius of the tile preview container.
  final BorderRadius? borderRadius;

  /// The padding of the tile preview container.
  final EdgeInsets? padding;

  /// The style for individual document tiles.
  final LMChatDocumentTileStyle? tileStyle;

  /// The style for the "more" button.
  final LMChatTextStyle? moreButtonStyle;

  /// Creates a basic LMChatDocumentTilePreviewStyle with default values.
  factory LMChatDocumentTilePreviewStyle.basic() {
    return LMChatDocumentTilePreviewStyle(
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(8),
    );
  }

  /// Creates a copy of this LMChatDocumentTilePreviewStyle but with the given fields replaced with the new values.
  LMChatDocumentTilePreviewStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    LMChatDocumentTileStyle? tileStyle,
    LMChatTextStyle? moreButtonStyle,
  }) {
    return LMChatDocumentTilePreviewStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      tileStyle: tileStyle ?? this.tileStyle,
      moreButtonStyle: moreButtonStyle ?? this.moreButtonStyle,
    );
  }
}
