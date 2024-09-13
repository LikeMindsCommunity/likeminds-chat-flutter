import 'dart:async';

import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart'
//     as media_kit_video_controls;

class LMChatVideo extends StatefulWidget {
  final LMChatMediaModel media;
  final LMChatVideoStyle? style;
  final LMChatButtonBuilder? muteButton;

  const LMChatVideo({
    super.key,
    required this.media,
    this.style,
    this.muteButton,
  });

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

class _LMChatVideoState extends State<LMChatVideo> {
  VideoController? _controller;
  Player? _player;
  Future<void>? init;

  ValueNotifier<bool>? isMuted;
  ValueNotifier<bool> rebuildVideo = ValueNotifier(false);
  VideoController? controller;

  LMChatVideoStyle? style;

  @override
  void initState() {
    super.initState();
    init = _initController();
    isMuted = ValueNotifier(false);
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
        await Media.memory(widget.media.mediaFile!.readAsBytesSync()),
        play: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = LMChatTheme.theme;
    style = widget.style ?? chatTheme.videoStyle;
    return Container(
      width: 100.w,
      color: LMChatTheme.theme.onPrimary,
      child: AspectRatio(
        // aspectRatio:
        aspectRatio: (style?.width ?? widget.media.width?.toDouble() ?? 100.w) /
            (style?.height ?? widget.media.height?.toDouble() ?? 56.h),
        child: MaterialVideoControlsTheme(
          normal: MaterialVideoControlsThemeData(
            bottomButtonBar: [
              const MaterialPositionIndicator(),
              const Spacer(),
              widget.muteButton ?? _defMuteButton(),
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
          fullscreen: MaterialVideoControlsThemeData(
            seekBarMargin: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 8,
            ),
            seekBarPositionColor: style?.seekBarColor ?? chatTheme.primaryColor,
            seekBarThumbColor: style?.seekBarColor ?? chatTheme.primaryColor,
            bottomButtonBar: [
              const MaterialPositionIndicator(),
              const Spacer(),
              widget.muteButton ?? _defMuteButton(),
              const SizedBox(width: 4),
              const MaterialFullscreenButton(),
            ],
            bottomButtonBarMargin: const EdgeInsets.symmetric(horizontal: 8),
            controlsHoverDuration: const Duration(seconds: 3),
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

  _defMuteButton() {
    return ValueListenableBuilder(
      valueListenable: isMuted!,
      builder: (context, state, _) {
        return IconButton(
          onPressed: () {
            state ? _player!.setVolume(100) : _player!.setVolume(0);
            isMuted!.value = !isMuted!.value;
          },
          icon: LMChatIcon(
            type: LMChatIconType.icon,
            style: const LMChatIconStyle(
              color: Colors.white,
            ),
            icon: state ? Icons.volume_off : Icons.volume_up,
          ),
        );
      },
    );
  }
}

class LMChatVideoStyle {
  // Video structure variables
  final double? height;
  final double? width;
  final double? aspectRatio; // defaults to 16/9
  final BorderRadius? borderRadius; // defaults to 0
  final Color? borderColor;
  final double? borderWidth;
  final BoxFit? boxFit; // defaults to BoxFit.cover
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  // Video styling variables
  final Color? seekBarColor;
  final Color? seekBarBufferColor;
  final TextStyle? progressTextStyle;
  final Widget? loaderWidget;
  final Widget? errorWidget;
  final Widget? shimmerWidget;
  final LMChatButton? playButton;
  final LMChatButton? pauseButton;
  final LMChatButton? muteButton;
  // Video functionality control variables
  final bool? showControls;
  final bool? autoPlay;
  final bool? looping;
  final bool? allowFullScreen;
  final bool? allowMuting;

  const LMChatVideoStyle({
    this.height,
    this.width,
    this.aspectRatio,
    this.borderRadius,
    this.borderColor,
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

  factory LMChatVideoStyle.basic({Color? primaryColor}) =>
      const LMChatVideoStyle(
        loaderWidget: LMChatLoader(),
      );
}
