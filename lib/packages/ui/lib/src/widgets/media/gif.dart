import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A widget to display and control GIF animations in the LMChat UI.
class LMChatGIF extends StatefulWidget {
  /// Creates an LMChatGIF widget.
  ///
  /// The [media] parameter is required and contains the GIF data.
  const LMChatGIF({
    super.key,
    required this.media,
    this.fps,
    this.duration,
    this.overlay,
    this.style,
  }) : assert((duration == null) || (fps == null),
            'Either duration or fps must be provided, but not both.');

  /// The media model containing the GIF data.
  final LMChatMediaModel media;

  /// The frames per second for the GIF animation.
  final int? fps;

  /// The duration of the GIF animation.
  final Duration? duration;

  /// An optional overlay widget to be displayed on top of the GIF.
  final Widget? overlay;

  /// The style configuration for the GIF widget.
  final LMChatGIFStyle? style;

  @override
  State<LMChatGIF> createState() => _LMChatGIFState();
}

class _LMChatGIFState extends State<LMChatGIF> with TickerProviderStateMixin {
  late GifController _controller;
  late ImageProvider<Object> imageProvider;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    _initializeImageProvider();
  }

  void _initializeImageProvider() {
    if (widget.media.mediaUrl != null) {
      imageProvider = NetworkImage(widget.media.mediaUrl!);
    } else {
      imageProvider = FileImage(widget.media.mediaFile!);
    }
  }

  @override
  void didUpdateWidget(LMChatGIF oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      _initializeImageProvider();
      _controller.reset();
      _isPlaying = false;
    }
  }

  @override
  void deactivate() {
    _controller.stop();
    _isPlaying = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const LMChatGIFStyle();
    return GestureDetector(
      onTap: _togglePlayPause,
      child: ClipRRect(
        borderRadius: style.borderRadius ?? BorderRadius.circular(6),
        child: Container(
          width: style.width,
          height: style.height,
          color: style.backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Gif(
                image: imageProvider,
                controller: _controller,
                autostart: Autostart.no,
                duration: widget.duration,
                fps: widget.fps,
                fit: style.fit ?? BoxFit.cover,
                placeholder: (context) => Image(
                  image: imageProvider,
                  fit: style.fit ?? BoxFit.cover,
                ),
                onFetchCompleted: () {
                  // Do nothing on fetch complete to keep the first frame
                },
              ),
              AnimatedOpacity(
                opacity: _isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: style.overlaySize ?? 42,
                  width: style.overlaySize ?? 42,
                  decoration: BoxDecoration(
                    color: style.overlayColor ?? LMChatTheme.theme.onContainer,
                    borderRadius:
                        style.overlayBorderRadius ?? BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: LMChatText(
                      "GIF",
                      style: style.overlayTextStyle ??
                          LMChatTextStyle(
                            textStyle: TextStyle(
                              color: LMChatTheme.theme.container,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              if (widget.overlay != null) widget.overlay!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Defines the style properties for the LMChatGIF widget.
class LMChatGIFStyle {
  /// Creates an LMChatGIFStyle instance.
  const LMChatGIFStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.backgroundColor,
    this.overlayTextStyle,
    this.overlayColor,
    this.overlaySize,
    this.overlayBorderRadius,
  });

  /// The width of the GIF container.
  final double? width;

  /// The height of the GIF container.
  final double? height;

  /// The border radius of the GIF container.
  final BorderRadius? borderRadius;

  /// The fit of the GIF within its container.
  final BoxFit? fit;

  /// The background color of the GIF container.
  final Color? backgroundColor;

  /// The style for the "GIF" text overlay.
  final LMChatTextStyle? overlayTextStyle;

  /// The color of the overlay container.
  final Color? overlayColor;

  /// The size of the overlay container.
  final double? overlaySize;

  /// The border radius of the overlay container.
  final BorderRadius? overlayBorderRadius;

  /// Creates a basic LMChatGIFStyle with default values.
  factory LMChatGIFStyle.basic() {
    return LMChatGIFStyle(
      borderRadius: BorderRadius.circular(8),
      overlayColor: Colors.black.withOpacity(0.5),
      overlaySize: 42,
      overlayBorderRadius: BorderRadius.circular(21),
    );
  }

  /// Creates a copy of this LMChatGIFStyle but with the given fields replaced with the new values.
  LMChatGIFStyle copyWith({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    BoxFit? fit,
    Color? backgroundColor,
    LMChatTextStyle? overlayTextStyle,
    Color? overlayColor,
    double? overlaySize,
    BorderRadius? overlayBorderRadius,
  }) {
    return LMChatGIFStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      fit: fit ?? this.fit,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayTextStyle: overlayTextStyle ?? this.overlayTextStyle,
      overlayColor: overlayColor ?? this.overlayColor,
      overlaySize: overlaySize ?? this.overlaySize,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
    );
  }
}
