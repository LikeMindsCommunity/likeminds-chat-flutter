import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

///{@template lm_chat_gif}
/// A widget to display and control GIF animations in the LMChat UI.
/// The [media] parameter is required and contains the GIF data.
/// {@endtemplate}
class LMChatGIF extends StatefulWidget {
  /// {@macro lm_chat_gif}
  const LMChatGIF({
    super.key,
    required this.media,
    this.fps,
    this.duration,
    this.overlay,
    this.style,
    this.autoplay,
  }) : assert((duration == null) || (fps == null),
            'Either duration or fps must be provided, but not both.');

  /// Creates a copy of this [LMChatGIF] but with the given fields replaced with the new values.
  ///
  /// If the new values are null, then the old values are used.
  LMChatGIF copyWith({
    LMChatMediaModel? media,
    int? fps,
    Duration? duration,
    Widget? overlay,
    LMChatGIFStyle? style,
    bool? autoplay,
  }) {
    return LMChatGIF(
      media: media ?? this.media,
      fps: fps ?? this.fps,
      duration: duration ?? this.duration,
      overlay: overlay ?? this.overlay,
      style: style ?? this.style,
      autoplay: autoplay ?? this.autoplay,
    );
  }

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

  /// The bool to control whether GIF autoplays or not
  final bool? autoplay;

  @override
  State<LMChatGIF> createState() => _LMChatGIFState();
}

class _LMChatGIFState extends State<LMChatGIF> with TickerProviderStateMixin {
  late GifController _controller;
  late ImageProvider<Object> imageProvider;
  bool _isGIFPlaying = false; // Renamed for clarity

  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    _isGIFPlaying = widget.autoplay ?? false;
    _initializeImageProvider();
  }

  void _initializeImageProvider() {
    if (widget.media.mediaUrl != null) {
      imageProvider = NetworkImage(widget.media.mediaUrl!);
    } else if (widget.media.mediaFile != null) {
      imageProvider = FileImage(widget.media.mediaFile!);
    } else {
      // Handle error case if both are null
      debugPrint('Error: No media URL or file provided.');
      return;
    }
  }

  @override
  void didUpdateWidget(LMChatGIF oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.media != oldWidget.media) {
      _initializeImageProvider();
      _controller.reset();
      _isGIFPlaying = false;
    }
  }

  @override
  void deactivate() {
    _controller.stop();
    _isGIFPlaying = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isGIFPlaying) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
      _isGIFPlaying = !_isGIFPlaying;
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
                autostart:
                    widget.autoplay ?? false ? Autostart.loop : Autostart.no,
                duration: widget.duration,
                fps: widget.fps,
                fit: style.fit ?? BoxFit.cover,
                placeholder: (context) => LMChatMediaShimmerWidget(
                  width: style.width,
                ),
                onFetchCompleted: () {
                  // Do nothing on fetch complete to keep the first frame
                },
              ),
              Visibility(
                visible: !_isGIFPlaying,
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
