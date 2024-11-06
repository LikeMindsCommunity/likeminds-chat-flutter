import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_audio}
/// A widget to display and control audio playback in the LMChat UI.
/// The [media] parameter is required and contains the audio data.
/// {@endtemplate}
class LMChatVoiceNote extends StatefulWidget {
  /// {@macro lm_chat_audio}
  /// Creates an instance of [LMChatVoiceNote].
  const LMChatVoiceNote({
    super.key,
    required this.media,
    this.style,
    this.autoplay,
    this.onPlay,
    this.onPause,
    this.onSlide,
    this.onSlideEnd,
    this.onSlideStart,
    this.handler,
  });

  /// Creates a copy of this [LMChatVoiceNote] but with the given fields replaced with the new values.
  ///
  /// If the new values are null, then the old values are used.
  LMChatVoiceNote copyWith({
    LMChatMediaModel? media,
    LMChatVoiceNoteStyle? style,
    bool? autoplay,
    Function()? onPlay,
    Function()? onPause,
    Function(double)? onSlide,
    Function(double)? onSlideStart,
    Function(double)? onSlideEnd,
    LMChatAudioHandler? handler,
  }) {
    return LMChatVoiceNote(
      media: media ?? this.media,
      style: style ?? this.style,
      autoplay: autoplay ?? this.autoplay,
      onPlay: onPlay ?? this.onPlay,
      onPause: onPause ?? this.onPause,
      onSlide: onSlide ?? this.onSlide,
      onSlideStart: onSlideStart ?? this.onSlideStart,
      onSlideEnd: onSlideEnd ?? this.onSlideEnd,
      handler: handler ?? this.handler,
    );
  }

  /// The media model containing the audio data.
  final LMChatMediaModel media;

  /// The style configuration for the audio widget.
  final LMChatVoiceNoteStyle? style;

  /// The bool to control whether audio autoplays or not.
  final bool? autoplay;

  /// Callback function that is called when the audio starts playing.
  final Function()? onPlay;

  /// Callback function that is called when the audio is paused.
  final Function()? onPause;

  /// Callback function that is called when the audio slider is changed.
  final Function(double)? onSlide;

  /// Callback function that is called when the audio slider change starts.
  final Function(double)? onSlideStart;

  /// Callback function that is called when the audio slider change ends.
  final Function(double)? onSlideEnd;

  /// External FlutterSoundPlayer instance that can be passed to control audio externally
  final LMChatAudioHandler? handler;

  @override
  State<LMChatVoiceNote> createState() => _LMChatVoiceNoteState();
}

class _LMChatVoiceNoteState extends State<LMChatVoiceNote> {
  late final FlutterSoundPlayer _localPlayer;
  late final bool _useExternalHandler;
  bool _isAudioPlaying = false;
  double _progress = 0.0;
  Duration _totalDuration = Duration.zero;
  bool _isDragging = false;

  // Subscriptions
  StreamSubscription? _playerSubscription;
  StreamSubscription? _progressSubscription;
  StreamSubscription? _handlerSubscription;

  @override
  void initState() {
    super.initState();
    _useExternalHandler = widget.handler != null;
    _initializePlayer();
  }

  void _initializePlayer() async {
    if (_useExternalHandler) {
      _initializeWithHandler();
    } else {
      _initializeLocalPlayer();
    }

    if (widget.autoplay ?? false) {
      await _startPlayer();
    }
  }

  void _initializeWithHandler() {
    // Listen to external player state changes
    _handlerSubscription = widget.handler!.currentlyPlayingUrl.listen((url) {
      if (!mounted) return;

      final bool isPlaying = url == widget.media.mediaUrl ||
          (widget.media.mediaFile != null &&
              url == widget.media.mediaFile!.path);

      setState(() {
        _isAudioPlaying = isPlaying;
        if (!_isAudioPlaying && !_isDragging) {
          _progress = 0.0;
        }
      });
    });

    // Subscribe to progress updates
    if (widget.media.mediaFile != null) {
      _subscribeToProgressUpdates(widget.media.mediaFile!.path);
    } else if (widget.media.mediaUrl != null) {
      _subscribeToProgressUpdates(widget.media.mediaUrl!);
    }
  }

  void _initializeLocalPlayer() {
    _localPlayer = FlutterSoundPlayer();
    _localPlayer.openPlayer().then((_) {
      setState(() {
        if (widget.autoplay ?? false) {
          _startPlayer();
        }
      });
    });
  }

