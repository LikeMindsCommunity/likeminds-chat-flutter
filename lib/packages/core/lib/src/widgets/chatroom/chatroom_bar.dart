import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/text_field/text_field.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar_header.dart';
import 'package:flutter/services.dart';

/// {@template lm_chatroom_bar}
/// A widget to display the chatroom bar.
/// It has a text field to type the message and send button.
/// {@endtemplate}
class LMChatroomBar extends StatefulWidget {
  /// [chatroom] is the chatroom for which the bar is to be displayed.
  final LMChatRoomViewData chatroom;

  /// [scrollToBottom] is the function to scroll to the bottom of the chat.
  final VoidCallback scrollToBottom;

  /// [controller] is an optional [TextEditingController] that can be used to control the text input field.
  /// If provided, it allows external management of the text input, such as setting the text or listening for changes.
  final TextEditingController? controller;

  /// Indicates whether tagging is enabled in the chatroom bar.
  /// If true, users can tag other users in their messages.
  final bool? enableTagging;

  /// [createPollWidgetBuilder] is the builder to create the poll widget.
  final Widget Function(BuildContext, LMChatCreatePollBottomSheet)?
      createPollWidgetBuilder;

  /// {@macro lm_chatroom_bar}
  const LMChatroomBar({
    super.key,
    required this.chatroom,
    required this.scrollToBottom,
    this.createPollWidgetBuilder,
    this.controller,
    this.enableTagging,
  });

  LMChatroomBar copyWith(
      {LMChatRoomViewData? chatroom,
      VoidCallback? scrollToBottom,
      Widget Function(BuildContext, LMChatCreatePollBottomSheet)?
          createPollWidgetBuilder}) {
    return LMChatroomBar(
      chatroom: chatroom ?? this.chatroom,
      scrollToBottom: scrollToBottom ?? this.scrollToBottom,
      createPollWidgetBuilder:
          createPollWidgetBuilder ?? this.createPollWidgetBuilder,
    );
  }

  @override
  State<LMChatroomBar> createState() => _LMChatroomBarState();
}

class _LMChatroomBarState extends State<LMChatroomBar> {
  LMChatConversationViewData? replyToConversation;
  List<LMChatAttachmentViewData>? replyConversationAttachments;
  LMChatConversationViewData? editConversation;

  // Flutter and other dependecies needed
  final CustomPopupMenuController _popupMenuController =
      CustomPopupMenuController();
  late final TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();

  // Instances of BLoCs required
  LMChatConversationActionBloc chatActionBloc =
      LMChatConversationActionBloc.instance;
  LMChatConversationBloc conversationBloc = LMChatConversationBloc.instance;

  // Instance of current user and member state
  final LMChatUserViewData currentUser =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  final MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();
  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;
  final _screenBuilder = LMChatCore.config.chatRoomConfig.builder;

  String? result;

  String previewLink = '';

  LMChatRoomViewData? chatroom;
  List<LMChatTagViewData> tags = [];
  LMChatMediaModel? linkModel;

  /// if set to false link preview should not be displayed
  bool showLinkPreview = true;

  /// if a message contains a link, this should be set to true
  bool isActiveLink = false;

  /// debounce timer for link preview
  Timer? _debounce;

  /// flag to check if a message is sent before the link preview is fetched
  bool _isSentBeforeLinkFetched = false;

  // Create a ValueNotifier to hold the text input state
  final ValueNotifier<String> _textInputNotifier = ValueNotifier<String>('');

  // Create a ValueNotifier to hold the voice button state
  final ValueNotifier<bool> _isVoiceButtonHeld = ValueNotifier<bool>(false);

  // Add these variables for recording state
  Timer? _recordingTimer;
  final ValueNotifier<Duration> _recordingDuration =
      ValueNotifier(Duration.zero);
  final ValueNotifier<double> _cancelSlidePosition = ValueNotifier(0.0);

  // Add this variable to track the current recording path
  String? _currentRecordingPath;

