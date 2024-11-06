import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/permission_handler.dart';

/// A class to manage all audio recording and playing
class LMChatCoreAudioHandler implements LMChatAudioHandler {
  static final LMChatAudioHandler _instance =
      LMChatCoreAudioHandler._internal();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isPlayerInitialized = false;
  bool _isRecorderInitialized = false;
  bool _hasRecordingPermission = true;

  // Stream controller for currently playing URL
  final _currentlyPlayingController = StreamController<String>.broadcast();
  String? _currentlyPlayingUrl;

  // Map to store progress controllers for each audio URL
  final _progressControllers = <String, StreamController<PlaybackProgress>>{};
  StreamSubscription? _currentProgressSubscription;

  // Add these new variables for recording management
  String? _currentRecordingPath;
  bool _isRecording = false;
  final _recordingLevelController = StreamController<double>.broadcast();

  // Getters for recording state
  bool get isRecording => _isRecording;
  Stream<double> get recordingLevel => _recordingLevelController.stream;
  String? get currentRecordingPath => _currentRecordingPath;

  // Add codec constant only for recording
  static const Codec _recordingCodec = Codec.aacADTS;

  // Add this to store the last known duration
  Duration? _lastKnownDuration;

  // Add a map to store durations for each audio path
  final Map<String, Duration> _audioDurations = {};

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

  /// Returns whether recording permission is granted
  bool get hasRecordingPermission => _hasRecordingPermission;

  /// Initializes the audio player and recorder with proper permission checks
  @override
  Future<void> init() async {
    // Initialize player first as it doesn't need permissions
    if (!_isPlayerInitialized) {
      await _player.openPlayer();
      _isPlayerInitialized = true;
    }

    // // Check for microphone permission before initializing recorder
    // _hasRecordingPermission = await handlePermissions(3); // 3 is for microphone

    if (_hasRecordingPermission && !_isRecorderInitialized) {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    }
  }

  // Request microphone permission and initialize recorder if not already initialized
  Future<bool> requestRecordingPermission() async {
    _hasRecordingPermission = await handlePermissions(3);

    if (_hasRecordingPermission && !_isRecorderInitialized) {
      try {
        await _recorder.openRecorder();
        _isRecorderInitialized = true;
      } catch (e) {
        print('Error initializing recorder: $e');
        _hasRecordingPermission = false;
      }
    }

    return _hasRecordingPermission;
  }

  /// Starts a new recording session
  @override
  Future<String?> startRecording() async {
    // Stop any playing audio before starting recording
    await stopAudio();

    // Check and request permissions first
    _hasRecordingPermission = await handlePermissions(3); // 3 for microphone
    if (!_hasRecordingPermission) {
      throw Exception('Recording permission not granted');
    }

    if (!_isRecorderInitialized) {
      await init();
    }

    try {
      await _cleanupOldRecordings();
      _currentRecordingPath = await _generateRecordingPath();

      await _recorder.startRecorder(
        toFile: _currentRecordingPath,
        codec: _recordingCodec,
      );

      _isRecording = true;
      _lastKnownDuration = null; // Reset duration on start
      return _currentRecordingPath;
    } catch (e) {
      print('Error starting recording: $e');
      _currentRecordingPath = null;
      _isRecording = false;
      return null;
    }
  }

  /// Stops the current recording and returns the file path
  /// [recordedDuration] should be provided from the UI timer
  @override
  Future<String?> stopRecording({Duration? recordedDuration}) async {
    if (!_isRecording) return null;

    try {
      final String? path = await _recorder.stopRecorder();
      _isRecording = false;

      if (path != null) {
        final File recordingFile = File(path);
        if (await recordingFile.exists()) {
          // Store the duration provided by the UI timer
          _lastKnownDuration = recordedDuration;

          // Initialize progress controller with the known duration
          if (_lastKnownDuration != null) {
            _progressControllers[path] =
                StreamController<PlaybackProgress>.broadcast();
            _updateProgress(
              path,
              PlaybackProgress(
                duration: _lastKnownDuration!,
                position: Duration.zero,
              ),
            );
          }

          return path;
        }
      }
      return null;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    } finally {
      _currentRecordingPath = null;
      _isRecording = false;
    }
  }

  /// Get the last known duration of the recording
  Duration? getLastRecordingDuration() => _lastKnownDuration;

