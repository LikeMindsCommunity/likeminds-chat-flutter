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
    LMChatAudioStyle? style,
    bool? autoplay,
  }) {
    return LMChatVoiceNote(
      media: media ?? this.media,
      style: style ?? this.style,
      autoplay: autoplay ?? this.autoplay,
    );
  }

  /// The media model containing the audio data.
  final LMChatMediaModel media;

  /// The style configuration for the audio widget.
  final LMChatAudioStyle? style;

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
  late final FlutterSoundPlayer _player;
  bool _isAudioPlaying = false;
  double _progress = 0.0;
  bool _mPlayerIsInited = false;
  StreamSubscription? _playerSubscription;
  StreamSubscription? _progressSubscription;
  Duration _totalDuration = Duration.zero;
  bool _isDragging = false;

  // Add listener for external player state
  StreamSubscription? _handlerSubscription;

  @override
  void initState() {
    super.initState();
    _player = widget.handler?.player ?? FlutterSoundPlayer();

    if (widget.handler == null) {
      _player.openPlayer().then((value) {
        setState(() {
          _mPlayerIsInited = true;
          if (widget.autoplay ?? false) {
            _startPlayer();
          }
        });
      });
    } else {
      _mPlayerIsInited = true;

      // Listen to external player state changes
      _handlerSubscription = widget.handler!.currentlyPlayingUrl.listen((url) {
        if (mounted) {
          setState(() {
            _isAudioPlaying = url == widget.media.mediaUrl;
            if (!_isAudioPlaying && !_isDragging) {
              _progress = 0.0;
            }
          });
        }
      });

      // Subscribe to progress updates for this specific audio URL
      if (widget.media.mediaUrl != null) {
        _progressSubscription = widget.handler!
            .getProgressStream(widget.media.mediaUrl!)
            .listen((progress) {
          if (mounted && !_isDragging) {
            setState(() {
              _totalDuration = progress.duration;
              if (_totalDuration.inMilliseconds > 0) {
                _progress = progress.position.inMilliseconds /
                    _totalDuration.inMilliseconds;
              }
            });
          }
        });
      }

      if (widget.autoplay ?? false) {
        _startPlayer();
      }
    }
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    _handlerSubscription?.cancel();
    _progressSubscription?.cancel();
    if (widget.handler == null) {
      _player.closePlayer();
    }
    super.dispose();
  }

  Future<void> _startPlayer() async {
    if (_mPlayerIsInited && widget.media.mediaUrl != null) {
      try {
        if (widget.handler != null) {
          await widget.handler!.playAudio(widget.media.mediaUrl!);
        } else {
          _progress = 0.0;
          await _player.startPlayer(
            fromURI: widget.media.mediaUrl != null
                ? Uri.parse(widget.media.mediaUrl!).toString()
                : null,
            codec: Codec.flac,
            whenFinished: _stopPlayer,
          );

          _player.setSubscriptionDuration(const Duration(milliseconds: 100));
          _playerSubscription?.cancel();
          _playerSubscription = _player.onProgress!.listen((e) {
            if (mounted) {
              setState(() {
                _totalDuration = e.duration;
                _progress =
                    e.position.inMilliseconds / _totalDuration.inMilliseconds;
              });
            }
          });

          setState(() {
            _isAudioPlaying = true;
          });
        }
      } catch (e) {
        print('Error starting player: $e');
      }
    }
  }

  Future<void> _stopPlayer() async {
    if (widget.handler != null) {
      await widget.handler!.stopAudio();
    } else {
      await _player.stopPlayer();
      if (mounted) {
        setState(() {
          _isAudioPlaying = false;
          _progress = 0.0;
        });
      }
      _playerSubscription?.cancel();
      _playerSubscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const LMChatAudioStyle();
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
              value: _progress,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
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
                if (widget.handler != null) {
                  widget.handler!.seekTo(position);
                } else {
                  _player.seekToPlayer(position);
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

  /// Toggles between play and pause states of the audio.
  void _togglePlayPause() {
    if (_isAudioPlaying) {
      _pausePlayer();
      widget.onPause?.call();
    } else {
      if (_player.isPaused) {
        _resumePlayer();
      } else {
        _startPlayer();
      }
      widget.onPlay?.call();
    }
  }

  /// Pauses the audio playback.
  Future<void> _pausePlayer() async {
    if (widget.handler != null) {
      await widget.handler!.pauseAudio();
    } else {
      await _player.pausePlayer();
      setState(() {
        _isAudioPlaying = false;
      });
    }
  }

  /// Resumes the audio playback.
  Future<void> _resumePlayer() async {
    if (widget.handler != null) {
      await widget.handler!.resumeAudio();
    } else {
      await _player.resumePlayer();
      setState(() {
        _isAudioPlaying = true;
      });
      _player.setSubscriptionDuration(const Duration(milliseconds: 100));
      _playerSubscription = _player.onProgress!.listen((e) {
        setState(() {
          _totalDuration = e.duration;
          _progress = e.position.inMilliseconds / _totalDuration.inMilliseconds;
        });
      });
    }
  }
}

/// Defines the style properties for the LMChatAudio widget.
class LMChatAudioStyle {
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

  /// Creates an instance of [LMChatAudioStyle].
  const LMChatAudioStyle({
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

  /// Creates a basic instance of [LMChatAudioStyle].
  factory LMChatAudioStyle.basic() {
    return const LMChatAudioStyle();
  }

  /// Creates a copy of this [LMChatAudioStyle] but with the given fields replaced with the new values.
  LMChatAudioStyle copyWith({
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
    return LMChatAudioStyle(
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
