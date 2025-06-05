import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:photo_view/photo_view.dart';

/// {@template lm_chat_image}
/// A widget to display an image in a post.
/// The image can be fetched from a URL or from a file.
/// The [LMChatImage] can be customized by passing in the required parameters
/// and can be used in a post.
/// The image can be tapped to perform an action.
/// The image can be customized by passing in the required parameters
/// and can be used in a post.
/// {@endtemplate}
class LMChatImage extends StatefulWidget {
  ///{@macro lm_chat_image}
  const LMChatImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.imageBytes,
    this.imageAssetPath,
    this.onError,
    this.style,
    this.onTap,
  }) : assert(imageUrl != null ||
            imageFile != null ||
            imageAssetPath != null ||
            imageBytes != null);

  /// The URL of the image (image from network)
  final String? imageUrl;

  /// The file of the image (image from file)
  final File? imageFile;

  /// The Uni8List of the image (image from bytes)
  final Uint8List? imageBytes;

  /// The path of the image (image from asset)
  final String? imageAssetPath;

  /// {@macro chat_error_handler}
  final LMChatErrorHandler? onError;

  /// The style class of this widget, used for customisation
  final LMChatImageStyle? style;

  /// onTap callback for the widget; triggered when tapped
  final VoidCallback? onTap;

  @override
  State<LMChatImage> createState() => _LMImageState();

  /// copyWith function that returns a new instance of LMChatImage
  /// with the values copied from the old one.
  LMChatImage copyWith({
    String? imageUrl,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageAssetPath,
    LMChatImageStyle? style,
    LMChatErrorHandler? onError,
    VoidCallback? onTap,
  }) {
    return LMChatImage(
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      imageBytes: imageBytes ?? this.imageBytes,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      style: style ?? this.style,
      onError: onError ?? this.onError,
      onTap: onTap ?? this.onTap,
    );
  }
}

class _LMImageState extends State<LMChatImage> {
  LMChatImageStyle? style;
  late Size size;

  // Determines if the image is an SVG image based on the file extension of the URL
  bool _isSvgImage() {
    return widget.imageUrl != null && widget.imageUrl!.endsWith('.svg');
  }

  /// Initializes the state of the widget by setting up the style
  @override
  void initState() {
    super.initState();
    style = widget.style ?? LMChatTheme.theme.imageStyle;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.sizeOf(context);
  }

