import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_approve_reject_view.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_sound/flutter_sound.dart';

/// {@template lm_chatroom_bar}
/// A widget to display the chatroom bar.
/// It has a text field to type the message and send button.
/// {@endtemplate}
class LMChatroomBar extends StatefulWidget {
  /// [chatroom] is the chatroom for which the bar is to be displayed.
  final LMChatRoomViewData chatroom;

  /// [scrollToBottom] is the function to scroll to the bottom of the chat.
  final void Function(bool) scrollToBottom;

  /// [controller] is an optional [TextEditingController] that can be used to control the text input field.
  /// If provided, it allows external management of the text input, such as setting the text or listening for changes.
  final TextEditingController? controller;

  /// Indicates whether tagging is enabled in the chatroom bar.
  /// If true, users can tag other users in their messages.
  final bool? enableTagging;

  /// {@macro lm_chatroom_bar}
  const LMChatroomBar({
    super.key,
    required this.chatroom,
    required this.scrollToBottom,
    this.controller,
    this.enableTagging,
  });

  /// Creates a copy of this [LMChatroomBar] with the given fields replaced with new values.
  ///
  /// The [chatroom] parameter sets a new chatroom view data.
  /// The [scrollToBottom] parameter sets a new scroll to bottom callback function.
  /// The [controller] parameter sets a new text editing controller.
  /// The [enableTagging] parameter sets whether tagging is enabled.
  ///
  /// Returns a new [LMChatroomBar] instance with the updated values.
  LMChatroomBar copyWith({
    LMChatRoomViewData? chatroom,
    void Function(bool)? scrollToBottom,
    TextEditingController? controller,
    bool? enableTagging,
  }) {
    return LMChatroomBar(
      chatroom: chatroom ?? this.chatroom,
      scrollToBottom: scrollToBottom ?? this.scrollToBottom,
      controller: controller ?? this.controller,
      enableTagging: enableTagging ?? this.enableTagging,
    );
  }

  @override
  State<LMChatroomBar> createState() => _LMChatroomBarState();
}