  void _subscribeToProgressUpdates(String mediaUrl) {
    _progressSubscription?.cancel();
    _progressSubscription =
        widget.handler!.getProgressStream(mediaUrl).listen(_updateProgress);
  }

  void _updateProgress(PlaybackProgress progress) {
    if (!mounted || _isDragging) return;

    setState(() {
      _totalDuration = progress.duration;
      if (_totalDuration.inMilliseconds > 0) {
        _progress =
            (progress.position.inMilliseconds / _totalDuration.inMilliseconds)
                .clamp(0.0, 1.0);
      }
    });
  }

  Future<void> _startPlayer() async {
    // Return if neither local file nor URL is available
    if (widget.media.mediaFile == null && widget.media.mediaUrl == null) return;

    try {
      if (_useExternalHandler) {
        await _startWithHandler();
      } else {
        await _startWithLocalPlayer();
      }
    } catch (e) {
      print('Error starting player: $e');
    }
  }

  Future<void> _startWithHandler() async {
    await widget.handler!.stopAudio(); // Ensure clean state

    // Prefer local file over URL if available
    if (widget.media.mediaFile != null) {
      await widget.handler!.playAudio(widget.media.mediaFile!.path);
    } else if (widget.media.mediaUrl != null) {
      await widget.handler!.playAudio(widget.media.mediaUrl!);
    }
    widget.onPlay?.call();
  }

  Future<void> _startWithLocalPlayer() async {
    try {
      if (_localPlayer.isPaused || _localPlayer.isPlaying) {
        await _localPlayer.stopPlayer();
      }

      _progress = 0.0;

      String? playbackPath;
      if (widget.media.mediaFile != null) {
        playbackPath = widget.media.mediaFile!.path;
      } else if (widget.media.mediaUrl != null) {
        playbackPath = widget.media.mediaUrl;
      }

      if (playbackPath != null) {
        await _localPlayer.startPlayer(
          fromURI: playbackPath,
          whenFinished: () {
            _onPlaybackComplete();
            widget.onPause?.call();
          },
        );

        await _localPlayer
            .setSubscriptionDuration(const Duration(milliseconds: 100));
        _setupLocalPlayerProgress();

        setState(() {
          _isAudioPlaying = true;
        });
        widget.onPlay?.call();
      }
    } catch (e) {
      print('Error in _startWithLocalPlayer: $e');
    }
  }

  void _onPlaybackComplete() {
    if (!mounted) return;
    setState(() {
      _isAudioPlaying = false;
      _progress = 0.0;
    });
  }