  /// Builds the widget tree for the image widget
  /// Returns a GestureDetector that handles tap events
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: _buildImageWidget(),
    );
  }

  /// Determines which type of image to build based on the provided source
  /// Returns the appropriate image widget for URL, File, or Asset images
  Widget _buildImageWidget() {
    if (widget.imageBytes != null) {
      return _buildBytesImage();
    }
    if (widget.imageUrl != null) {
      return _buildNetworkImage();
    }
    if (widget.imageFile != null) {
      return _buildFileImage();
    }
    if (widget.imageAssetPath != null) {
      return _buildAssetImage();
    }
    return const SizedBox();
  }

  /// Builds a PhotoView widget with proper scaling based on image dimensions
  ///
  /// Parameters:
  /// - imageProvider: The provider for the image source
  /// - context: The build context
  /// - imageWidth: The width of the image
  /// - imageHeight: The height of the image
  ///
  /// Returns a PhotoView widget with calculated scaling parameters
  Widget _buildPhotoView({
    required ImageProvider imageProvider,
    required BuildContext context,
    required double imageWidth,
    required double imageHeight,
  }) {
    // Calculate container dimensions
    final containerWidth = style?.width ?? size.width;
    final containerHeight = style?.height ?? size.height * 0.8;

    // Calculate scale to fit
    final double scaleX = containerWidth / imageWidth;
    final double scaleY = containerHeight / imageHeight;
    final double minScale = scaleX < scaleY ? scaleX : scaleY;

    return PhotoView(
      imageProvider: imageProvider,
      maxScale: 3.0,
      minScale: minScale,
      initialScale: minScale,
      tightMode: true,
    );
  }

  /// Builds a widget for displaying network images
  /// Uses CachedNetworkImage for efficient loading and caching
  /// Returns a Container with the network image
  Widget _buildNetworkImage() {
    return Container(
      padding: style?.padding,
      margin: style?.margin,
      decoration: BoxDecoration(
        borderRadius: style!.borderRadius ?? BorderRadius.zero,
        color: style?.backgroundColor,
      ),
      clipBehavior: Clip.hardEdge,
      child: _isSvgImage()
          ? SvgPicture.network(
              widget.imageUrl!,
              height: style?.height,
              width: style?.width,
              fit: style?.boxFit ?? BoxFit.contain,
              placeholderBuilder: (context) {
                return style!.loaderWidget ??
                    LMChatMediaShimmerWidget(
                      height: style!.height,
                      width: style!.width ?? size.width,
                    );
              },
              // errorBuilder: (context, error, stackTrace) {
              //   debugPrint('Error loading image: $error');
              //   if (widget.onError != null) {
              //     widget.onError!(error.toString(), StackTrace.empty);
              //   }
              //   return style!.errorWidget ?? _defaultErrorWidget();
              // },
            )
          : CachedNetworkImage(
              cacheKey: widget.imageUrl!,
              height: style?.height,
              width: style?.width,
              imageUrl: widget.imageUrl!,
              fit: style?.boxFit ?? BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 100),
              imageBuilder: (context, imageProvider) {
                ImageStream stream =
                    imageProvider.resolve(ImageConfiguration.empty);
                late ImageInfo imageInfo;

                return FutureBuilder(
                  future: Future(() async {
                    Completer<void> completer = Completer();
                    stream.addListener(
                      ImageStreamListener((info, _) {
                        imageInfo = info;
                        completer.complete();
                      }),
                    );
                    await completer.future;
                    return imageInfo;
                  }),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final imageInfo = snapshot.data as ImageInfo;
                    return _buildPhotoView(
                      imageProvider: imageProvider,
                      context: context,
                      imageWidth: imageInfo.image.width.toDouble(),
                      imageHeight: imageInfo.image.height.toDouble(),
                    );
                  },
                );
              },
              errorWidget: (context, url, error) {
                debugPrint('Error loading image: $error');
                if (widget.onError != null) {
                  widget.onError!(error.toString(), StackTrace.empty);
                }
                return style!.errorWidget ?? _defaultErrorWidget();
              },
              progressIndicatorBuilder: (context, url, progress) =>
                  style!.shimmerWidget ??
                  LMChatMediaShimmerWidget(
                    height: style!.height,
                    width: style!.width ?? size.width,
                  ),
            ),
    );
  }

  /// Builds a widget for displaying images from local files
  /// Uses FutureBuilder to handle async loading of image dimensions
  /// Returns a Container with the file image
  Widget _buildFileImage() {
    return Container(
      padding: style?.padding,
      margin: style?.margin,
      decoration: BoxDecoration(
        borderRadius: style!.borderRadius ?? BorderRadius.zero,
        color: style?.backgroundColor,
      ),
      child: FutureBuilder<ui.Image>(
        future: _getImageDimensions(FileImage(widget.imageFile!)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildPhotoView(
            imageProvider: FileImage(widget.imageFile!),
            context: context,
            imageWidth: snapshot.data!.width.toDouble(),
            imageHeight: snapshot.data!.height.toDouble(),
          );
        },
      ),
    );
  }

  /// Builds a widget for displaying images from bytes
  /// Returns a Container with the bytes image
  Widget _buildBytesImage() {
    return Container(
      padding: style?.padding,
      margin: style?.margin,
      decoration: BoxDecoration(
        borderRadius: style!.borderRadius ?? BorderRadius.zero,
        color: style?.backgroundColor,
      ),
      child: _buildPhotoView(
        context: context,
        imageProvider: MemoryImage(widget.imageBytes!),
        imageWidth: size.width,
        imageHeight: size.height * 0.8,
      ),
    );
  }

  /// Builds a widget for displaying images from assets
  /// Uses FutureBuilder to handle async loading of image dimensions
  /// Returns a Container with the asset image
  Widget _buildAssetImage() {
    return Container(
      padding: style?.padding,
      margin: style?.margin,
      decoration: BoxDecoration(
        borderRadius: style!.borderRadius ?? BorderRadius.zero,
        color: style?.backgroundColor,
      ),
      child: FutureBuilder<ui.Image>(
        future: _getImageDimensions(AssetImage(widget.imageAssetPath!)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildPhotoView(
            imageProvider: AssetImage(widget.imageAssetPath!),
            context: context,
            imageWidth: snapshot.data!.width.toDouble(),
            imageHeight: snapshot.data!.height.toDouble(),
          );
        },
      ),
    );
  }

  /// Helper function to get image dimensions asynchronously
  ///
  /// Parameters:
  /// - provider: The ImageProvider to get dimensions from
  ///
  /// Returns a Future that resolves to the image dimensions
  Future<ui.Image> _getImageDimensions(ImageProvider provider) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(ImageConfiguration.empty);

    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });

    stream.addListener(listener);
    return completer.future;
  }

  /// Builds a default error widget to display when image loading fails
  /// Returns a Container with error icon and message
  Widget _defaultErrorWidget() {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.error_outline,
            style: LMChatIconStyle(
              size: 24,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const LMChatText(
            "An error occurred fetching media",
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// {@template lm_chat_image_style}
/// The style class for [LMChatImage]
///
/// Provides multiple levels of customisations.
/// {@endtemplate}
class LMChatImageStyle {
  /// Height of the image widget
  final double? height;

  /// Width of the image widget
  final double? width;

  /// Aspect ratio of the image widget
  final double? aspectRatio;

  /// Radius of the border of the image widget
  final BorderRadius? borderRadius;

  /// Color of the border of the image widget
  final Color? borderColor;

  /// Padding of the image widget
  final EdgeInsets? padding;

  /// Margin of the image widget from outside
  final EdgeInsets? margin;

  /// Fit of the container box of the image
  final BoxFit? boxFit;

  /// Color of the background of the image widget
  final Color? backgroundColor;

  /// Widget to show while the network image loads
  final Widget? loaderWidget;

  /// Widget to show if the network image fails to load
  final Widget? errorWidget;

  /// Widget to show a shimmer while presenting the image
  final Widget? shimmerWidget;

  ///{@macro lm_chat_image_style}
  const LMChatImageStyle({
    this.height,
    this.width,
    this.aspectRatio,
    this.borderRadius,
    this.borderColor,
    this.loaderWidget,
    this.errorWidget,
    this.shimmerWidget,
    this.boxFit,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  /// Creates a copy of the current style with the given parameters.
  ///
  /// All non-null parameters will override the current style's parameters.
  /// All null parameters will keep the current style's parameter.
  LMChatImageStyle copyWith({
    double? height,
    double? width,
    double? aspectRatio,
    BorderRadius? borderRadius,
    Color? borderColor,
    Widget? loaderWidget,
    Widget? errorWidget,
    Widget? shimmerWidget,
    BoxFit? boxFit,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
  }) {
    return LMChatImageStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      loaderWidget: loaderWidget ?? this.loaderWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      shimmerWidget: shimmerWidget ?? this.shimmerWidget,
      boxFit: boxFit ?? this.boxFit,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Creates a basic instance of [LMChatImageStyle].
  ///
  /// Optionally takes a [primaryColor] parameter to customize the style.
  factory LMChatImageStyle.basic({Color? primaryColor}) =>
      const LMChatImageStyle();
}