class _LMChatroomBarState extends State<LMChatroomBar>
    with TickerProviderStateMixin {
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

  // Add this near the top of the _LMChatroomBarState class
  late final AnimationController _breathingController;
  late final Animation<Color?> _breathingAnimation;

  // Add a new ValueNotifier for recording lock state
  final ValueNotifier<bool> _isRecordingLocked = ValueNotifier<bool>(false);

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  late final AnimationController _lockSlideController;
  late final Animation<double> _lockSlideAnimation;

  // Add these new controllers and animations near the other animation declarations
  late final AnimationController _cancelAnimationController;
  late final Animation<double> _micRotationAnimation;
  late final Animation<double> _micPositionAnimation;
  late final Animation<double> _binScaleAnimation;
  late final Animation<double> _binFadeAnimation;
  late final Animation<double> _micFadeAnimation;
  late Size size;

  // Add this near other state variables in _LMChatroomBarState
  StreamSubscription<LMChatAudioState>? _audioStateSubscription;

  // Add near the top of _LMChatroomBarState class
  late final FlutterSoundPlayer _localPlayer;
  bool _isLocalPlayerInitialized = false;
  final ValueNotifier<LMChatroomRequestState?> _chatroomState =
      ValueNotifier<LMChatroomRequestState?>(null);
  bool _isDMRequestNeedApproval = false;
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
    final bool isDMWithRequestEnabled = getIsDMWithRequestEnabled();

    _isDMRequestNeedApproval = isDMWithRequestEnabled;

    _initiateDMChatroomFlow();

    // Setup breathing animation with continuous looping
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _breathingAnimation = ColorTween(
      begin: Colors.red,
      end: _themeData.onContainer,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // Initialize lock slide animation controller
    _lockSlideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _lockSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lockSlideController,
      curve: Curves.easeInOut,
    ));

    // Initialize cancel animation controller
    _cancelAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Mic rotation animation
    _micRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi, // Full 360 rotation
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    // Mic position animation (moving upward then down)
    _micPositionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -50),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -50, end: 0),
        weight: 60,
      ),
    ]).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.easeInOut,
    ));

    // Bin scale animation
    _binScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.easeInOut,
    ));

    // Bin fade animation
    _binFadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.easeInOut,
    ));

    // Mic fade animation
    _micFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Subscribe to audio state changes
    _audioStateSubscription =
        LMChatCoreAudioHandler.instance.audioStateStream.listen((state) {
      if (state == LMChatAudioState.stopped) {
        _resetRecordingState();
      }
    });

    _localPlayer = FlutterSoundPlayer();
    _initLocalPlayer();
  }

  _initiateDMChatroomFlow() async {
    // Check if chatroom is a DM chatroom
    if (chatroom?.type != 10) {
      return;
    }

    // Check DM status
    final checkDMStatusRequest = (CheckDMStatusRequestBuilder()
          ..reqFrom("dm_feed_v2")
          ..uuid(chatroom?.chatroomWithUser?.sdkClientInfo?.uuid ?? ""))
        .build();
    final checkDMStatusResponse =
        await LMChatCore.client.checkDMStatus(checkDMStatusRequest);
    if (checkDMStatusResponse.data?.showDm == false) {
      _chatroomState.value = LMChatroomRequestState.disabled;
      _focusNode.unfocus();
      return;
    }

    final MemberStateResponse? memberRight =
        LMChatLocalPreference.instance.getMemberRights();

    if (memberRight != null && memberRight.member?.state == 1) {
      _isDMRequestNeedApproval = false;
    }
    if (chatroom?.chatRequestState == null) {
      _chatroomState.value = LMChatroomRequestState.notInitiated;
    } else if (chatroom?.chatRequestState == 0) {
      _chatroomState.value = LMChatroomRequestState.initiated;
    } else if (chatroom?.chatRequestState == 1) {
      _chatroomState.value = LMChatroomRequestState.accepted;
    } else if (chatroom?.chatRequestState == 2) {
      _chatroomState.value = LMChatroomRequestState.rejected;
    } else {
      _chatroomState.value =
          LMChatroomRequestState.fromValue(chatroom?.chatRequestState ?? 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.sizeOf(context);
  }

  @override
  void dispose() {
    // Clean up recording related resources
    _stopRecordingTimer();
    if (_isRecordingLocked.value || _isReviewingRecording.value) {
      LMChatCoreAudioHandler.instance.cancelRecording();
    }
    if (_isPlaying.value) {
      _stopLocalPlayback();
    }
    if (_isLocalPlayerInitialized) {
      _localPlayer.closePlayer();
    }

    // Clean up all controllers and subscriptions
    _popupMenuController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _textInputNotifier.dispose();
    _recordingTimer?.cancel();
    _recordingDuration.dispose();
    _isReviewingRecording.dispose();
    _playbackProgress.dispose();
    _isVoiceButtonHeld.dispose();
    _isPlaying.dispose();
    _breathingController.dispose();
    _isRecordingLocked.dispose();
    _lockSlideController.dispose();
    _cancelAnimationController.dispose();
    _audioStateSubscription?.cancel();

    super.dispose();
  }

  Widget _getWidgetBasedOnState(LMChatroomRequestState? state) {
    if (state == null ||
        state == LMChatroomRequestState.accepted ||
        !_isDMRequestNeedApproval) {
      return const SizedBox();
    }

    // if state is not initiated return a text widget
    if (state == LMChatroomRequestState.notInitiated) {
      // Create the default widget first
      final defaultDmRequestText = LMChatText(
        "Send a DM request to ${chatroom?.chatroomWithUser?.name} by sending your 1st message",
        style: LMChatTextStyle(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 14,
            color: _themeData.secondaryColor,
          ),
        ),
      );
      // Call the builder method from the delegate
      // Ensure chatroom is not null here, potentially add a check or assertion
      // Since this state implies a DM chatroom, chatroom should exist.
      return _screenBuilder.dmRequestInitiationTextBuilder(
        context,
        chatroom!, // Added assertion assuming chatroom is non-null in this state
        defaultDmRequestText,
      );
    }

    // if state is initiated & current user != chatRequestedBy
    // show approve/reject buttons

    return _isDMRequestNeedApproval
        ? Column(
            children: [
              if (state == LMChatroomRequestState.initiated &&
                  !checkDMreqByCurrentUser())
                _screenBuilder.dmApproveRejectViewBuilder(
                    context,
                    _defApproveRejectView(),
                    _onApproveButtonClicked,
                    _defOnRejectButtonClicked),
              _screenBuilder.dmStateContainerBuilder(
                  context, state, _defDisabledTextContainer(state)),
            ],
          )
        : const SizedBox.shrink();
  }

  Container _defDisabledTextContainer(LMChatroomRequestState state) {
    return Container(
      width: size.width * 0.9,
      constraints: BoxConstraints(
        minHeight: 4.h,
      ),
      decoration: BoxDecoration(
        color: _themeData.container,
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingXLarge,
          vertical: kPaddingMedium,
        ),
        child: Center(
          child: Builder(
              // Use Builder to get context if needed within builder call
              builder: (context) {
            // Get the text content
            final String containerText = _containerText(state);
            // Create the default widget
            final defaultDmStateText = LMChatText(
              containerText,
              style: LMChatTextStyle(
                  textStyle: TextStyle(
                fontSize: 14,
                color: _themeData.secondaryColor,
              )),
            );
            // Call the builder method from the delegate
            return _screenBuilder.dmStateContainerTextBuilder(
              context,
              state,
              containerText,
              defaultDmStateText,
            );
          }),
        ),
      ),
    );
  }

  LMChatApproveRejectView _defApproveRejectView() {
    return LMChatApproveRejectView(
      onApproveButtonClicked: _onApproveButtonClicked,
      onRejectButtonClicked: _defOnRejectButtonClicked,
      style: LMChatApproveRejectStyle.basic(
        containerColor: _themeData.container,
      ),
    );
  }

  void _defOnRejectButtonClicked() {
    // Show the dialog
    showDialog(
        context: context,
        builder: (context) {
          return _screenBuilder.dmApproveRejectDialogBuilder(
            context,
            type: LMDMDialogType.reject,
            onPrimary: onDialogRejectButtonTap, // reject
            onSecondary: onDialogCancelButtonTap, // cancel
            onTertiary: onDialogReportRejectButtonTap, // reprot and reject
            approveRejectDialog: _defDmApproveRejectDialog(
              context,
              type: LMDMDialogType.reject,
              onPrimary: onDialogRejectButtonTap,
              onSecondary: onDialogCancelButtonTap,
              onTertiary: onDialogReportRejectButtonTap, // Pass tertiary here
            ),
          );
        });
  }

  void _onApproveButtonClicked() {
    // Define callbacks
    // Show the dialog
    showDialog(
        context: context,
        builder: (context) {
          return _screenBuilder.dmApproveRejectDialogBuilder(
            context,
            type: LMDMDialogType.approve,
            onPrimary: onDialogApproveButtonTap,
            onSecondary: onDialogCancelButtonTap,
            approveRejectDialog: _defDmApproveRejectDialog(
              context,
              type: LMDMDialogType.approve,
              onPrimary: onDialogApproveButtonTap,
              onSecondary: onDialogCancelButtonTap,
            ),
          );
        });
  }

  void onDialogApproveButtonTap() async {
    Navigator.pop(context);

    final response = await LMChatCore.client.sendDMRequest(
      (SendDMRequestBuilder()
            ..chatroomId(chatroom!.id)
            ..chatRequestState(1)
            ..text(""))
          .build(),
    );

    if (response.success) {
      _chatroomState.value = LMChatroomRequestState.accepted;
      final conversation = response.data!.conversation!;
      conversationBloc.add(LMChatLocalConversationEvent(
        conversation: conversation.toConversationViewData(),
      ));

      LMChatConversationActionBloc.instance.add(LMChatRefreshBarEvent(
        chatroom: widget.chatroom!.copyWith(
          chatRequestState: 1,
        ),
      ));
      LMChatroomActionBloc.instance.add(
        LMChatroomActionUpdateEvent(
          chatroomId: chatroom!.id,
        ),
      );
    }
  }

  void onDialogCancelButtonTap() {
    Navigator.pop(context);
  }

  void onDialogReportRejectButtonTap() async {
    // reject and report button clicked
    Navigator.pop(context);

    final response = await LMChatCore.client.sendDMRequest(
      (SendDMRequestBuilder()
            ..chatroomId(chatroom!.id)
            ..chatRequestState(2)
            ..text(""))
          .build(),
    );

    // push to LMChatReportScreen
    context.push(
      LMChatReportScreen(
        entityId: chatroom?.chatroomWithUser?.id.toString() ?? "",
        entityCreatorId: currentUser.sdkClientInfo?.user.toString() ?? "",
        entityType: 1,
      ),
    );
    final conversation = response.data!.conversation!;
    conversationBloc.add(LMChatLocalConversationEvent(
      conversation: conversation.toConversationViewData(),
    ));

    LMChatConversationActionBloc.instance.add(LMChatRefreshBarEvent(
      chatroom: widget.chatroom!.copyWith(
        chatRequestState: 2,
      ),
    ));
    LMChatroomActionBloc.instance.add(
      LMChatroomActionUpdateEvent(
        chatroomId: chatroom!.id,
      ),
    );
  }

  void onDialogRejectButtonTap() async {
    Navigator.pop(context);

    final response = await LMChatCore.client.sendDMRequest(
      (SendDMRequestBuilder()
            ..chatroomId(chatroom!.id)
            ..text("")
            ..chatRequestState(2))
          .build(),
    );
    if (response.success) {
      final conversation = response.data!.conversation!;
      conversationBloc.add(LMChatLocalConversationEvent(
        conversation: conversation.toConversationViewData(),
      ));

      LMChatConversationActionBloc.instance.add(LMChatRefreshBarEvent(
        chatroom: widget.chatroom!.copyWith(
          chatRequestState: 2,
        ),
      ));
      LMChatroomActionBloc.instance.add(
        LMChatroomActionUpdateEvent(
          chatroomId: chatroom!.id,
        ),
      );
    }
  }

  String _containerText(LMChatroomRequestState state) {
    switch (state) {
      case LMChatroomRequestState.notInitiated:
        return 'Send a message to start a chat';
      case LMChatroomRequestState.initiated:
        if (checkDMreqByCurrentUser()) {
          return "DM request pending. Messaging would be enabled once your request is approved.";
        } else {
          return "DM request pending. Messaging would be enabled once you approve or reject connection request";
        }
      case LMChatroomRequestState.accepted:
        return 'Chat request accepted';
      case LMChatroomRequestState.rejected:
        return "You can not respond to a rejected connection. Approve to send a message.";

      case LMChatroomRequestState.disabled:
        return 'Direct messaging among members has been disabled by the community manager';
    }
  }

  bool checkDMreqByCurrentUser() {
    return chatroom?.chatRequestedBy?.sdkClientInfo?.uuid == null ||
        currentUser.sdkClientInfo?.uuid ==
            chatroom?.chatRequestedBy?.sdkClientInfo?.uuid;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<LMChatConversationActionBloc,
            LMChatConversationActionState>(
          bloc: chatActionBloc,
          listener: _blocListener,
          builder: (context, state) {
            return ValueListenableBuilder(
                valueListenable: _chatroomState,
                builder: (context, _, __) {
                  return Column(
                    children: [
                      if (chatroom?.type == 10)
                        _getWidgetBasedOnState(_chatroomState.value),
                      if ((chatroom?.type == 10 &&
                              (_chatroomState.value ==
                                      LMChatroomRequestState.notInitiated ||
                                  _chatroomState.value ==
                                      LMChatroomRequestState.accepted)) ||
                          chatroom?.type != 10 ||
                          !_isDMRequestNeedApproval)
                        _screenBuilder.chatroomBottomBarContainer(
                          context,
                          _defTextFieldContainer(),
                          _defSendButton(context),
                          _defVoiceOverlayLayout(context),
                          _defInnerTextField(context),
                          _defAttachmentButton(),
                        ),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }

  Container _defTextFieldContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: size.width * 0.02,
        right: size.width * 0.02,
        top: size.width * 0.015,
        bottom: (isOtherUserAIChatbot(chatroom!)) ? 0 : size.width * 0.015,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  valueListenable: _isRecordingLocked,
                  builder: (context, isLocked, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isReviewingRecording,
                      builder: (context, isReviewing, child) {
                        return ValueListenableBuilder<String>(
                          valueListenable: _textInputNotifier,
                          builder: (context, text, child) {
                            final shouldShowSendButton =
                                text.trim().isNotEmpty ||
                                    isReviewing ||
                                    isLocked ||
                                    (widget.chatroom.type == 10 &&
                                        isOtherUserAIChatbot(widget.chatroom));

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                // combine the scale with a fade
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: shouldShowSendButton || _isDMRequestState()
                                  ? _screenBuilder.sendButton(
                                      context,
                                      _textEditingController,
                                      _onSend,
                                      _defSendButton(context),
                                    )
                                  : _defVoiceOverlayLayout(context),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _defaultLockRecordingOverlay() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVoiceButtonHeld,
      builder: (context, isHeld, child) {
        return Visibility(
          visible: isHeld,
          child: Positioned(
            bottom: 50,
            child: AnimatedBuilder(
              animation: _lockSlideAnimation,
              builder: (context, child) {
                return Container(
                  height: 100,
                  width: 48,
                  decoration: BoxDecoration(
                    color: _themeData.container,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _screenBuilder.voiceNotesLockIcon(
                              context,
                              LMChatIcon(
                                type: LMChatIconType.icon,
                                icon: _lockSlideAnimation.value > 0.7
                                    ? Icons.lock_outline
                                    : Icons.lock_open_outlined,
                                key: ValueKey(_lockSlideAnimation.value > 0.7),
                                style: LMChatIconStyle(
                                  color: _themeData.onContainer.withOpacity(
                                    0.3 + (_lockSlideAnimation.value * 0.7),
                                  ),
                                  size: 24,
                                ),
                              ),
                              _lockSlideAnimation.value)),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        width: 2,
                        decoration: BoxDecoration(
                          color: _themeData.onContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _defVoiceOverlayLayout(BuildContext context) {
    if (widget.chatroom.type == 10 && isOtherUserAIChatbot(widget.chatroom)) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        _defaultLockRecordingOverlay(),
        _defVoiceButtonBuilder(context),
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
          width: size.width * 0.8,
          constraints: BoxConstraints(
            minHeight: 5.2.h,
            maxHeight: 24.h,
          ),
          child: _screenBuilder.chatroomTextField(
            context,
            _textEditingController,
            _defInnerTextField(context),
            _defAttachmentButton(),
          ),
        ),
      ],
    );
  }

  // Widget functions for the default widgets of LMChatroomBar
  Widget _defDisabledTextField(BuildContext context) {
    return Container(
      width: size.width * 0.9,
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
      onKeyboardFocusChange: (bool val) {
        if (!val) {
          // keyboard has been closed
          _popupMenuController.hideMenu();
        }
      },
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: LMChatTheme.theme.onContainer,
          ),
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
        border: OutlineInputBorder(
          borderRadius: editConversation == null &&
                  replyToConversation == null &&
                  !isActiveLink
              ? BorderRadius.circular(24)
              : const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: editConversation == null &&
                  replyToConversation == null &&
                  !isActiveLink
              ? BorderRadius.circular(24)
              : const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: editConversation == null &&
                  replyToConversation == null &&
                  !isActiveLink
              ? BorderRadius.circular(24)
              : const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
          borderSide: BorderSide.none,
        ),
        enabled: true,
        hintMaxLines: 1,
        hintStyle: TextStyle(
          fontSize: 14,
          color: _themeData.inActiveColor,
        ),
        hintText: _getChatBarHintText(),
        suffixIcon: _defAttachmentButton(),
        fillColor: _themeData.container,
        filled: true,
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
    return ValueListenableBuilder<bool>(
      valueListenable: _isRecordingLocked,
      builder: (context, isLocked, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size.width * 0.8,
              height: 6.2.h,
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
                        AnimatedBuilder(
                          animation: _cancelAnimationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _micFadeAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, _micPositionAnimation.value),
                                child: Transform.rotate(
                                  angle: _micRotationAnimation.value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: _buildRecordingIndicator(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder<Duration>(
                          valueListenable: _recordingDuration,
                          builder: (context, duration, child) {
                            return Text(
                              "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: LMChatTheme.theme.onContainer,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isLocked)
                    Row(
                      children: [
                        LMChatButton(
                          onTap: () async {
                            final audioHandler =
                                LMChatCoreAudioHandler.instance;
                            final recordedDuration = _recordingDuration.value;
                            _stopRecordingTimer();

                            final recordingPath =
                                await audioHandler.stopRecording(
                              recordedDuration: recordedDuration,
                            );

                            if (recordingPath != null) {
                              if (recordedDuration.inSeconds < 1) {
                                toast("Voice recording too short");
                                _handleDeleteRecording();
                                return;
                              }

                              _recordedFilePath = recordingPath;
                              _isReviewingRecording.value = true;
                              _isVoiceButtonHeld.value = false;
                              _isRecordingLocked.value = false;

                              _playbackProgress.value = PlaybackProgress(
                                duration: recordedDuration,
                                position: Duration.zero,
                              );

                              // Setup playback progress listener
                              audioHandler
                                  .getProgressStream(recordingPath)
                                  .listen(
                                (progress) {
                                  _playbackProgress.value = PlaybackProgress(
                                    duration: recordedDuration,
                                    position: progress.position,
                                    isCompleted: progress.isCompleted,
                                  );
                                  if (progress.isCompleted == true) {
                                    _isPlaying.value = false;
                                  }
                                },
                                onError: (error) {
                                  debugPrint('Playback error: $error');
                                  _handleRecordingError();
                                },
                              );
                            }
                          },
                          style: LMChatButtonStyle(
                            height: 28,
                            width: 28,
                            backgroundColor: _themeData.container,
                          ),
                          icon: const LMChatIcon(
                            type: LMChatIconType.icon,
                            icon: Icons.stop_circle,
                            style: LMChatIconStyle(
                              size: 28,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        LMChatButton(
                          onTap: () {
                            _handleDeleteRecording();
                            _isRecordingLocked.value = false;
                            toast("Voice recording cancelled");
                          },
                          style: LMChatButtonStyle(
                            height: 28,
                            width: 28,
                            backgroundColor: _themeData.container,
                          ),
                          icon: LMChatIcon(
                            type: LMChatIconType.icon,
                            icon: Icons.cancel_outlined,
                            style: LMChatIconStyle(
                              size: 28,
                              color: _themeData.inActiveColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: AnimatedBuilder(
                        animation: _cancelAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 1 - _cancelAnimationController.value,
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
                    ),
                ],
              ),
            ),
            // Move bin animation overlay to align with mic
            Positioned(
              left: 16, // Keep aligned with mic horizontally
              bottom: 8, // Adjust to better align with mic's resting position
              child: AnimatedBuilder(
                animation: _cancelAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _binFadeAnimation.value,
                    child: Transform.scale(
                      scale: _binScaleAnimation.value,
                      child: Icon(
                        Icons.delete_outline,
                        size: 28, // Match mic icon size
                        color: _themeData.onContainer,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewContainer(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.062,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _themeData.container,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isPlaying,
            builder: (context, isPlaying, child) {
              return LMChatButton(
                onTap: () => _handlePlayPause(),
                style: LMChatButtonStyle(
                  height: 28,
                  width: 28,
                  backgroundColor: _themeData.container,
                ),
                icon: LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  style: LMChatIconStyle(
                    color: _themeData.onContainer,
                    size: 28,
                  ),
                ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: LMChatTheme.theme.onContainer,
                ),
              );
            },
          ),
          const Spacer(),
          LMChatButton(
            onTap: () => _handleDeleteRecording(),
            style: LMChatButtonStyle(
              height: 28,
              width: 28,
              backgroundColor: _themeData.container,
            ),
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.cancel_outlined,
              style: LMChatIconStyle(
                size: 28,
                color: _themeData.inActiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (context, child) {
        return Container(
          height: 28, // Increased container size
          width: 28, // Increased container size
          decoration: BoxDecoration(
            color: _themeData.container,
            borderRadius: BorderRadius.circular(12),
          ),
          child: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.mic,
            style: LMChatIconStyle(
              size: 18, // Increased icon size
              color: _breathingAnimation.value,
            ),
          ),
        );
      },
    );
  }

  // Add these methods to handle the review actions
  void _handlePlayPause() async {
    if (_recordedFilePath == null) return;

    try {
      if (_isPlaying.value) {
        await _stopLocalPlayback();
      } else {
        await _handleLocalPlayback();
      }
    } catch (e) {
      debugPrint('Error handling play/pause: $e');
      _isPlaying.value = false;
    }
  }

  void _handleDeleteRecording() async {
    try {
      // Stop recording timer first
      _stopRecordingTimer();

      // Stop any ongoing playback
      if (_isPlaying.value) {
        await _stopLocalPlayback();
      }

      // Cancel any ongoing recording
      if (_isVoiceButtonHeld.value) {
        await LMChatCoreAudioHandler.instance.cancelRecording();
      }
      // Delete the recorded file if it exists
      else if (_recordedFilePath != null) {
        final file = File(_recordedFilePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _resetRecordingState();
    } catch (e) {
      debugPrint('Error handling recording deletion: $e');
      _resetRecordingState(); // Ensure state is reset even if error occurs
    }
  }

  void _resetRecordingState() {
    if (!mounted) return;

    _stopRecordingTimer();
    _isReviewingRecording.value = false;
    _isVoiceButtonHeld.value = false;
    _isRecordingLocked.value = false;
    _isReviewingRecording.value = false;
    _isPlaying.value = false;
    _recordedFilePath = null;
    _currentRecordingPath = null;
    _playbackProgress.value = const PlaybackProgress(
      duration: Duration.zero,
      position: Duration.zero,
    );
    _recordingDuration.value = Duration.zero;
    _lockSlideController.value = 0.0;
    _cancelAnimationController.reset();

    // Reset breathing animation
    _breathingController.stop();
    _breathingController.reset();

    if (mounted) {
      setState(() {});
    }
  }

  LMChatButton _defSendButton(BuildContext context) {
    return LMChatButton(
      onTap: _onSend,
      style: LMChatButtonStyle(
        backgroundColor: _themeData.primaryColor,
        borderRadius: 100,
        height: 50,
        width: 50,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.send,
        style: LMChatIconStyle(
          size: 26,
          boxSize: 26,
          boxPadding: const EdgeInsets.only(left: 2),
          color: _themeData.container,
        ),
      ),
    );
  }

  Widget _defVoiceButtonBuilder(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVoiceButtonHeld,
      builder: (context, isHeld, child) {
        return _screenBuilder.voiceNotesButton(context, _defVoiceNoteButton());
      },
    );
  }

  LMChatButton _defVoiceNoteButton() {
    return LMChatButton(
      gesturesEnabled: true,
      onTap: () {
        HapticFeedback.lightImpact();
        toast(
          "Hold to start recording",
          duration: const Duration(milliseconds: 300),
        );
      },
      onLongPress: () {
        // Set held state before starting recording
        _isVoiceButtonHeld.value = true;
        _startRecording();
      },
      onHorizontalDragUpdate: (details) {
        if (_isVoiceButtonHeld.value) {
          if (details.delta.dx < -120) {
            if (!_cancelAnimationController.isAnimating) {
              // Let the voice button return to original position immediately
              // but keep recording container visible until animation completes
              _cancelAnimationController.forward().then((_) {
                // Only update voice button held state after animation
                _isVoiceButtonHeld.value = false;
                HapticFeedback.lightImpact();
                _stopRecordingTimer();
                _handleDeleteRecording();
                _cancelAnimationController.reset();
                toast(
                  "Voice recording cancelled",
                  duration: const Duration(milliseconds: 300),
                );
              });
            }
          }
        }
      },
      onVerticalDragUpdate: (details) {
        if (_isVoiceButtonHeld.value) {
          // Calculate the progress based on drag distance
          // Assuming 75 is the threshold for locking
          final progress = math.min(1.0, -details.delta.dy / 75);
          _lockSlideController.value = progress;

          if (details.delta.dy < -75) {
            HapticFeedback.lightImpact();
            _isRecordingLocked.value = true;
            toast(
              "Voice recording locked",
              duration: const Duration(milliseconds: 300),
            );
            _overlayPortalController.hide();
          }
        }
      },
      onLongPressEnd: (details) async {
        _overlayPortalController.hide();
        _lockSlideController.value = 0.0; // Reset the animation

        // If recording is locked or animation is playing, don't stop recording
        if (_isRecordingLocked.value ||
            _cancelAnimationController.isAnimating) {
          return;
        }

        if (!_isVoiceButtonHeld.value) return;

        try {
          final audioHandler = LMChatCoreAudioHandler.instance;
          HapticFeedback.mediumImpact();

          final recordedDuration = _recordingDuration.value;
          _stopRecordingTimer();

          final recordingPath = await audioHandler.stopRecording(
            recordedDuration: recordedDuration,
          );

          if (recordingPath != null) {
            if (recordedDuration.inSeconds < 1) {
              toast("Voice recording too short");
              _handleDeleteRecording();
              return;
            }

            _recordedFilePath = recordingPath;
            _isReviewingRecording.value = true;
            _isVoiceButtonHeld.value = false;

            _playbackProgress.value = PlaybackProgress(
              duration: recordedDuration,
              position: Duration.zero,
            );

            audioHandler.getProgressStream(recordingPath).listen(
              (progress) {
                _playbackProgress.value = PlaybackProgress(
                  duration: recordedDuration,
                  position: progress.position,
                  isCompleted: progress.isCompleted,
                );
                if (progress.isCompleted == true) {
                  _isPlaying.value = false;
                }
              },
              onError: (error) {
                debugPrint('Playback error: $error');
                _handleRecordingError();
              },
            );
          } else {
            _resetRecordingState();
          }
        } catch (e) {
          debugPrint('Voice recording error: $e');
          _handleRecordingError();
        }
      },
      style: LMChatButtonStyle(
        backgroundColor: _themeData.primaryColor,
        borderRadius: 100,
        height: 50,
        width: 50,
        scaleOnLongPress: 1.6,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.mic,
        style: LMChatIconStyle(
          size: 26,
          boxSize: 26,
          color: _themeData.container,
        ),
      ),
    );
  }

  CustomPopupMenu? _defAttachmentButton() {
    // Disable attachment button in DM request state
    if (_isDMRequestState()) {
      return null;
    }

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
        : null;
  }

  Widget _defAttachmentMenu() {
    // First determine which buttons should be visible based on conditions
    final List<LMAttachmentMenuItemData> menuItems = _getVisibleMenuItems();

    return LMChatCore.config.chatRoomConfig.builder.attachmentMenuBuilder(
      context,
      menuItems,
      LMAttachmentMenu(
        items: menuItems,
        style: LMAttachmentMenuStyle(
          backgroundColor: _themeData.container,
          menuItemStyle: LMAttachmentMenuItemStyle(
            iconColor: _themeData.container,
            backgroundColor: _themeData.primaryColor,
            labelTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _themeData.onContainer,
                    ) ??
                const TextStyle(),
          ),
        ),
      ),
    );
  }

  List<LMAttachmentMenuItemData> _getVisibleMenuItems() {
    final bool isAIChatbot =
        widget.chatroom.type == 10 && isOtherUserAIChatbot(widget.chatroom);
    final bool showDocuments = !isAIChatbot;
    final bool showPoll = widget.chatroom.type != 10;
    final bool showGIF = !isAIChatbot;

    final List<LMAttachmentMenuItemData> items = [
      LMAttachmentMenuItemData(
        icon: Icons.camera_alt_outlined,
        label: 'Camera',
        onTap: () async {
          _popupMenuController.hideMenu();
          final res = await LMChatMediaHandler.instance.pickSingleImage();
          if (res.data != null) {
            _navigateToForwarding();
          } else if (res.errorMessage != null) {
            toast(res.errorMessage!);
          }
        },
      ),
      LMAttachmentMenuItemData(
        icon: Icons.photo_outlined,
        label: 'Gallery',
        onTap: () async {
          _popupMenuController.hideMenu();
          final res = await LMChatMediaHandler.instance.pickMedia(
            mediaCount: isAIChatbot ? 1 : 10,
          );
          if (res.data != null) {
            _navigateToForwarding();
          } else if (res.errorMessage != null) {
            toast(res.errorMessage!);
          }
        },
      ),
      if (showDocuments)
        LMAttachmentMenuItemData(
          icon: Icons.insert_drive_file_outlined,
          label: 'Documents',
          onTap: () async {
            _popupMenuController.hideMenu();
            final res = await LMChatMediaHandler.instance.pickDocuments();
            if (res.data != null) {
              _navigateToForwarding();
            } else if (res.errorMessage != null) {
              toast(res.errorMessage!);
            }
          },
        ),
      if (showGIF)
        LMAttachmentMenuItemData(
          icon: Icons.gif_box_outlined,
          label: 'GIF',
          onTap: () async {
            _popupMenuController.hideMenu();
            final res = await LMChatMediaHandler.instance.pickGIF(context);
            if (res.data != null) {
              _navigateToForwarding();
            } else if (res.errorMessage != null) {
              toast(res.errorMessage!);
            }
          },
        ),
      if (showPoll)
        LMAttachmentMenuItemData(
          iconType: LMChatIconType.svg,
          assetPath: kPollIcon,
          label: 'Poll',
          onTap: () async {
            // hide pop up menu
            _popupMenuController.hideMenu();
            // close keyboard if opened
            _focusNode.unfocus();
            // navigate to create poll screen
            context.push(
              LMChatCreatePollScreen(
                chatroomId: widget.chatroom.id,
              ),
            );
          },
        ),
    ];

    return items;
  }

  LMChatIcon _defAttachmentIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.attachment,
      style: LMChatIconStyle(
        size: 24,
        boxSize: 48,
        color: _themeData.inActiveColor,
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
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: LMChatTheme.theme.onContainer,
              ),
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
          textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: LMChatTheme.theme.onContainer,
              ),
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

      _initiateDMChatroomFlow();
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
  void _onSend() async {
    final message = _textEditingController.text.trim();
    if (message.isEmpty &&
        !_isReviewingRecording.value &&
        !_isRecordingLocked.value) {
      toast("Text can't be empty");
      return;
    }

    // Check for DM request state and character limit
    if (_isDMRequestState() && message.length > 300) {
      toast("Request can't be more than 300 characters");
      return;
    }

    // If in DM request state, show confirmation dialog if private member
    if (_isDMRequestState()) {
      if (chatroom?.isPrivateMember == true && _isDMRequestNeedApproval) {
        // Define callbacks
        final VoidCallback onDialogSendButtonClicked = () async {
          Navigator.pop(context);
          _sendDMRequest(message);
          _chatroomState.value = LMChatroomRequestState.initiated;
        };

        // Show the dialog
        showDialog(
            context: context,
            builder: (context) {
              return _screenBuilder.dmApproveRejectDialogBuilder(
                context,
                type: LMDMDialogType.send,
                onPrimary: onDialogSendButtonClicked,
                onSecondary: onDialogCancelButtonTap,
                approveRejectDialog: _defDmApproveRejectDialog(
                  context,
                  type: LMDMDialogType.send,
                  onPrimary: onDialogSendButtonClicked,
                  onSecondary: onDialogCancelButtonTap,
                ),
              );
            });
      } else {
        await _sendDMRequest(message);
      }

      _resetMessageInput();
      return;
    }

    // If recording is locked, stop recording first and then send
    if (_isRecordingLocked.value) {
      try {
        final audioHandler = LMChatCoreAudioHandler.instance;
        final recordedDuration = _recordingDuration.value;
        _stopRecordingTimer();

        final recordingPath = await audioHandler.stopRecording(
          recordedDuration: recordedDuration,
        );

        if (recordingPath != null) {
          if (recordedDuration.inSeconds < 1) {
            toast("Voice recording too short");
            _handleDeleteRecording();
            return;
          }
          _recordedFilePath = recordingPath;
          _isReviewingRecording.value = true;
          _isVoiceButtonHeld.value = false;
          _isRecordingLocked.value = false;
        }
      } catch (e) {
        debugPrint('Error stopping recording: $e');
        toast("Error stopping recording");
        _resetRecordingState();
        return;
      }
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

  LMChatDialog _defDmApproveRejectDialog(
    BuildContext context, {
    required LMDMDialogType type,
    required VoidCallback onPrimary, // CONFIRM / ACCEPT / REJECT
    VoidCallback? onSecondary, // CANCEL
    VoidCallback? onTertiary, // REPORT AND REJECT (only for reject)
  }) {
    // map titles and bodies
    final _titles = {
      LMDMDialogType.send: 'Send DM request?',
      LMDMDialogType.approve: 'Approve DM request?',
      LMDMDialogType.reject: 'Reject DM request?',
    };
    final _bodies = {
      LMDMDialogType.send:
          'A direct messaging request would be sent to this member. You would be able to send further messages only once your request is approved.',
      LMDMDialogType.approve:
          'Member will be able to send you messages and get notified of the same.',
      LMDMDialogType.reject:
          'Member would be blocked from sending you further messages. The sender will not be notified of this.',
    };

    // build the list of buttons
    List<Widget> actions = [];

    switch (type) {
      case LMDMDialogType.send:
        actions = [
          LMChatText(
            "CANCEL",
            onTap: onSecondary ?? () => Navigator.pop(context),
            style: LMChatTextStyle(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              textStyle: TextStyle(
                color: _themeData.inActiveColor,
              ),
            ),
          ),
          LMChatText(
            "CONFIRM",
            onTap: onPrimary,
            style: LMChatTextStyle(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              textStyle: TextStyle(
                color: _themeData.primaryColor,
              ),
            ),
          ),
        ];
        break;

      case LMDMDialogType.approve:
        actions = [
          LMChatText(
            "CANCEL",
            onTap: onSecondary ?? () => Navigator.pop(context),
            style: LMChatTextStyle(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              textStyle: TextStyle(
                color: _themeData.inActiveColor,
              ),
            ),
          ),
          LMChatText(
            "ACCEPT",
            onTap: onPrimary,
            style: LMChatTextStyle(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              textStyle: TextStyle(
                color: _themeData.primaryColor,
              ),
            ),
          ),
        ];
        break;

      case LMDMDialogType.reject:
        actions = [
          LMChatText(
            "REJECT",
            onTap: onPrimary,
            style: LMChatTextStyle(
              padding: const EdgeInsets.all(10),
              textStyle: TextStyle(
                color: _themeData.primaryColor,
              ),
            ),
          ),
          LMChatText(
            "CANCEL",
            onTap: onSecondary ?? () => Navigator.pop(context),
            style: LMChatTextStyle(
              padding: const EdgeInsets.all(10),
              textStyle: TextStyle(
                color: _themeData.primaryColor,
              ),
            ),
          ),
          LMChatText(
            "REPORT AND REJECT",
            onTap: onTertiary ?? onPrimary, // Use onTertiary if provided
            style: LMChatTextStyle(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              textStyle: TextStyle(
                color: _themeData.primaryColor,
              ),
            ),
          ),
          // REJECT
        ];
        break;
    }

    return LMChatDialog(
      title: LMChatText(
        _titles[type]!,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: _themeData.onContainer,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      style: LMChatDialogStyle(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),

        // actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: _themeData.container,
      ),
      content: LMChatText(
        _bodies[type]!,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: _themeData.onContainer,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      actions: actions,
    );
  }

  Future<void> _sendDMRequest(String message) async {
    final response = await LMChatCore.client.sendDMRequest(
      (SendDMRequestBuilder()
            ..chatroomId(chatroom!.id)
            ..chatRequestState(chatroom?.isPrivateMember == true ? 0 : 1)
            ..text(message))
          .build(),
    );

    if (response.success == true) {
      // Fetch latest conversations
      _chatroomState.value = LMChatroomRequestState.initiated;

      //if (_isOwnerOrCM) {
      if (!(chatroom?.isPrivateMember ?? true)) {
        conversationBloc.add(LMChatFetchConversationsEvent(
          chatroomId: chatroom!.id,
          page: 1,
          pageSize: 200,
          direction: LMPaginationDirection.top,
          lastConversationId: response.data!.conversation!.id,
          reInitialize: true,
        ));
      }
      conversationBloc.add(LMChatLocalConversationEvent(
          conversation: response.data!.conversation!.toConversationViewData()));
      LMChatConversationActionBloc.instance.add(LMChatRefreshBarEvent(
        chatroom: widget.chatroom!.copyWith(
          chatRequestState: chatroom?.isPrivateMember == true ? 0 : 1,
        ),
      ));
      LMChatroomActionBloc.instance.add(
        LMChatroomActionUpdateEvent(
          chatroomId: chatroom!.id,
        ),
      );

      //  }
    }
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
    widget.scrollToBottom(true);
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
                ..triggerBot(widget.chatroom.type == 10 &&
                    isOtherUserAIChatbot(widget.chatroom))
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
      widget.scrollToBottom(true);
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
          triggerBot: widget.chatroom.type == 10 &&
              isOtherUserAIChatbot(widget.chatroom),
        ),
      );
      _updateLinkPreviewState();
      widget.scrollToBottom(true);
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
      widget.scrollToBottom(true);
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
      return "Type a message";
    }
  }

  bool _isDMRequestState() {
    return chatroom!.type == 10 &&
        _chatroomState.value == LMChatroomRequestState.notInitiated;
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
    LMChatCoreAudioHandler.instance.stopAudio();
    LMChatCoreAudioHandler.instance.stopRecording();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LMChatMediaForwardingScreen(
          chatroomId: widget.chatroom.id,
          chatroomName: widget.chatroom.header,
          replyConversation: replyToConversation,
          textFieldText: _textEditingController.text,
          triggerBot: widget.chatroom.type == 10 &&
              isOtherUserAIChatbot(widget.chatroom),
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
    _stopRecordingTimer(); // Ensure any existing timer is stopped
    _recordingDuration.value = Duration.zero;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isVoiceButtonHeld.value || _isRecordingLocked.value) {
        _recordingDuration.value = Duration(seconds: timer.tick);
      } else {
        _stopRecordingTimer();
      }
    });
    _breathingController.repeat(reverse: true);
  }

  // Add this method to stop recording timer
  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _breathingController.stop();
    _breathingController.reset();
  }

  // Add method to handle sending voice note
  void _handleSendVoiceNote() async {
    if (_recordedFilePath == null) return;

    try {
      // Stop any ongoing playback
      if (_isPlaying.value) {
        await LMChatCoreAudioHandler.instance.stopAudio();
      }

      final File audioFile = File(_recordedFilePath!);
      if (!await audioFile.exists()) {
        toast("Error: Recording file not found");
        _resetRecordingState();
        return;
      }

      // Store duration before resetting state
      final duration = _playbackProgress.value.duration;

      conversationBloc.add(
        LMChatPostMultiMediaConversationEvent(
          (PostConversationRequestBuilder()
                ..chatroomId(widget.chatroom.id)
                ..temporaryId(DateTime.now().millisecondsSinceEpoch.toString())
                ..replyId(replyToConversation?.id)
                ..hasFiles(true)
                ..text(result ?? ''))
              .build(),
          [
            LMChatMediaModel(
              mediaType: LMChatMediaType.voiceNote,
              mediaFile: audioFile,
              duration: duration.inSeconds.toDouble(),
              size: audioFile.lengthSync(),
              meta: {
                'duration': duration.inSeconds.toDouble(),
                'file_name': audioFile.path.split('/').last,
              },
            ),
          ],
        ),
      );

      _resetRecordingState();
      if (replyToConversation != null) {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      }
      widget.scrollToBottom(true);
    } on Exception catch (e, stackTrace) {
      LMChatCore.instance.lmChatClient.handleException(e, stackTrace);
      debugPrint('Error sending voice note: $e');
      toast("Error sending voice note");
      _resetRecordingState();
    }
  }

  // Add error recovery method
  void _handleRecordingError() {
    // Current implementation only calls _resetRecordingState()
    // We should properly cleanup audio resources first
    if (_isPlaying.value) {
      LMChatCoreAudioHandler.instance.stopAudio();
    }
    if (_isVoiceButtonHeld.value || _isRecordingLocked.value) {
      LMChatCoreAudioHandler.instance.cancelRecording();
    }
    _resetRecordingState();
    toast("Error recording audio");
  }

  // Add permission check before starting recording
  Future<void> _startRecording() async {
    _overlayPortalController.show();
    try {
      final audioHandler = LMChatCoreAudioHandler.instance;

      // Reset any existing recording state first
      if (_isPlaying.value || _isReviewingRecording.value) {
        await audioHandler.stopAudio();
        _resetRecordingState();
      }

      // Request permissions before setting button state
      final hasPermission = await handlePermissions(3);
      if (!hasPermission) {
        toast(
          "Microphone permission is required for voice recording",
          duration: const Duration(milliseconds: 1500),
        );
        return;
      }

      // Check if the button is still being held after permission check
      if (!_isVoiceButtonHeld.value) {
        return; // Exit if button is not held anymore
      }

      toast(
        "Swipe up to lock recording",
        duration: const Duration(milliseconds: 300),
      );

      _currentRecordingPath = await audioHandler.startRecording();
      if (_currentRecordingPath != null) {
        _startRecordingTimer();
      } else {
        toast(
          "Couldn't start recording",
          duration: const Duration(milliseconds: 300),
        );
        _resetRecordingState();
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        toast(
          "Please grant microphone permission in settings to record voice notes",
          duration: const Duration(milliseconds: 1500),
        );
      } else {
        toast(
          "Error starting recording",
          duration: const Duration(milliseconds: 300),
        );
      }
      debugPrint('Voice recording error: $e');
      _resetRecordingState();
    }
  }

  // Add method to initialize local player
  Future<void> _initLocalPlayer() async {
    if (!_isLocalPlayerInitialized) {
      try {
        await _localPlayer.openPlayer();
        _isLocalPlayerInitialized = true;
      } on Exception catch (e, stackTrace) {
        LMChatCore.instance.lmChatClient.handleException(e, stackTrace);
        debugPrint('Error initializing local player: $e');
      }
    }
  }

  // Add method to handle local playback
  Future<void> _handleLocalPlayback() async {
    if (_recordedFilePath == null) return;

    try {
      if (_isPlaying.value) {
        await _stopLocalPlayback();
      } else {
        if (!_isLocalPlayerInitialized) {
          await _initLocalPlayer();
        }

        await _localPlayer.startPlayer(
          fromURI: _recordedFilePath!,
          codec: Codec.defaultCodec,
          whenFinished: () {
            _isPlaying.value = false;
            _playbackProgress.value = PlaybackProgress(
              duration: _playbackProgress.value.duration,
              position: _playbackProgress.value.duration,
              isCompleted: true,
            );
          },
        );

        _isPlaying.value = true;

        // Setup progress tracking
        _localPlayer.setSubscriptionDuration(const Duration(milliseconds: 100));
        _localPlayer.onProgress!.listen(
          (e) {
            if (_isPlaying.value) {
              _playbackProgress.value = PlaybackProgress(
                duration: e.duration,
                position: e.position,
              );
            }
          },
          onError: (error) {
            debugPrint('Local playback error: $error');
            _stopLocalPlayback();
          },
        );
      }
    } on Exception catch (e, stackTrace) {
      LMChatCore.instance.lmChatClient.handleException(e, stackTrace);
      debugPrint('Error in local playback: $e');
      _stopLocalPlayback();
    }
  }

  // Add method to stop local playback
  Future<void> _stopLocalPlayback() async {
    if (_isLocalPlayerInitialized &&
        (_localPlayer.isPlaying || _localPlayer.isPaused)) {
      await _localPlayer.stopPlayer();
      _isPlaying.value = false;
    }
  }
}

/// This function shows a dialog based on the provided [LMDMDialogType] and allows the user
/// to perform actions such as confirming, canceling, or rejecting the DM request. The dialog
/// includes a title, a body, and a set of action buttons.
///
/// The dialog supports the following types:
/// - [LMDMDialogType.send]: Prompts the user to confirm sending a DM request.
/// - [LMDMDialogType.approve]: Prompts the user to approve a DM request.
/// - [LMDMDialogType.reject]: Prompts the user to reject a DM request, with an optional
///   "Report and Reject" action.
///
enum LMDMDialogType { send, approve, reject }

/// Represents the various states of a chatroom request in the application.
///
/// This enum is used to track the lifecycle of a chatroom request between two users.
/// For example, `user1` sends a chatroom request to `user2`, and the state of the request
/// transitions based on the actions taken by either user or the admin.
///
/// - `initiated`: The chatroom request has been sent by `user1` to `user2` but has not yet
///   been accepted or rejected. For example, `user1` sends a request to start a chatroom
///   with `user2`, and it is awaiting a response.
/// - `accepted`: The chatroom request has been accepted by `user2`. For example, `user2`
///   agrees to the chatroom request sent by `user1`, and the chatroom is now active.
/// - `rejected`: The chatroom request has been rejected by `user2`. For example, `user2`
///   declines the chatroom request sent by `user1`.
/// - `disabled`: The chatroom has been disabled by an admin. For example, an admin disables
///   the chatroom due to policy violations or other reasons.
/// - `notInitiated`: No chatroom request has been initiated between `user1` and `user2`.
///   For example, neither `user1` nor `user2` has sent a chatroom request.
enum LMChatroomRequestState {
  /// chatroom request is initiated but not yet accepted
  /// or rejected
  initiated(0),

  /// chatroom request is accepted
  accepted(1),

  /// chatroom request is rejected
  rejected(2),

  /// chatroom is disabled by admin
  disabled(10),

  /// chatroom request is not initiated
  notInitiated(3);

  final int value;

  const LMChatroomRequestState(this.value);

  factory LMChatroomRequestState.fromValue(int value) {
    switch (value) {
      case 0:
        return LMChatroomRequestState.initiated;
      case 10:
        return LMChatroomRequestState.disabled;
      case 3:
        return LMChatroomRequestState.notInitiated;
      case 1:
        return LMChatroomRequestState.accepted;
      case 2:
        return LMChatroomRequestState.rejected;
      default:
        return LMChatroomRequestState.initiated;
    }
  }
}
