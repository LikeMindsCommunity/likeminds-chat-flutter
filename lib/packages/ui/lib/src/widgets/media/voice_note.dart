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
    this.onDurationUpdate,
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
    Function(Duration)? onDurationUpdate,
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
      onDurationUpdate: onDurationUpdate ?? this.onDurationUpdate,
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

  /// Callback function that is called when the audio duration updates.
  final Function(Duration)? onDurationUpdate;

  @override
  State<LMChatVoiceNote> createState() => _LMChatVoiceNoteState();
}

class _LMChatVoiceNoteState extends State<LMChatVoiceNote>
    with WidgetsBindingObserver {
  FlutterSoundPlayer? _localPlayer;
  late final bool _useExternalHandler;
  bool _isAudioPlaying = false;
  double _progress = 0.0;
  Duration _totalDuration = Duration.zero;
  bool _isDragging = false;
  String? _currentMediaPath;
  bool _wasPlayingBeforePause = false;

  // Subscriptions
  StreamSubscription? _playerSubscription;
  StreamSubscription? _progressSubscription;
  StreamSubscription? _handlerSubscription;
  StreamSubscription? _durationSubscription;

  Duration? _initialSeekPosition;

  // Add new state variable to track last played position
  Duration _lastPlayedPosition = Duration.zero;

  // Add this field at the top with other state variables
  Duration _initialDuration = Duration.zero;

  // Add this near other state variables in _LMChatVoiceNoteState
  StreamSubscription? _audioStateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _useExternalHandler = widget.handler != null;
    _currentMediaPath = widget.media.mediaFile?.path ?? widget.media.mediaUrl;

    // Add audio state subscription
    _audioStateSubscription = widget.handler?.audioStateStream.listen((state) {
      if (state == LMChatAudioState.stopped && mounted) {
        _resetPlayback();
      }
    });

    // Parse initial duration from metadata if available
    _initialDuration = Duration(
      seconds: int.tryParse(
            widget.media.meta?["duration"]?.toString() ?? "0",
          ) ??
          0,
    );
    if (_initialDuration > Duration.zero) {
      _totalDuration = _initialDuration;
    }

    if (_useExternalHandler) {
      _initializeHandlerSubscriptions();
    }

    // Only fetch duration if not available from metadata
    if (_initialDuration == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeAndGetDuration();
      });
    }

    if (widget.autoplay ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startPlayer();
      });
    }

    if (_useExternalHandler && _currentMediaPath != null) {
      _durationSubscription = widget.handler!
          .getDurationStream(_currentMediaPath!)
          .listen((duration) {
        widget.onDurationUpdate?.call(duration);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _wasPlayingBeforePause = _isAudioPlaying;
        if (_isAudioPlaying) {
          _pausePlayback();
        }
        break;
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          _resumePlayback();
        }
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentMediaPath = widget.media.mediaFile?.path ?? widget.media.mediaUrl;
    if (widget.autoplay ?? false) {
      _startPlayer();
    }
  }

  @override
  void didUpdateWidget(LMChatVoiceNote oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newMediaPath = widget.media.mediaFile?.path ?? widget.media.mediaUrl;

    if (_currentMediaPath != newMediaPath) {
      // Reset last played position when media changes
      _lastPlayedPosition = Duration.zero;

      // Clean up old resources and reset state
      if (_isAudioPlaying ||
          (_useExternalHandler && (widget.handler?.player.isPaused ?? false))) {
        _pausePlayback();
        _progress = 0.0;
        _totalDuration = Duration.zero;
      }
      _cleanupPlayer();

      // Update path and reinitialize if needed
      _currentMediaPath = newMediaPath;

      // If autoplay is enabled for the new media, start playing it
      if (widget.autoplay ?? false) {
        _startPlayer();
      }
    }

    // Handle handler changes
    if (oldWidget.handler != widget.handler) {
      _cleanupSubscriptions();
      _useExternalHandler = widget.handler != null;

      // // Reset state when handler changes
      // _progress = 0.0;
      // _lastPlayedPosition = Duration.zero;
      // _totalDuration = Duration.zero;
      // widget.onDurationUpdate?.call(Duration.zero);

      // if (_useExternalHandler) {
      //   _initializeHandlerSubscriptions();

      //   // Set up duration subscription for new handler
      //   if (_currentMediaPath != null) {
      //     _durationSubscription?.cancel();
      //     _durationSubscription = widget.handler!
      //         .getDurationStream(_currentMediaPath!)
      //         .listen((duration) {
      //       widget.onDurationUpdate?.call(duration);
      //     });
      //   }
      // }
    }
  }

  void _cleanupPlayer() {
    _progress = 0.0;
    _totalDuration = Duration.zero;
    if (_localPlayer != null) {
      _localPlayer!.closePlayer();
      _localPlayer = null;
    }
    _cleanupSubscriptions();
  }

  Future<void> _stopAllOtherPlayers() async {
    try {
      if (_useExternalHandler) {
        // First check if any audio is playing and if it's different from current
        String? currentPlayingUrl = widget.handler!.currentlyPlayingUrl;
        if (currentPlayingUrl != null &&
            currentPlayingUrl.isNotEmpty &&
            currentPlayingUrl != _currentMediaPath) {
          await widget.handler!.stopAudio();
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } else {
        if (_localPlayer?.isPlaying ?? false) {
          await _localPlayer!.stopPlayer();
          _playerSubscription?.cancel();
          _playerSubscription = null;
        }
      }
    } catch (e) {
      print('Error stopping other players: $e');
    }
  }

  Future<void> _startPlayer() async {
    if (_currentMediaPath == null) return;

    try {
      // First ensure complete cleanup of any existing playback
      await _stopAllOtherPlayers();

      // Reset all state to ensure fresh start
      _progressSubscription?.cancel();
      _playerSubscription?.cancel();

      // Only preserve initial seek position if it was explicitly set
      final preservedSeekPosition = _initialSeekPosition;

      setState(() {
        _progress = 0.0;
        _totalDuration = Duration.zero;
        _isAudioPlaying = false; // Ensure we start from a clean state
      });

      // Restore initial seek position if it existed
      _initialSeekPosition = preservedSeekPosition;

      if (_useExternalHandler) {
        // Ensure handler is in a clean state
        await widget.handler!.stopAudio();
        await Future.delayed(const Duration(milliseconds: 50));
        await _startWithHandler();
      } else {
        // For local player, close and reinitialize to ensure clean state
        if (_localPlayer != null) {
          await _localPlayer!.closePlayer();
          _localPlayer = null;
        }
        await _initializeLocalPlayer();
        await _startWithLocalPlayer();
      }
    } catch (e) {
      print('Error starting player: $e');
      _handlePlaybackError();
    }
  }

  void _handlePlaybackError() {
    setState(() {
      _isAudioPlaying = false;
      _progress = 0.0;
    });
    widget.onPause?.call();
    _cleanupPlayer();
  }

  void _initializeHandlerSubscriptions() {
    // Listen to external player state changes
    _handlerSubscription = widget.handler!.currentlyPlayingStream.listen((url) {
      if (!mounted) return;

      // If a different URL is playing, ensure this widget shows as paused
      if (url != _currentMediaPath && _isAudioPlaying) {
        setState(() {
          _isAudioPlaying = false;
          _progress = 0.0;
        });
        widget.onPause?.call();
      } else if (url == _currentMediaPath && !_isAudioPlaying) {
        // If this URL started playing, update state
        setState(() {
          _isAudioPlaying = true;
        });
        widget.onPlay?.call();
      }
    });
  }

  Future<void> _initializeLocalPlayer() async {
    if (_localPlayer != null) return;

    try {
      _localPlayer = FlutterSoundPlayer();
      await _localPlayer!.openPlayer();

      // Get initial duration if we don't have it yet
      if (_totalDuration == Duration.zero && _currentMediaPath != null) {
        Duration? duration = await _localPlayer!.startPlayer(
          fromURI: _currentMediaPath,
          whenFinished: () async {
            await _localPlayer!.stopPlayer();
          },
        );

        if (duration != null && mounted) {
          setState(() => _totalDuration = duration);
        }
        await _localPlayer!.stopPlayer();
      }
    } catch (e) {
      print('Error initializing local player: $e');
      // Clean up on error
      await _localPlayer?.closePlayer();
      _localPlayer = null;
    }
  }

  void _subscribeToProgressUpdates() {
    if (!_useExternalHandler || _currentMediaPath == null) return;

    _progressSubscription?.cancel();
    _progressSubscription =
        widget.handler!.getProgressStream(_currentMediaPath!).listen(
      (progress) {
        if (!mounted || _isDragging) return;
        setState(() {
          _totalDuration = progress.duration;
          widget.onDurationUpdate?.call(progress.position);
          if (_totalDuration.inMilliseconds > 0) {
            _progress = (progress.position.inMilliseconds /
                    _totalDuration.inMilliseconds)
                .clamp(0.0, 1.0);
          }
        });
      },
      onError: (error) {
        print('Error in progress stream: $error');
      },
    );
  }

  Future<void> _startWithHandler() async {
    await widget.handler!.stopAudio();

    await widget.handler!.playAudio(_currentMediaPath!);

    if (_initialSeekPosition != null) {
      await widget.handler!.seekTo(_initialSeekPosition!);
      _initialSeekPosition = null;
    } else if (_progress > 0) {
      final position = Duration(
        milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
      );
      await widget.handler!.seekTo(position);
    }

    _subscribeToProgressUpdates();
    setState(() => _isAudioPlaying = true);
    widget.onPlay?.call();
  }

  Future<void> _startWithLocalPlayer() async {
    if (_localPlayer == null) {
      await _initializeLocalPlayer();
    }

    if (_localPlayer == null) return;

    try {
      if (_localPlayer!.isPaused || _localPlayer!.isPlaying) {
        await _localPlayer!.stopPlayer();
      }

      await _localPlayer!
          .setSubscriptionDuration(const Duration(milliseconds: 100));

      Duration? startDuration = await _localPlayer!.startPlayer(
        fromURI: _currentMediaPath,
        whenFinished: _onPlaybackComplete,
      );

      if (startDuration != null) {
        setState(() => _totalDuration = startDuration);
      }

      if (_initialSeekPosition != null) {
        await _localPlayer!.seekToPlayer(_initialSeekPosition!);
        _initialSeekPosition = null;
      } else if (_progress > 0 && _totalDuration.inMilliseconds > 0) {
        final position = Duration(
          milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
        );
        await _localPlayer!.seekToPlayer(position);
      }

      _setupLocalPlayerProgress();
      setState(() => _isAudioPlaying = true);
      widget.onPlay?.call();
    } catch (e) {
      print('Error in _startWithLocalPlayer: $e');
      setState(() => _isAudioPlaying = false);
      widget.onPause?.call();
    }
  }

  void _onPlaybackComplete() {
    if (!mounted) return;
    _resetPlayback();
    if (_useExternalHandler) {
      widget.handler!.stopAudio();
    } else {
      _localPlayer?.stopPlayer();
    }
  }

  void _setupLocalPlayerProgress() {
    _playerSubscription?.cancel();
    _playerSubscription = _localPlayer?.onProgress?.listen(
      (e) {
        if (!mounted || _isDragging) return;

        setState(() {
          if (e.duration.inMilliseconds > 0) {
            _totalDuration = e.duration;
            widget.onDurationUpdate?.call(e.position);
            _progress = (e.position.inMilliseconds / e.duration.inMilliseconds)
                .clamp(0.0, 1.0);

            if (_progress >= 0.99) {
              _onPlaybackComplete();
            }
          }
        });
      },
      onError: (error) {
        print('Error in local player progress: $error');
        _onPlaybackComplete();
      },
    );
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_totalDuration == Duration.zero) {
        await _initializeAndGetDuration();
      }

      if (_useExternalHandler) {
        // Check current playing URL first
        String? currentPlayingUrl = widget.handler!.currentlyPlayingUrl;

        if (_isAudioPlaying) {
          // Only pause if this voice note is currently playing
          if (currentPlayingUrl == _currentMediaPath) {
            await _pausePlayback();
          } else {
            // If different voice note is playing, start this one
            await _startPlayer();
          }
        } else {
          // If nothing is playing or different voice note is paused, start fresh
          if (currentPlayingUrl == null ||
              currentPlayingUrl != _currentMediaPath) {
            await _startPlayer();
          } else {
            // If slider was moved, use that position instead of last played position
            if (_progress !=
                _lastPlayedPosition.inMilliseconds /
                    _totalDuration.inMilliseconds) {
              _lastPlayedPosition = Duration(
                milliseconds:
                    (_totalDuration.inMilliseconds * _progress).toInt(),
              );
            }
            await _resumePlayback();
          }
        }
      } else {
        // Local player logic remains the same
        if (_isAudioPlaying) {
          await _pausePlayback();
        } else {
          if (_lastPlayedPosition > Duration.zero) {
            await _resumePlayback();
          } else {
            await _startPlayer();
          }
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> _pausePlayback() async {
    try {
      if (_useExternalHandler) {
        // Verify this voice note is actually playing before pausing
        String? currentPlayingUrl = widget.handler!.currentlyPlayingUrl;
        if (currentPlayingUrl == _currentMediaPath) {
          // Store the current position before pausing
          if (_totalDuration.inMilliseconds > 0) {
            _lastPlayedPosition = Duration(
              milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
            );
          }
          await widget.handler!.pauseAudio();
          _progressSubscription?.cancel();
        }
      } else {
        if (_localPlayer?.isPlaying ?? false) {
          _lastPlayedPosition = Duration(
            milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
          );
          await _localPlayer!.pausePlayer();
        }
      }
      setState(() => _isAudioPlaying = false);
      widget.onPause?.call();
    } catch (e) {
      print('Error pausing playback: $e');
      _resetPlayback();
    }
  }

  Future<void> _resumePlayback() async {
    try {
      if (_useExternalHandler) {
        // Check if this voice note was the last one playing
        String? currentPlayingUrl = widget.handler!.currentlyPlayingUrl;
        if (currentPlayingUrl == null ||
            currentPlayingUrl != _currentMediaPath) {
          // If different or no voice note was playing, start fresh
          await _startPlayer();
          return;
        }

        await widget.handler!.resumeAudio();

        // Always use the current progress position instead of last played position
        if (_totalDuration.inMilliseconds > 0) {
          final targetPosition = Duration(
            milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
          );
          await widget.handler!.seekTo(targetPosition);
        }

        _subscribeToProgressUpdates();
      } else {
        // Local player logic
        if (_localPlayer == null) {
          await _startWithLocalPlayer();
          return;
        }

        await _localPlayer!.resumePlayer();

        // Always use the current progress position
        if (_totalDuration.inMilliseconds > 0) {
          final targetPosition = Duration(
            milliseconds: (_totalDuration.inMilliseconds * _progress).toInt(),
          );
          await _localPlayer!.seekToPlayer(targetPosition);
        }

        _setupLocalPlayerProgress();
      }

      setState(() => _isAudioPlaying = true);
      widget.onPlay?.call();
    } catch (e) {
      print('Error resuming playback: $e');
      setState(() => _isAudioPlaying = false);
      widget.onPause?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cleanupSubscriptions();
    _cleanupPlayer();
    _durationSubscription?.cancel();
    _audioStateSubscription?.cancel();

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
                color: style.iconColor ?? LMChatTheme.theme.onPrimary,
              ),
            ),
            onTap: _togglePlayPause,
            style: LMChatButtonStyle(
              height: 36,
              width: 36,
              borderRadius: 18,
              backgroundColor:
                  style.buttonColor ?? LMChatTheme.theme.secondaryColor,
            ),
          ),
          Expanded(
            child: Slider(
              value: _progress.clamp(0.0, 1.0),
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
                if (_totalDuration.inMilliseconds > 0) {
                  final currentPosition = Duration(
                    milliseconds:
                        (_totalDuration.inMilliseconds * value).toInt(),
                  );
                  if (!_isAudioPlaying) {
                    _initialSeekPosition = currentPosition;
                  }
                  widget.onDurationUpdate?.call(currentPosition);
                }
                widget.onSlide?.call(value);
              },
              onChangeStart: (value) async {
                _isDragging = true;
                if (_totalDuration == Duration.zero) {
                  await _initializeAndGetDuration();
                }
                widget.onSlideStart?.call(value);
              },
              onChangeEnd: (value) async {
                _isDragging = false;
                if (_totalDuration.inMilliseconds > 0) {
                  final position = Duration(
                    milliseconds:
                        (_totalDuration.inMilliseconds * value).toInt(),
                  );

                  if (_useExternalHandler) {
                    if (_isAudioPlaying) {
                      await widget.handler!.seekTo(position);
                    }
                  } else {
                    if (_isAudioPlaying && _localPlayer != null) {
                      await _localPlayer!.seekToPlayer(position);
                    }
                  }
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

  // Update _initializeAndGetDuration to avoid unnecessary player initialization
  Future<void> _initializeAndGetDuration() async {
    if (_totalDuration != Duration.zero || _currentMediaPath == null) return;

    try {
      if (_useExternalHandler) {
        final duration = await widget.handler!.getDuration(_currentMediaPath!);
        if (duration != null && mounted) {
          setState(() => _totalDuration = duration);
          widget.onDurationUpdate?.call(duration);
        }
      } else {
        // Create a temporary player just for getting duration
        final tempPlayer = FlutterSoundPlayer();
        await tempPlayer.openPlayer();

        Duration? duration = await tempPlayer.startPlayer(
          fromURI: _currentMediaPath,
          whenFinished: () async {
            await tempPlayer.stopPlayer();
          },
        );

        await tempPlayer.stopPlayer();
        await tempPlayer.closePlayer();

        if (duration != null && mounted) {
          setState(() => _totalDuration = duration);
          widget.onDurationUpdate?.call(duration);
        }
      }
    } catch (e) {
      print('Error getting duration: $e');
      if (mounted) {
        setState(() => _totalDuration = Duration.zero);
      }
    }
  }

  // Add method to reset playback state
  void _resetPlayback() {
    setState(() {
      _isAudioPlaying = false;
      _progress = 0.0;
      _lastPlayedPosition = Duration.zero;
      widget.onDurationUpdate?.call(Duration.zero);
    });
    widget.onPause?.call();
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

  /// The color of the button.
  final Color? buttonColor;

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
    this.buttonColor,
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
    Color? buttonColor,
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
      buttonColor: buttonColor ?? this.buttonColor,
    );
  }
}