  /// Cancels and deletes the current recording
  @override
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.stopRecorder();
      if (_currentRecordingPath != null) {
        final File recordingFile = File(_currentRecordingPath!);
        if (await recordingFile.exists()) {
          await recordingFile.delete();
        }
      }
    } catch (e) {
      print('Error canceling recording: $e');
    } finally {
      _currentRecordingPath = null;
      _isRecording = false;
    }
  }

  /// Checks if a file is a valid audio file
  Future<bool> isValidAudioFile(String path) async {
    try {
      final File file = File(path);
      if (!await file.exists()) return false;

      final int fileSize = await file.length();
      if (fileSize < 100) return false; // Arbitrary minimum size

      // Try to get audio duration as validation
      final Duration? duration = await _player.startPlayer(
        fromURI: path,
        codec: Codec.flac,
      );

      await _player.stopPlayer();

      return duration != null && duration.inMilliseconds > 0;
    } catch (e) {
      print('Error validating audio file: $e');
      return false;
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

    try {
      // Stop any current playback and clear state
      await stopAudio();

      _currentlyPlayingUrl = path;
      _currentlyPlayingController.add(path);

      bool isLocalFile = path.startsWith('/');

      // Store duration for this specific path
      if (isLocalFile) {
        final File audioFile = File(path);
        if (!await audioFile.exists()) {
          throw Exception('Audio file not found');
        }

        await _player.startPlayer(
          fromURI: path,
          codec: _recordingCodec,
          whenFinished: () async {
            await _onPlaybackComplete(path);
          },
        );
      } else {
        await _player.startPlayer(
          fromURI: path,
          whenFinished: () async {
            await _onPlaybackComplete(path);
          },
        );
      }

      // Set up progress tracking for this specific path
      _setupProgressTracking(path);
    } catch (e) {
      print('Error playing audio: $e');
      await _onPlaybackError(path);
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
          // Reset progress for the current URL
          _updateProgress(
            _currentlyPlayingUrl!,
            PlaybackProgress(
              duration: _audioDurations[_currentlyPlayingUrl!] ?? Duration.zero,
              position: Duration.zero,
            ),
          );
        }
      }

      // Clear current playback state
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

  /// Disposes of all resources
  @override
  Future<void> dispose() async {
    try {
      // Stop any ongoing playback or recording
      if (_isRecording) {
        await cancelRecording();
      }
      await stopAudio();

      // Clean up player resources
      await _currentProgressSubscription?.cancel();
      if (_isPlayerInitialized) {
        await _player.closePlayer();
        _isPlayerInitialized = false;
      }

      // Clean up recorder resources
      if (_isRecorderInitialized) {
        await _recorder.closeRecorder();
        _isRecorderInitialized = false;
      }

      // Clear all stored state and controllers
      _audioDurations.clear();
      for (final controller in _progressControllers.values) {
        await controller.close();
      }
      _progressControllers.clear();

      await _currentlyPlayingController.close();
      _currentlyPlayingUrl = null;
      _hasRecordingPermission = false;
      await _recordingLevelController.close();

      // Clean up any temporary files
      await _cleanupOldRecordings();
    } catch (e) {
      print('Error in dispose: $e');
    }
  }

  // @override
  // // TODO: implement playbackProgress
  // Stream<PlaybackProgress> get playbackProgress => throw UnimplementedError();

  Future<void> _onPlaybackComplete(String path) async {
    await _player.stopPlayer();

    // Store final duration before clearing state
    final duration = _audioDurations[path] ?? Duration.zero;

    // Clear state for this path
    _currentlyPlayingUrl = null;
    _currentlyPlayingController.add('');

    // Reset progress with the stored duration
    _updateProgress(
      path,
      PlaybackProgress(
        duration: duration,
        position: Duration.zero,
        isCompleted: true,
      ),
    );

    await _currentProgressSubscription?.cancel();
    _currentProgressSubscription = null;
  }

  Future<void> _onPlaybackError(String path) async {
    _currentlyPlayingUrl = null;
    _currentlyPlayingController.add('');
    await _currentProgressSubscription?.cancel();
    _currentProgressSubscription = null;
    _updateProgress(
      path,
      const PlaybackProgress(
        duration: Duration.zero,
        position: Duration.zero,
      ),
    );
  }

  void _setupProgressTracking(String path) {
    _currentProgressSubscription?.cancel();
    _player.setSubscriptionDuration(const Duration(milliseconds: 100));

    _currentProgressSubscription = _player.onProgress!.listen(
      (e) {
        if (_currentlyPlayingUrl == path) {
          // Store duration for this path
          _audioDurations[path] = e.duration;

          _updateProgress(
            path,
            PlaybackProgress(
              duration: e.duration,
              position: e.position,
            ),
          );
        }
      },
      onError: (error) {
        print('Progress tracking error: $error');
        _onPlaybackError(path);
      },
    );
  }

  // Helper method to generate unique file path for recordings
  Future<String> _generateRecordingPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String recordingDir = '${appDir.path}/recordings';
    await Directory(recordingDir).create(recursive: true);

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '$recordingDir/recording_$timestamp.aac';
  }

  // Helper method to clean up old recordings
  Future<void> _cleanupOldRecordings() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String recordingDir = '${appDir.path}/recordings';
      final Directory directory = Directory(recordingDir);

      if (await directory.exists()) {
        // Delete files older than 24 hours
        final cutoffDate = DateTime.now().subtract(const Duration(hours: 24));

        await for (final FileSystemEntity file in directory.list()) {
          if (file is File) {
            final FileStat stat = await file.stat();
            if (stat.modified.isBefore(cutoffDate)) {
              await file.delete();
            }
          }
        }
      }
    } catch (e) {
      print('Error cleaning up recordings: $e');
    }
  }
}
