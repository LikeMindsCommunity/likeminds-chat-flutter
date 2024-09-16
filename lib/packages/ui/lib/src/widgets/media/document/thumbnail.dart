import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/shimmers/document_shimmer.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

///{@template lm_chat_document}
/// A widget that displays a thumbnail for a document.
/// {@endtemplate}
class LMChatDocumentThumbnail extends StatefulWidget {
  /// The document to display.
  final LMChatMediaModel media;

  /// The overlay tile widget to show on top of the thumbnail
  final LMChatDocumentTile? overlay;

  /// The style class for this thumbnail widget
  final LMChatDocumentThumbnailStyle? style;

  /// Bool to control whether to show tile overlay or not
  final bool showOverlay;

  ///{@macro lm_chat_document}
  const LMChatDocumentThumbnail({
    super.key,
    required this.media,
    this.showOverlay = false,
    this.style,
    this.overlay,
  });

  /// Creates a copy of this widget with the given parameters replaced.
  LMChatDocumentThumbnail copyWith({
    LMChatMediaModel? media,
    LMChatDocumentTile? overlay,
    LMChatDocumentThumbnailStyle? style,
    bool? showOverlay,
  }) {
    return LMChatDocumentThumbnail(
      media: media ?? this.media,
      overlay: overlay ?? this.overlay,
      style: style ?? this.style,
      showOverlay: showOverlay ?? this.showOverlay,
    );
  }

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

  /// Style class for thumbnail widget
  LMChatDocumentThumbnailStyle? style;

  @override
  void initState() {
    super.initState();
    style = widget.style;
    loadedFile = loadFile();
  }

  @override
  void didUpdateWidget(LMChatDocumentThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    style = widget.style;
    if (oldWidget.media.mediaUrl != widget.media.mediaUrl) {
      loadedFile = loadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadedFile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return AbsorbPointer(
            absorbing: widget.media.mediaUrl == null,
            child: InkWell(
              onTap: () async {
                if (widget.media.mediaUrl != null) {
                  Uri fileUrl = Uri.parse(widget.media.mediaUrl!);
                  launchUrl(fileUrl, mode: LaunchMode.externalApplication);
                }
              },
              child: Stack(
                children: [
                  SizedBox(
                    child: documentFile!,
                  ),
                  widget.showOverlay
                      ? widget.overlay ??
                          Positioned(
                            bottom: 0,
                            child: LMChatDocumentTile(
                              media: widget.media,
                              style: style?.overlayStyle ??
                                  LMChatDocumentTileStyle(
                                    padding: EdgeInsets.zero,
                                    width: 54.w,
                                  ),
                            ),
                          )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LMChatDocumentShimmer(
            style: style?.shimmerStyle,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

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
          height: style?.height,
          width: style?.width,
          clipBehavior: Clip.hardEdge,
          padding: style?.padding,
          decoration: BoxDecoration(
            borderRadius: style?.borderRadius ??
                const BorderRadius.all(
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
}

/// Defines the style properties for a document tile in the LMChat UI.
class LMChatDocumentThumbnailStyle {
  /// The height of the document thumbnail.
  final double? height;

  /// The width of the document thumbnail.
  final double? width;

  /// The border of the document thumbnail.
  final Border? border;

  /// The border radius of the document thumbnail.
  final BorderRadius? borderRadius;

  /// The padding of the document thumbnail.
  final EdgeInsets? padding;

  /// The background color of the document thumbnail.
  final Color? backgroundColor;

  /// The style for the overlay document thumbnail style
  final LMChatDocumentTileStyle? overlayStyle;

  /// The style for the shimmer widget shown
  final LMChatDocumentShimmerStyle? shimmerStyle;

  /// Constructor for LMChatDocumentThumbnailStyle.
  LMChatDocumentThumbnailStyle({
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.overlayStyle,
    this.shimmerStyle,
  });

  /// Creates a copy of the current style with the given parameters.
  LMChatDocumentThumbnailStyle copyWith({
    double? height,
    double? width,
    Border? border,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Color? backgroundColor,
    LMChatDocumentTileStyle? overlayStyle,
    LMChatDocumentShimmerStyle? shimmerStyle,
  }) {
    return LMChatDocumentThumbnailStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayStyle: overlayStyle ?? this.overlayStyle,
      shimmerStyle: shimmerStyle ?? this.shimmerStyle,
    );
  }

  /// A factory constructor that returns a basic instance of [LMChatDocumentThumbnailStyle].
  factory LMChatDocumentThumbnailStyle.basic() {
    return LMChatDocumentThumbnailStyle(
      height: 100.0,
      width: 100.0,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
      padding: const EdgeInsets.all(8.0),
      backgroundColor: Colors.white,
      overlayStyle: LMChatDocumentTileStyle.basic(),
      shimmerStyle: LMChatDocumentShimmerStyle.basic(),
    );
  }
}
