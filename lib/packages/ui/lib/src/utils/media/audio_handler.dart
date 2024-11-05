import 'package:flutter_sound/flutter_sound.dart';

/// Class to hold playback progress information
class PlaybackProgress {
  final Duration duration;
  final Duration position;

  const PlaybackProgress({
    required this.duration,
    required this.position,
  });
}

/// Abstract class defining the interface for audio handling operations
abstract class LMChatAudioHandler {
  /// Instance of the player
  FlutterSoundPlayer get player;

  /// Instance of the recorder
  FlutterSoundRecorder get recorder;

  /// Stream of currently playing audio URL
  Stream<String> get currentlyPlayingUrl;

  /// Stream of playback progress updates
  // Stream<PlaybackProgress> get playbackProgress;

  /// Initializes the audio handler
  Future<void> init();

  /// Disposes of audio resources
  Future<void> dispose();

  /// Starts recording audio to the specified path
  Future<String?> startRecording();

  /// Stops the current audio recording
  Future<String?> stopRecording();

  Future<void> cancelRecording();

  /// Plays audio from the specified path
  Future<void> playAudio(String path);

  /// Stops the currently playing audio
  Future<void> stopAudio();

  /// Pauses the currently playing audio
  Future<void> pauseAudio();

  /// Resumes the paused audio
  Future<void> resumeAudio();

  /// Seeks to a specific position in the audio
  Future<void> seekTo(Duration position);

  /// Get progress stream for specific audio URL
  Stream<PlaybackProgress> getProgressStream(String audioUrl);
}