  void _setupLocalPlayerProgress() {
    _localPlayer.setSubscriptionDuration(const Duration(milliseconds: 100));
    _playerSubscription?.cancel();
    _playerSubscription = _localPlayer.onProgress!.listen((e) {
      if (!mounted || _isDragging) return;

      setState(() {
        _totalDuration = e.duration;
        if (_totalDuration.inMilliseconds > 0) {
          _progress =
              (e.position.inMilliseconds / _totalDuration.inMilliseconds)
                  .clamp(0.0, 1.0);
        }
      });
    });
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isAudioPlaying) {
        await _pausePlayback();
      } else {
        if (_useExternalHandler) {
          await _startWithHandler();
        } else {
          if (_localPlayer.isPaused) {
            await _resumePlayback();
          } else {
            await _startWithLocalPlayer();
          }
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> _pausePlayback() async {
    if (_useExternalHandler) {
      await widget.handler!.pauseAudio();
    } else {
      await _localPlayer.pausePlayer();
      setState(() => _isAudioPlaying = false);
    }
    widget.onPause?.call();
  }

  Future<void> _resumePlayback() async {
    if (_useExternalHandler) {
      await widget.handler!.resumeAudio();
    } else {
      await _localPlayer.resumePlayer();
      _setupLocalPlayerProgress();
      setState(() => _isAudioPlaying = true);
    }
    widget.onPlay?.call();
  }

  @override
  void dispose() {
    if (_isAudioPlaying && _useExternalHandler) {
      widget.handler!.stopAudio();
    }
    _cleanupSubscriptions();
    if (!_useExternalHandler) {
      _localPlayer.closePlayer();
    }
    super.dispose();
  }

  void _cleanupSubscriptions() {
    _playerSubscription?.cancel();
    _handlerSubscription?.cancel();
    _progressSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const LMChatVoiceNoteStyle();
    return Container(
      width: style.width,
      height: style.height,
      color: style.backgroundColor,
      padding: style.padding ?? const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          LMChatButton(
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: _isAudioPlaying ? Icons.pause : Icons.play_arrow,
              style: LMChatIconStyle(
                size: 28,
                boxSize: 32,
                color: LMChatTheme.theme.onPrimary,
              ),
            ),
            onTap: _togglePlayPause,
            style: LMChatButtonStyle(
              height: 36,
              width: 36,
              borderRadius: 18,
              backgroundColor: LMChatTheme.theme.secondaryColor,
            ),
          ),
          Expanded(
            child: Slider(
              value: _progress.clamp(0.0, 1.0),
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
                widget.onSlide?.call(value);
              },
              onChangeStart: (value) {
                _isDragging = true;
                widget.onSlideStart?.call(value);
              },
              onChangeEnd: (value) {
                _isDragging = false;
                final position = Duration(
                  milliseconds: (_totalDuration.inMilliseconds * value).toInt(),
                );
                if (_useExternalHandler) {
                  widget.handler!.seekTo(position);
                } else {
                  _localPlayer.seekToPlayer(position);
                }
                widget.onSlideEnd?.call(value);
              },
              min: style.sliderMin,
              max: style.sliderMax,
              divisions: style.sliderDivisions,
              activeColor:
                  style.sliderActiveColor ?? LMChatTheme.theme.secondaryColor,
              inactiveColor:
                  style.sliderInactiveColor ?? LMChatTheme.theme.disabledColor,
              thumbColor:
                  style.sliderThumbColor ?? LMChatTheme.theme.secondaryColor,
            ),
          ),
          // Add more UI elements like duration, etc.
        ],
      ),
    );
  }
}

/// Defines the style properties for the LMChatAudio widget.
class LMChatVoiceNoteStyle {
  /// The width of the audio container.
  final double? width;

  /// The height of the audio container.
  final double? height;

  /// The background color of the audio container.
  final Color? backgroundColor;

  /// The color of the play/pause icon.
  final Color? iconColor;

  /// The padding around the audio container.
  final EdgeInsets? padding;

  /// The minimum value of the slider.
  final double sliderMin;

  /// The maximum value of the slider.
  final double sliderMax;

  /// The number of discrete divisions in the slider.
  final int? sliderDivisions;

  /// The color of the active portion of the slider.
  final Color? sliderActiveColor;

  /// The color of the inactive portion of the slider.
  final Color? sliderInactiveColor;

  /// The color of the slider's thumb.
  final Color? sliderThumbColor;

  /// Creates an instance of [LMChatVoiceNoteStyle].
  const LMChatVoiceNoteStyle({
    this.width,
    this.height,
    this.backgroundColor,
    this.iconColor,
    this.padding,
    this.sliderMin = 0.0,
    this.sliderMax = 1.0,
    this.sliderDivisions,
    this.sliderActiveColor,
    this.sliderInactiveColor,
    this.sliderThumbColor,
  });

  /// Creates a basic instance of [LMChatVoiceNoteStyle].
  factory LMChatVoiceNoteStyle.basic() {
    return const LMChatVoiceNoteStyle();
  }

  /// Creates a copy of this [LMChatVoiceNoteStyle] but with the given fields replaced with the new values.
  LMChatVoiceNoteStyle copyWith({
    double? width,
    double? height,
    Color? backgroundColor,
    Color? iconColor,
    EdgeInsets? padding,
    double? sliderMin,
    double? sliderMax,
    int? sliderDivisions,
    Color? sliderActiveColor,
    Color? sliderInactiveColor,
    Color? sliderThumbColor,
  }) {
    return LMChatVoiceNoteStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      padding: padding ?? this.padding,
      sliderMin: sliderMin ?? this.sliderMin,
      sliderMax: sliderMax ?? this.sliderMax,
      sliderDivisions: sliderDivisions ?? this.sliderDivisions,
      sliderActiveColor: sliderActiveColor ?? this.sliderActiveColor,
      sliderInactiveColor: sliderInactiveColor ?? this.sliderInactiveColor,
      sliderThumbColor: sliderThumbColor ?? this.sliderThumbColor,
    );
  }
}
