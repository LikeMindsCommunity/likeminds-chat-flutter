import 'dart:async';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart'
//     as media_kit_video_controls;

/// A widget that displays a video in a chat interface.
class LMChatVideo extends StatefulWidget {
  /// The media model containing video information.
  final LMChatMediaModel media;

  /// The style configuration for the video.
  final LMChatVideoStyle? style;

  /// A builder for the mute button.
  final LMChatButtonBuilder? muteButton;

  const LMChatVideo({
    super.key,
    required this.media,
    this.style,
    this.muteButton,
  });

  /// Creates a copy of the current LMChatVideo with optional new values.
  LMChatVideo copyWith({
    LMChatMediaModel? media,
    LMChatVideoStyle? style,
    LMChatButtonBuilder? muteButton,
  }) {
    return LMChatVideo(
      media: media ?? this.media,
      style: style ?? this.style,
      muteButton: muteButton ?? this.muteButton,
    );
  }

  @override
  State<LMChatVideo> createState() => _LMChatVideoState();
}

/// State for the LMChatVideo widget.
class _LMChatVideoState extends State<LMChatVideo> {
  /// The video controller for managing video playback.
  VideoController? _controller;

  /// The player instance for video playback.
  Player? _player;

  /// Future for initializing the controller.
  Future<void>? init;

  /// Notifier to track mute state.
  ValueNotifier<bool>? isMuted;

  /// Notifier to track play/pause state.
  ValueNotifier<bool>? isPlaying;

  /// Notifier to trigger video rebuilds.
  ValueNotifier<bool> rebuildVideo = ValueNotifier(false);

  /// The video controller instance.
  VideoController? controller;

  /// The style configuration for the video.
  LMChatVideoStyle? style;

  @override
  void initState() {
    super.initState();
    init = _initController();
    isMuted = ValueNotifier(false);
    isPlaying = ValueNotifier(false);
  }

  @override
  void didUpdateWidget(old) {
    init = _initController();
    super.didUpdateWidget(old);
  }

  @override
  void deactivate() {
    _player?.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  /// Initializes the video controller based on the media source.
  Future<void> _initController() async {
    _player ??= Player(
      configuration: PlayerConfiguration(
        bufferSize: 4 * 1024 * 1024,
        ready: () {},
        muted: false,
      ),
    );
    _controller ??= VideoController(
      _player!,
      configuration: const VideoControllerConfiguration(
        scale: 0.5,
      ),
    );

    // initialise the controller based on the video source type
    // network or file
    if (widget.media.mediaUrl != null) {
      // if the video source type is network, then the video source is a url
      return await _player!.open(
        Media(widget.media.mediaUrl!),
        play: true,
      );
    } else {
      return await _player!.open(
        await Media.memory(widget.media.mediaBytes!),
        play: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final chatTheme = LMChatTheme.theme;
    style = widget.style ?? chatTheme.videoStyle;
    return Container(
      height: style?.height,
      width: style?.width ?? width,
      decoration: BoxDecoration(
        color: style?.backgroundColor ?? chatTheme.onPrimary,
        border: Border.all(
          color: style?.borderColor ?? Colors.transparent,
          width: style?.borderWidth ?? 0,
        ),
        borderRadius: style?.borderRadius ?? BorderRadius.circular(8.0),
      ),
      child: AspectRatio(
        // aspectRatio:
        aspectRatio: (style?.width ?? widget.media.width?.toDouble() ?? width) /
            (style?.height ?? widget.media.height?.toDouble() ?? 56.h),
        child: MaterialVideoControlsTheme(
          fullscreen: const MaterialVideoControlsThemeData(),
          normal: MaterialVideoControlsThemeData(
            bottomButtonBar: [
              const MaterialPositionIndicator(),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: isMuted!,
                builder: (context, state, _) {
                  return widget.muteButton?.call(_defMuteButton(state)) ??
                      _defMuteButton(state);
                },
              ),
            ],
            bottomButtonBarMargin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            seekBarMargin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
            seekBarPositionColor:
                style?.seekBarColor ?? chatTheme.secondaryColor,
            seekBarThumbColor: style?.seekBarColor ?? chatTheme.secondaryColor,
          ),
          child: Video(
            fit: style?.boxFit ?? BoxFit.contain,
            aspectRatio: style?.aspectRatio,
            controller: _controller!,
          ),
        ),
      ),
    );
  }

  /// Defines the mute button for the video.
  LMChatButton _defMuteButton(bool state) {
    return LMChatButton(
      onTap: () {
        state ? _player!.setVolume(100) : _player!.setVolume(0);
        isMuted!.value = !isMuted!.value;
      },
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        style: LMChatIconStyle(
          color: LMChatTheme.theme.container,
        ),
        icon: state ? Icons.volume_off : Icons.volume_up,
      ),
    );
  }
}

/// Configuration for the LMChatVideo widget's style.
class LMChatVideoStyle {
  // Video structure variables
  /// The height of the video.
  final double? height;