  // Add these variables for recording state management
  final ValueNotifier<bool> _isReviewingRecording = ValueNotifier<bool>(false);
  final ValueNotifier<PlaybackProgress> _playbackProgress = ValueNotifier(
    const PlaybackProgress(duration: Duration.zero, position: Duration.zero),
  );
  String? _recordedFilePath;

  // Add isPlaying ValueNotifier
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);

  String getText() {
    if (_textEditingController.text.isNotEmpty) {
      return _textEditingController.text;
    } else {
      return "";
    }
  }

  void _onTextChanged(String message) {
    _textInputNotifier.value = message; // Update the ValueNotifier
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (!showLinkPreview ||
        replyToConversation != null ||
        editConversation != null) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      chatActionBloc.add(LMChatConversationTextChangeEvent(
        text: message,
        previousLink: previewLink,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    chatroom = widget.chatroom;
    _textEditingController = widget.controller ?? TextEditingController();
    _textEditingController.addListener(() {
      _onTextChanged(_textEditingController.text); // Notify on text change
    });
  }

  @override
  void dispose() {
    _popupMenuController.dispose();
    _textEditingController.removeListener(() {
      _onTextChanged(_textEditingController.text); // Clean up listener
    });
    _textEditingController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _textInputNotifier.dispose(); // Dispose the ValueNotifier
    _recordingTimer?.cancel();
    _recordingDuration.dispose();
    _cancelSlidePosition.dispose();
    _isReviewingRecording.dispose();
    _playbackProgress.dispose();
    _isVoiceButtonHeld.dispose();
    _isPlaying.dispose(); // Dispose isPlaying notifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Existing UI components
        BlocConsumer<LMChatConversationActionBloc,
            LMChatConversationActionState>(
          bloc: chatActionBloc,
          listener: _blocListener,
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 2.w,
                    right: 2.w,
                    top: 1.5.h,
                    bottom: 1.5.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _isVoiceButtonHeld,
                        builder: (context, isHeld, child) {
                          return isHeld || _isReviewingRecording.value
                              ? _defRecordingContainer(context)
                              : _isRespondingAllowed()
                                  ? _defTextField(context)
                                  : _defDisabledTextField(context);
                        },
                      ),
                      _isRespondingAllowed()
                          ? ValueListenableBuilder<bool>(
                              valueListenable: _isReviewingRecording,
                              builder: (context, isReviewing, child) {
                                return ValueListenableBuilder<String>(
                                  valueListenable: _textInputNotifier,
                                  builder: (context, text, child) {
                                    return text.trim().isEmpty && !isReviewing
                                        ? _defVoiceButton(context)
                                        : _screenBuilder.sendButton(
                                            context,
                                            _textEditingController,
                                            _onSend,
                                            _defSendButton(context),
                                          );
                                  },
                                );
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Show overlay when button is held
      ],
    );
  }

  Widget _defTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (editConversation != null)
          _screenBuilder.editTextTextFieldHeader(
            context,
            _textEditingController,
            _defEditConversationWidget(),
          ),
        if (replyToConversation != null)
          _screenBuilder.replyTextFieldHeader(
            context,
            _textEditingController,
            _defReplyConversationWidget(),
          ),
        if (isActiveLink &&
            replyToConversation == null &&
            editConversation == null &&
            !_isSentBeforeLinkFetched)
          _screenBuilder.linkPreviewBar(
            context,
            _defLinkPreview(linkModel!.ogTags!),
          ),
        Container(
          width: 80.w,
          constraints: BoxConstraints(
            minHeight: 5.2.h,
            maxHeight: 24.h,
          ),
          decoration: BoxDecoration(
            color: _themeData.container,
            borderRadius: editConversation == null &&
                    replyToConversation == null &&
                    !isActiveLink
                ? BorderRadius.circular(24)
                : const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _screenBuilder.chatroomTextField(
                    context,
                    _textEditingController,
                    _defInnerTextField(context),
                  ),
                ),
                const SizedBox(width: 2),
                _defAttachmentButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget functions for the default widgets of LMChatroomBar
  Widget _defDisabledTextField(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(
        minHeight: 4.h,
        maxHeight: 6.h,
      ),
      decoration: BoxDecoration(
        color: _themeData.container,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingSmall,
          vertical: kPaddingSmall,
        ),
        child: LMChatTextField(
          isDown: false,
          enabled: false,
          isSecret: widget.chatroom.isSecret ?? false,
          chatroomId: widget.chatroom.id,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          onTagSelected: (tag) {},
          onChange: (value) {},
          controller: _textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabled: false,
            hintMaxLines: 1,
            hintStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
            hintText: _getChatBarHintText(),
          ),
          focusNode: FocusNode(),
        ),
      ),
    );
  }

  LMChatTextField _defInnerTextField(BuildContext context) {
    return LMChatTextField(
      key: const ObjectKey('chatTextField'),
      isDown: false,
      enabled: widget.enableTagging ?? true,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      isSecret: widget.chatroom.isSecret ?? false,
      chatroomId: widget.chatroom.id,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
      onTagSelected: (tag) {
        tags.add(tag);
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.userTagsSomeone,
            eventProperties: {
              'community_id': widget.chatroom.id,
              'chatroom_name': widget.chatroom.header,
              'tagged_user_id': tag.sdkClientInfoViewData?.uuid,
              'tagged_user_name': tag.name,
            },
          ),
        );
      },
      onChange: _onTextChanged,
      controller: _textEditingController,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabled: true,
        hintMaxLines: 1,
        hintStyle: const TextStyle(fontSize: 14),
        hintText: _getChatBarHintText(),
      ),
      focusNode: _focusNode,
    );
  }

  Widget _defRecordingContainer(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isReviewingRecording,
      builder: (context, isReviewing, child) {
        return isReviewing
            ? _buildReviewContainer(context)
            : _buildRecordingContainer(context);
      },
    );
  }

  Widget _buildRecordingContainer(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _cancelSlidePosition.value += details.delta.dx;
        if (_cancelSlidePosition.value < -100) {
          HapticFeedback.heavyImpact();
          _isVoiceButtonHeld.value = false;
          _stopRecordingTimer();
          toast("Recording cancelled");
        } else if (_cancelSlidePosition.value < -50) {
          HapticFeedback.selectionClick();
        }
      },
      child: Container(
        width: 80.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: _themeData.container,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildRecordingIndicator(),
                  ),
                  ValueListenableBuilder<Duration>(
                    valueListenable: _recordingDuration,
                    builder: (context, duration, child) {
                      return Text(
                        "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: _cancelSlidePosition,
              builder: (context, position, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: _themeData.inActiveColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Slide to cancel",
                        style: TextStyle(
                          fontSize: 12,
                          color: _themeData.inActiveColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContainer(BuildContext context) {
    return Container(
      width: 80.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: _themeData.container,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isPlaying,
            builder: (context, isPlaying, child) {
              return IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  color: _themeData.onContainer,
                  size: 28,
                ),
                onPressed: () => _handlePlayPause(),
              );
            },
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<PlaybackProgress>(
            valueListenable: _playbackProgress,
            builder: (context, progress, child) {
              final position = progress.position;
              final duration = progress.duration;
              return Text(
                "${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / "
                "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: _themeData.inActiveColor,
            ),
            onPressed: () => _handleDeleteRecording(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // Add these methods to handle the review actions
  void _handlePlayPause() async {
    if (_recordedFilePath == null) return;

    final audioHandler = LMChatCoreAudioHandler.instance;
    try {
      if (_isPlaying.value) {
        await audioHandler.pauseAudio();
        _isPlaying.value = false;
      } else {
        if (audioHandler.player.isPaused) {
          await audioHandler.resumeAudio();
        } else {
          // Reset position to 0 when starting new playback
          _playbackProgress.value = PlaybackProgress(
            duration: _playbackProgress.value.duration,
            position: Duration.zero,
          );
          await audioHandler.playAudio(_recordedFilePath!);
        }
        _isPlaying.value = true;
      }
    } catch (e) {
      print('Error handling play/pause: $e');
      _isPlaying.value = false;
    }
  }

  void _handleSeek(Duration position) async {
    if (_recordedFilePath == null) return;
    try {
      await LMChatCoreAudioHandler.instance.seekTo(position);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  void _handleSendRecording() {
    if (_recordedFilePath == null) return;
    // TODO: Implement sending the recording
    print("Sending recording: $_recordedFilePath");
    _resetRecordingState();
  }

  void _handleDeleteRecording() async {
    if (_recordedFilePath == null) return;

    try {
      final audioHandler = LMChatCoreAudioHandler.instance;
      if (_isPlaying.value) {
        await audioHandler.stopAudio();
        _isPlaying.value = false;
      }

      final file = File(_recordedFilePath!);
      if (await file.exists()) {
        await file.delete();
      }

      _resetRecordingState();
    } catch (e) {
      print('Error deleting recording: $e');
    }
  }

  // Also update the reset state method to be more thorough
  void _resetRecordingState() {
    _isReviewingRecording.value = false;
    _isVoiceButtonHeld.value = false;
    _recordedFilePath = null;
    _playbackProgress.value = const PlaybackProgress(
      duration: Duration.zero,
      position: Duration.zero,
    );
    _cancelSlidePosition.value = 0;
    _recordingDuration.value = Duration.zero;
    _isPlaying.value = false;
  }

  LMChatButton _defSendButton(BuildContext context) {
    return LMChatButton(
      onTap: _onSend,
      style: LMChatButtonStyle(
        backgroundColor: _themeData.primaryColor,
        borderRadius: 100,
        height: 6.h,
        width: 6.h,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.send,
        style: LMChatIconStyle(
          size: 28,
          boxSize: 28,
          boxPadding: const EdgeInsets.only(left: 2),
          color: _themeData.container,
        ),
      ),
    );
  }

  LMChatButton _defVoiceButton(BuildContext context) {
    return LMChatButton(
      onTap: () {
        HapticFeedback.lightImpact();
        toast(
          "Hold to start recording",
          duration: const Duration(milliseconds: 200),
        );
      },
      onLongPress: () async {
        final audioHandler = LMChatCoreAudioHandler.instance;

        try {
          HapticFeedback.heavyImpact();
          _currentRecordingPath = await audioHandler.startRecording();
          if (_currentRecordingPath != null) {
            _isVoiceButtonHeld.value = true;
            _cancelSlidePosition.value = 0;
            _startRecordingTimer();
          } else {
            toast("Couldn't start recording");
          }
        } catch (e) {
          toast("Error starting recording");
          print('Recording error: $e');
        }
      },
      onLongPressEnd: (details) async {
        if (!_isVoiceButtonHeld.value) return;

        try {
          final audioHandler = LMChatCoreAudioHandler.instance;
          HapticFeedback.mediumImpact();

          // Get the final duration before stopping timer
          final recordedDuration = _recordingDuration.value;
          _stopRecordingTimer();

          if (_cancelSlidePosition.value < -100) {
            await audioHandler.cancelRecording();
            _resetRecordingState();
          } else {
            // Pass the recorded duration when stopping
            final recordingPath = await audioHandler.stopRecording(
              recordedDuration: recordedDuration,
            );

            if (recordingPath != null) {
              _recordedFilePath = recordingPath;
              _isReviewingRecording.value = true;
              _isVoiceButtonHeld.value = false;

              // Initialize playback progress with the actual recorded duration
              _playbackProgress.value = PlaybackProgress(
                duration: recordedDuration,
                position: Duration.zero,
              );

              // Subscribe to playback progress
              audioHandler.getProgressStream(recordingPath).listen(
                (progress) {
                  // Keep the original duration but update position
                  _playbackProgress.value = PlaybackProgress(
                    duration: recordedDuration,
                    position: progress.position,
                    isCompleted: progress.isCompleted,
                  );
                  // Reset playing state when playback completes
                  if (progress.isCompleted == true) {
                    _isPlaying.value = false;
                  }
                },
                onError: (error) {
                  print('Playback error: $error');
                  _handleRecordingError();
                },
              );
            } else {
              toast("Recording too short");
              _resetRecordingState();
            }
          }
        } catch (e) {
          print('Recording error: $e');
          _handleRecordingError();
        }
      },
      style: LMChatButtonStyle(
        backgroundColor: _themeData.primaryColor,
        borderRadius: 100,
        height: 6.h,
        width: 6.h,
        scaleOnLongPress: 1.6,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.mic,
        style: LMChatIconStyle(
          size: 28,
          boxSize: 28,
          color: _themeData.container,
        ),
      ),
    );
  }

  Widget _defAttachmentButton() {
    return _isRespondingAllowed()
        ? CustomPopupMenu(
            controller: _popupMenuController,
            enablePassEvent: false,
            arrowColor: Colors.white,
            showArrow: false,
            menuBuilder: () => _defAttachmentMenu(),
            pressType: PressType.singleClick,
            child: _defAttachmentIcon(),
          )
        : const SizedBox();
  }

  Widget _defAttachmentMenu() {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 100.w,
          color: LMChatTheme.theme.container,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 12.w,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickSingleImage();
                              if (res.data != null) {
                                _navigateToForwarding();
                              } else if (res.errorMessage != null) {
                                toast(res.errorMessage!);
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.camera_alt_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Camera',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res =
                                  await LMChatMediaHandler.instance.pickMedia();
                              if (res.data != null) {
                                _navigateToForwarding();
                              } else if (res.errorMessage != null) {
                                toast(res.errorMessage!);
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.photo_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Gallery',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickDocuments();
                              if (res.data != null) {
                                _navigateToForwarding();
                              } else if (res.errorMessage != null) {
                                toast(res.errorMessage!);
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.insert_drive_file_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Documents',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickGIF(context);
                              if (res.data != null) {
                                _navigateToForwarding();
                              } else if (res.errorMessage != null) {
                                toast(res.errorMessage!);
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.gif_box_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'GIF',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.chatroom.type != 10
                        ? Expanded(
                            child: Column(
                              children: [
                                LMChatButton(
                                  onTap: () async {
                                    _popupMenuController.hideMenu();
                                    // unfocus the text field
                                    _focusNode.unfocus();
                                    // show bottom sheet to create a poll
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) {
                                        return DraggableScrollableSheet(
                                          expand: false,
                                          initialChildSize: 0.9,
                                          minChildSize: 0.5,
                                          snap: true,
                                          builder: (context, controller) =>
                                              widget.createPollWidgetBuilder
                                                  ?.call(
                                                context,
                                                LMChatCreatePollBottomSheet(
                                                  chatroomId:
                                                      widget.chatroom.id,
                                                  scrollController: controller,
                                                ),
                                              ) ??
                                              LMChatCreatePollBottomSheet(
                                                chatroomId: widget.chatroom.id,
                                                scrollController: controller,
                                              ),
                                        );
                                      },
                                    );
                                  },
                                  icon: LMChatIcon(
                                    type: LMChatIconType.svg,
                                    assetPath: kPollIcon,
                                    style: LMChatIconStyle(
                                      size: 38,
                                      backgroundColor:
                                          _themeData.secondaryColor,
                                      boxPadding: const EdgeInsets.all(8),
                                      boxBorderRadius: 100,
                                    ),
                                  ),
                                  style: LMChatButtonStyle(
                                    height: 48,
                                    width: 48,
                                    borderRadius: 24,
                                    backgroundColor:
                                        LMChatTheme.theme.secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LMChatText(
                                  'Poll',
                                  style: LMChatTextStyle(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Spacer(),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LMChatIcon _defAttachmentIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.attachment,
      style: LMChatIconStyle(
        size: 24,
        boxSize: 48,
        boxPadding: const EdgeInsets.only(
          bottom: 6,
          left: 6,
        ),
        color: LMChatTheme.theme.inActiveColor,
      ),
    );
  }

  LMChatBarHeader _defReplyConversationWidget() {
    String message = getGIFText(replyToConversation!);
    String userText = replyToConversation?.member?.name ?? '';
    if (replyToConversation?.memberId == currentUser.id) {
      userText = 'You';
    }
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic().copyWith(height: 8.h),
      titleText: userText,
      onCanceled: () {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      },
      subtitle: ((replyToConversation?.attachmentsUploaded ?? false) &&
              replyToConversation?.deletedByUserId == null)
          ? getChatItemAttachmentTile(
              message, replyConversationAttachments ?? [], replyToConversation!)
          : LMChatText(
              replyToConversation!.state != 0
                  ? LMChatTaggingHelper.extractStateMessage(message)
                  : LMChatTaggingHelper.convertRouteToTag(
                        message,
                        withTilde: false,
                      ) ??
                      "Replying to Conversation",
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 14,
                  color: LMChatTheme.theme.onContainer,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }

  LMChatBarHeader _defEditConversationWidget() {
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic(),
      title: LMChatText(
        "Edit message",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
        ),
      ),
      onCanceled: () {
        chatActionBloc.add(LMChatEditRemoveEvent());
        _textEditingController.clear();
      },
      subtitle: LMChatText(
        LMChatTaggingHelper.convertRouteToTag(
              editConversation?.answer,
              withTilde: false,
            ) ??
            "",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  LMChatLinkPreviewBar _defLinkPreview(LMChatOGTagsViewData ogTags) {
    return LMChatLinkPreviewBar(
      ogTags: ogTags,
      style: LMChatLinkPreviewBarStyle.basic(
        inActiveColor: _themeData.inActiveColor,
        containerColor: _themeData.onContainer,
      ),
      onCanceled: () {
        chatActionBloc.add(
          LMChatLinkPreviewRemovedEvent(
            isPermanentlyRemoved: true,
          ),
        );
      },
    );
  }

  void _blocListener(context, state) {
    if (state is LMChatEditConversationState) {
      replyToConversation = null;
      editConversation = state.editConversation;
      _setupEditText();
    } else if (state is LMChatEditRemoveState) {
      editConversation = null;
      _setupEditText();
    } else if (state is LMChatReplyConversationState) {
      editConversation = null;
      _setupEditText();
      replyToConversation = state.conversation;
      replyConversationAttachments = state.attachments;
      _focusNode.requestFocus();
    } else if (state is LMChatReplyRemoveState) {
      replyToConversation = null;
      _focusNode.requestFocus();
    } else if (state is LMChatRefreshBarState) {
      chatroom = state.chatroom;
    } else if (state is LMChatLinkAttachedState) {
      // to prevent the link preview from being displayed if the message is sent before the link preview is fetched
      if (_isSentBeforeLinkFetched) {
        _isSentBeforeLinkFetched = false;
        bool isCurrentTextHasLink =
            LMChatTaggingHelper.getFirstValidLinkFromString(
                    _textEditingController.text)
                .isNotEmpty;
        if (!isCurrentTextHasLink) {
          return;
        }
      }
      linkModel = LMChatMediaModel(
        mediaType: LMChatMediaType.link,
        ogTags: state.ogTags,
        link: state.link,
      );
      previewLink = state.link;
      isActiveLink = true;
    } else if (state is LMChatLinkRemovedState) {
      linkModel = null;
      previewLink = '';
      isActiveLink = false;
      showLinkPreview = !state.isPermanentlyRemoved;
    }
  }

  // Handler functions of the LMChatroomBar
  void _onSend() {
    final message = _textEditingController.text.trim();
    if (message.isEmpty && !_isReviewingRecording.value) {
      toast("Text can't be empty");
      return;
    }

    _isSentBeforeLinkFetched = true;
    tags = LMChatTaggingHelper.matchTags(message, tags);
    result = LMChatTaggingHelper.encodeString(message, tags).trim();

    _logAnalyticsEvent();

    if (editConversation != null) {
      _handleEditConversation();
    } else if (_isReviewingRecording.value) {
      _handleSendVoiceNote();
    } else {
      _handleNewMessage();
    }

    _handleChatroomStatus();
    _resetMessageInput();
  }

  void _logAnalyticsEvent() {
    if (replyToConversation != null) {
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.messageReply,
          eventProperties: {
            'type': 'text',
            'chatroom_id': chatroom?.id,
            'replied_to_member_id': replyToConversation!.memberId ??
                replyToConversation?.member?.id,
            'replied_to_member_state': replyToConversation!.member?.state,
            'replied_to_message_id': replyToConversation!.id,
          },
        ),
      );
    }
  }

  void _handleEditConversation() {
    linkModel = null;
    LMChatAnalyticsBloc.instance.add(
      LMChatFireAnalyticsEvent(
        eventName: LMChatAnalyticsKeys.messageEdited,
        eventProperties: {
          'type': 'text',
          'chatroom_id': chatroom?.id,
        },
      ),
    );
    chatActionBloc.add(LMChatEditConversationEvent(
      (EditConversationRequestBuilder()
            ..conversationId(editConversation!.id)
            ..text(result!))
          .build(),
      replyConversation:
          editConversation!.replyConversationObject?.toConversation(),
    ));
    _updateLinkPreviewState();
    widget.scrollToBottom();
  }

  void _handleNewMessage() {
    if (isActiveLink && linkModel != null) {
      final extractedLink =
          LMChatTaggingHelper.getFirstValidLinkFromString(result!);
      if (extractedLink.isEmpty) return;

      conversationBloc.add(
        LMChatPostMultiMediaConversationEvent(
          (PostConversationRequestBuilder()
                ..chatroomId(widget.chatroom.id)
                ..temporaryId(DateTime.now().millisecondsSinceEpoch.toString())
                ..text(result!)
                ..replyId(replyToConversation?.id)
                ..ogTags(linkModel!.ogTags!.toOGTag())
                ..shareLink(linkModel!.link!))
              .build(),
          [
            LMChatMediaModel(
              mediaType: LMChatMediaType.link,
              ogTags: linkModel!.ogTags,
            ),
          ],
        ),
      );
      _updateLinkPreviewState();
      widget.scrollToBottom();
      chatActionBloc.add(LMChatLinkPreviewRemovedEvent());
    } else {
      String? extractedLink = showLinkPreview
          ? LMChatTaggingHelper.getFirstValidLinkFromString(result!)
          : null;
      conversationBloc.add(
        LMChatPostConversationEvent(
          text: result ?? '',
          chatroomId: widget.chatroom.id,
          replyId: replyToConversation?.id,
          repliedTo: replyToConversation,
          shareLink: extractedLink,
        ),
      );
      _updateLinkPreviewState();
      widget.scrollToBottom();
      chatActionBloc.add(LMChatLinkPreviewRemovedEvent());
    }
  }

  void _updateLinkPreviewState() {
    if (!showLinkPreview) {
      showLinkPreview = true;
    }
  }

  void _handleChatroomStatus() {
    if (widget.chatroom.isGuest ?? false) {
      toast("Chatroom joined");
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.chatroomFollowed,
          eventProperties: {
            'chatroom_name ': widget.chatroom.header,
            'chatroom_id': widget.chatroom.id,
            'chatroom_type': 'normal',
          },
        ),
      );
      widget.chatroom.isGuest = false;
    }
    if (widget.chatroom.followStatus == false) {
      toast("Chatroom joined");
      widget.chatroom.isGuest = false;
    }
  }

  void _resetMessageInput() {
    _textEditingController.clear();
    tags = [];
    result = "";
    if (editConversation == null) {
      widget.scrollToBottom();
    }
    if (replyToConversation != null) {
      chatActionBloc.add(LMChatReplyRemoveEvent());
    }
    editConversation = null;
    replyToConversation = null;
  }

  bool _isRespondingAllowed() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return false;
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return false;
    } else if (chatroom!.chatRequestState == 2) {
      return false;
    } else {
      return true;
    }
  }

  String _getChatBarHintText() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return 'Only Community Managers can respond here';
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return 'The community managers have restricted you from responding here';
    } else if (chatroom!.chatRequestState == 2) {
      return "You can not respond to a rejected connection.";
    } else {
      return "Type your response";
    }
  }

  void _setupEditText() {
    // if the edit conversation is null, return
    if (editConversation == null) {
      return;
    }
    // remove GIF message in the text
    String message = getGIFText(editConversation!);

    // Check for user tags in the message
    String? convertedMsgText = LMChatTaggingHelper.convertRouteToTag(message);
    // set the text in the text field
    _textEditingController.value = TextEditingValue(
      text: '$convertedMsgText ',
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: _textEditingController.text.length - 1,
        ),
      ),
    );
    _focusNode.requestFocus();
    tags = LMChatTaggingHelper.addUserTagsIfMatched(
        editConversation?.answer ?? '');
  }

  void _navigateToForwarding() async {
    _popupMenuController.hideMenu();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LMChatMediaForwardingScreen(
          chatroomId: widget.chatroom.id,
          chatroomName: widget.chatroom.header,
          replyConversation: replyToConversation,
          textFieldText: _textEditingController.text,
        ),
      ),
    );

    // Clear replying or editing state after returning from the forwarding screen
    if (result == true) {
      if (replyToConversation != null) {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      }
      if (editConversation != null) {
        chatActionBloc.add(LMChatEditRemoveEvent());
        _textEditingController.clear();
      }
      if (linkModel != null) {
        chatActionBloc.add(LMChatLinkPreviewRemovedEvent());
      }
      _textEditingController.clear();
    }
  }

  // Add this method to start recording timer
  void _startRecordingTimer() {
    _recordingDuration.value = Duration.zero;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordingDuration.value = Duration(seconds: timer.tick);
    });
  }

  // Add this method to stop recording timer
  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _recordingDuration.value = Duration.zero;
  }

  // Add method to handle sending voice note
  void _handleSendVoiceNote() async {
    if (_recordedFilePath == null) return;

    try {
      if (_isPlaying.value) {
        await LMChatCoreAudioHandler.instance.stopAudio();
        _isPlaying.value = false;
      }

      final File audioFile = File(_recordedFilePath!);

      // Send voice note through conversation bloc
      conversationBloc.add(
        LMChatPostMultiMediaConversationEvent(
          (PostConversationRequestBuilder()
                ..chatroomId(widget.chatroom.id)
                ..temporaryId(DateTime.now().millisecondsSinceEpoch.toString())
                ..replyId(replyToConversation?.id)
                ..attachmentCount(1)
                ..hasFiles(true)
                ..text(result ?? ''))
              .build(),
          [
            LMChatMediaModel(
              mediaType: LMChatMediaType.voiceNote,
              mediaFile: audioFile,
              duration: _playbackProgress.value.duration.inSeconds.toDouble(),
              size: audioFile.lengthSync(),
            ),
          ],
        ),
      );

      _resetRecordingState();
      if (replyToConversation != null) {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      }
      widget.scrollToBottom();
    } catch (e) {
      print('Error sending voice note: $e');
      toast("Error sending voice note");
    }
  }

  // Add error recovery method
  void _handleRecordingError() {
    _resetRecordingState();
    _isVoiceButtonHeld.value = false;
    _isReviewingRecording.value = false;
    _recordedFilePath = null;
    _cancelSlidePosition.value = 0;
    _isPlaying.value = false;

    LMChatCoreAudioHandler.instance.cancelRecording();
    toast("Recording failed. Please try again.");
  }
}
