import 'package:flutter_sound/flutter_sound.dart';

/// A class to manage all audio recording and playing
///
/// Gives access to functions that handles media picking natively
class LMChatAudioHandler {
  static final LMChatAudioHandler _instance = LMChatAudioHandler._internal();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isPlayerInitialized = false;
  bool _isRecorderInitialized = false;

  LMChatAudioHandler._internal();

  /// Returns the singleton instance of [LMChatAudioHandler].
  static LMChatAudioHandler get instance => _instance;

  /// Initializes the audio player and recorder.
  Future<void> init() async {
    await _player.openPlayer();
    _isPlayerInitialized = true;
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  /// Disposes of the audio player and recorder, closing them if initialized.
  Future<void> dispose() async {
    if (_isPlayerInitialized) {
      await _player.closePlayer();
      _isPlayerInitialized = false;
    }
    if (_isRecorderInitialized) {
      await _recorder.closeRecorder();
      _isRecorderInitialized = false;
    }
  }

  /// Starts recording audio to the specified [path].
  ///
  /// Throws an exception if the recorder is not initialized.
  Future<void> startRecording(String path) async {
    if (!_isRecorderInitialized) {
      throw Exception('Recorder not initialized');
    }
    await _recorder.startRecorder(toFile: path);
  }

  /// Stops the audio recording.
  ///
  /// Throws an exception if the recorder is not initialized.
  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) {
      throw Exception('Recorder not initialized');
    }
    await _recorder.stopRecorder();
  }

  /// Plays audio from the specified [path].
  ///
  /// Throws an exception if the player is not initialized.
  Future<void> playAudio(String path) async {
    if (!_isPlayerInitialized) {
      throw Exception('Player not initialized');
    }
    await _player.startPlayer(fromURI: path);
  }

  /// Stops the currently playing audio.
  ///
  /// Throws an exception if the player is not initialized.
  Future<void> stopAudio() async {
    if (!_isPlayerInitialized) {
      throw Exception('Player not initialized');
    }
    await _player.stopPlayer();
  }
}