  /// The width of the video.
  final double? width;

  /// The aspect ratio of the video (defaults to 16/9).
  final double? aspectRatio;

  /// The border radius of the video (defaults to 0).
  final BorderRadius? borderRadius;

  /// The border color of the video.
  final Color? borderColor;

  /// The background color of the video.
  final Color? backgroundColor;

  /// The border width of the video.
  final double? borderWidth;

  /// The box fit of the video (defaults to BoxFit.cover).
  final BoxFit? boxFit;

  /// Padding around the video.
  final EdgeInsets? padding;

  /// Margin around the video.
  final EdgeInsets? margin;

  // Video styling variables
  /// The color of the seek bar.
  final Color? seekBarColor;

  /// The color of the seek bar buffer.
  final Color? seekBarBufferColor;

  /// The text style for the progress text.
  final TextStyle? progressTextStyle;

  /// The widget displayed while loading the video.
  final Widget? loaderWidget;

  /// The widget displayed on error.
  final Widget? errorWidget;

  /// The widget displayed while shimmering.
  final Widget? shimmerWidget;

  /// The button for playing the video.
  final LMChatButton? playButton;

  /// The button for pausing the video.
  final LMChatButton? pauseButton;

  /// The button for muting the video.
  final LMChatButton? muteButton;
  // Video functionality control variables
  /// Whether to show video controls.
  final bool? showControls;

  /// Whether the video should autoplay.
  final bool? autoPlay;

  /// Whether the video should loop.
  final bool? looping;

  /// Whether to allow full screen mode.
  final bool? allowFullScreen;

  /// Whether to allow muting.
  final bool? allowMuting;

  const LMChatVideoStyle({
    this.height,
    this.width,
    this.aspectRatio,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth,
    this.boxFit,
    this.seekBarColor,
    this.seekBarBufferColor,
    this.progressTextStyle,
    this.loaderWidget,
    this.errorWidget,
    this.shimmerWidget,
    this.playButton,
    this.pauseButton,
    this.muteButton,
    this.showControls,
    this.autoPlay,
    this.looping,
    this.allowFullScreen,
    this.allowMuting,
    this.padding,
    this.margin,
  });

  /// Creates a copy of the current LMChatVideoStyle with optional new values.
  LMChatVideoStyle copyWith({
    double? height,
    double? width,
    double? aspectRatio,
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    BoxFit? boxFit,
    Color? seekBarColor,
    Color? seekBarBufferColor,
    TextStyle? progressTextStyle,
    Widget? loaderWidget,
    Widget? errorWidget,
    Widget? shimmerWidget,
    LMChatButton? playButton,
    LMChatButton? pauseButton,
    LMChatButton? muteButton,
    bool? showControls,
    bool? autoPlay,
    bool? looping,
    bool? allowFullScreen,
    bool? allowMuting,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return LMChatVideoStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      boxFit: boxFit ?? this.boxFit,
      seekBarColor: seekBarColor ?? this.seekBarColor,
      seekBarBufferColor: seekBarBufferColor ?? this.seekBarBufferColor,
      progressTextStyle: progressTextStyle ?? this.progressTextStyle,
      loaderWidget: loaderWidget ?? this.loaderWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      shimmerWidget: shimmerWidget ?? this.shimmerWidget,
      playButton: playButton ?? this.playButton,
      pauseButton: pauseButton ?? this.pauseButton,
      muteButton: muteButton ?? this.muteButton,
      showControls: showControls ?? this.showControls,
      autoPlay: autoPlay ?? this.autoPlay,
      looping: looping ?? this.looping,
      allowFullScreen: allowFullScreen ?? this.allowFullScreen,
      allowMuting: allowMuting ?? this.allowMuting,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  /// Creates a basic LMChatVideoStyle with a loader widget.
  factory LMChatVideoStyle.basic({Color? primaryColor}) =>
      const LMChatVideoStyle(
        loaderWidget: LMChatLoader(),
      );
}
