import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';

/// Enum to represent audio states
enum LMChatAudioState { stopped, recording, playing, paused }

/// Class to hold playback progress information
class PlaybackProgress {
  final Duration duration;
  final Duration position;
  final bool isCompleted;

  const PlaybackProgress({
    required this.duration,
    required this.position,
    this.isCompleted = false,
  });
}

/// Abstract class defining the interface for audio handling operations
abstract class LMChatAudioHandler {
  /// Instance of the player
  FlutterSoundPlayer get player;

  /// Instance of the recorder
  FlutterSoundRecorder get recorder;

  /// Stream of currently playing audio URL
  Stream<String> get currentlyPlayingStream;

  /// Currently playing URL
  String? get currentlyPlayingUrl;

  /// Stream of audio state changes
  Stream<LMChatAudioState> get audioStateStream;

  /// Initializes the audio handler
  Future<void> init();

  /// Disposes of audio resources
  Future<void> dispose();

  /// Starts recording audio to the specified path
  Future<String?> startRecording();

  /// Stops the current audio recording and notifies state change
  Future<String?> stopRecording({Duration? recordedDuration});

  /// Cancels the current recording and notifies state change
  Future<void> cancelRecording();

  /// Plays audio from the specified path
  Future<void> playAudio(String path);

  /// Stops the currently playing audio and notifies state change
  Future<void> stopAudio();

  /// Pauses the currently playing audio
  Future<void> pauseAudio();

  /// Resumes the paused audio
  Future<void> resumeAudio();

  /// Seeks to a specific position in the audio
  Future<void> seekTo(Duration position);

  /// Get progress stream for specific audio URL
  Stream<PlaybackProgress> getProgressStream(String audioUrl);

  /// Gets the duration of an audio file without playing it
  Future<Duration?> getDuration(String path);

  /// Get duration updates stream for specific audio path
  Stream<Duration> getDurationStream(String path);
}
