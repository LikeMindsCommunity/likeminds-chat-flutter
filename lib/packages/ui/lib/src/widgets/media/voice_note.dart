import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

///{@template lm_chat_audio}
/// A widget to display and control audio playback in the LMChat UI.
/// The [media] parameter is required and contains the audio data.
/// {@endtemplate}
class LMChatVoiceNote extends StatefulWidget {
  /// {@macro lm_chat_audio}
  const LMChatVoiceNote({
    super.key,
    required this.media,
    this.style,
    this.autoplay,
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

  /// The bool to control whether audio autoplays or not
  final bool? autoplay;

  @override
  State<LMChatVoiceNote> createState() => _LMChatVoiceNoteState();
}

class _LMChatVoiceNoteState extends State<LMChatVoiceNote> {
  bool _isAudioPlaying = false;
  double _progress = 0.0; // Progress of the audio playback

  @override
  void initState() {
    super.initState();
    _isAudioPlaying = widget.autoplay ?? false;
  }

  void _togglePlayPause() {
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
      // Add audio play/pause logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const LMChatAudioStyle();
    return Container(
      width: style.width,
      height: style.height,
      color: style.backgroundColor,
      padding: style.padding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
          ),
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
                  // Add logic to seek audio to the new position
                });
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
class LMChatAudioStyle {
  /// The width of the audio container.
  final double? width;

  /// The height of the audio container.
  final double? height;

  /// The background color of the audio container.
  final Color? backgroundColor;

  /// The color of the play/pause icon.
  final Color? iconColor;

  final EdgeInsets? padding;

  /// Slider customization properties
  final double sliderMin;
  final double sliderMax;
  final int? sliderDivisions;
  final Color? sliderActiveColor;
  final Color? sliderInactiveColor;
  final Color? sliderThumbColor;

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

  factory LMChatAudioStyle.basic() {
    return const LMChatAudioStyle();
  }

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
