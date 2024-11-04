import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// A class to manage all audio recording and playing
class LMChatCoreAudioHandler implements LMChatAudioHandler {
  static final LMChatAudioHandler _instance =
      LMChatCoreAudioHandler._internal();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isPlayerInitialized = false;
  bool _isRecorderInitialized = false;

  // Stream controller for currently playing URL
  final _currentlyPlayingController = StreamController<String>.broadcast();
  String? _currentlyPlayingUrl;

  // Map to store progress controllers for each audio URL
  final _progressControllers = <String, StreamController<PlaybackProgress>>{};
  StreamSubscription? _currentProgressSubscription;

  LMChatCoreAudioHandler._internal();

  /// Returns the singleton instance of [LMChatAudioHandler].
  static LMChatAudioHandler get instance => _instance;

  /// Stream of currently playing audio URL
  @override
  Stream<String> get currentlyPlayingUrl => _currentlyPlayingController.stream;

  /// Returns the instance of [FlutterSoundPlayer] player
  @override
  FlutterSoundPlayer get player => _player;

  /// Returns the instance of [FlutterSoundRecorder] recorder
  @override
  FlutterSoundRecorder get recorder => _recorder;

  /// Initializes the audio player and recorder.
  @override
  Future<void> init() async {
    if (!_isPlayerInitialized) {
      await _player.openPlayer();
      _isPlayerInitialized = true;
    }
    if (!_isRecorderInitialized) {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    }
  }

  /// Get progress stream for specific audio URL
  @override
  Stream<PlaybackProgress> getProgressStream(String audioUrl) {
    _progressControllers[audioUrl] ??=
        StreamController<PlaybackProgress>.broadcast();
    return _progressControllers[audioUrl]!.stream;
  }

  /// Plays audio from the specified [path].
  @override
  Future<void> playAudio(String path) async {
    if (!_isPlayerInitialized) {
      await init();
    }

    // If same audio is playing, do nothing
    if (_currentlyPlayingUrl == path && _player.isPlaying) {
      return;
    }

    try {
      // Always stop current playback before starting new one
      if (_player.isPlaying || _player.isPaused) {
        // Stop any currently playing or paused audio
        await _player.stopPlayer();

        // Reset previous audio's progress if it's different from the new one
        if (_currentlyPlayingUrl != null && _currentlyPlayingUrl != path) {
          _updateProgress(
            _currentlyPlayingUrl!,
            const PlaybackProgress(
              duration: Duration.zero,
              position: Duration.zero,
            ),
          );
        }
      }

      _currentlyPlayingUrl = path;
      _currentlyPlayingController.add(path);

      await _player.startPlayer(
        fromURI: path,
        codec: Codec.flac,
        whenFinished: () async {
          await _player.stopPlayer();
          _currentlyPlayingUrl = null;
          _currentlyPlayingController.add('');
          // Only reset progress when audio completes naturally
          _updateProgress(
            path,
            const PlaybackProgress(
              duration: Duration.zero,
              position: Duration.zero,
            ),
          );
          await _currentProgressSubscription?.cancel();
          _currentProgressSubscription = null;
        },
      );

      // Set up progress tracking
      await _currentProgressSubscription?.cancel();
      _player.setSubscriptionDuration(const Duration(milliseconds: 100));
      _currentProgressSubscription = _player.onProgress!.listen((e) {
        if (_currentlyPlayingUrl == path) {
          _updateProgress(
            path,
            PlaybackProgress(
              duration: e.duration,
              position: e.position,
            ),
          );
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      _currentlyPlayingUrl = null;
      _currentlyPlayingController.add('');
      await _currentProgressSubscription?.cancel();
      _currentProgressSubscription = null;
    }
  }

  /// Pauses the currently playing audio.
  @override
  Future<void> pauseAudio() async {
    if (!_isPlayerInitialized) return;

    try {
      if (_player.isPlaying) {
        await _player.pausePlayer();
        // Just notify that playback is paused, don't change the URL or progress
        _currentlyPlayingController.add('');
      }
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Resumes the paused audio.
  @override
  Future<void> resumeAudio() async {
    if (!_isPlayerInitialized || _currentlyPlayingUrl == null) return;

    try {
      if (_player.isPaused) {
        await _player.resumePlayer();
        // Restore the current URL to indicate playback
        _currentlyPlayingController.add(_currentlyPlayingUrl!);
      }
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Stops the currently playing audio.
  @override
  Future<void> stopAudio() async {
    if (!_isPlayerInitialized) return;

    try {
      if (_player.isPlaying || _player.isPaused) {
        await _player.stopPlayer();

        if (_currentlyPlayingUrl != null) {
          // Reset progress only when stopping
          _updateProgress(
            _currentlyPlayingUrl!,
            const PlaybackProgress(
              duration: Duration.zero,
              position: Duration.zero,
            ),
          );
        }
      }

      _currentlyPlayingUrl = null;
      _currentlyPlayingController.add('');
      await _currentProgressSubscription?.cancel();
      _currentProgressSubscription = null;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Seeks to a specific position in the audio
  @override
  Future<void> seekTo(Duration position) async {
    if (!_isPlayerInitialized) return;

    try {
      await _player.seekToPlayer(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  void _updateProgress(String audioUrl, PlaybackProgress progress) {
    _progressControllers[audioUrl]?.add(progress);
  }

  /// Starts recording audio to the specified path
  @override
  Stream startRecording(String path) {
    if (!_isRecorderInitialized) {
      throw Exception('Recorder not initialized');
    }
    return _recorder.startRecorder(toFile: path).asStream();
  }

  /// Stops the current audio recording
  @override
  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) {
      throw Exception('Recorder not initialized');
    }
    await _recorder.stopRecorder();
  }

  /// Disposes of all resources
  @override
  Future<void> dispose() async {
    await stopAudio();
    await _currentProgressSubscription?.cancel();

    if (_isPlayerInitialized) {
      await _player.closePlayer();
      _isPlayerInitialized = false;
    }

    if (_isRecorderInitialized) {
      await _recorder.closeRecorder();
      _isRecorderInitialized = false;
    }

    for (final controller in _progressControllers.values) {
      await controller.close();
    }
    _progressControllers.clear();

    await _currentlyPlayingController.close();
    _currentlyPlayingUrl = null;
  }

  // @override
  // // TODO: implement playbackProgress
  // Stream<PlaybackProgress> get playbackProgress => throw UnimplementedError();
}
