import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/constants/assets.dart';

// ignore: must_be_immutable
class LMChatPoll extends StatefulWidget {
  LMChatPoll({
    super.key,
    required this.pollData,
    this.rebuildPollWidget,
    this.onEditVote,
    this.style,
    this.onOptionSelect,
    this.isVoteEditing = false,
    this.onAddOptionSubmit,
    this.onVoteClick,
    this.onSubmit,
    this.onAnswerTextTap,
    this.pollQuestionBuilder,
    this.pollOptionBuilder,
    this.pollSelectionTextBuilder,
    this.pollSelectionText,
    this.addOptionButtonBuilder,
    this.submitButtonBuilder,
    this.subTextBuilder,
    this.pollActionBuilder,
    this.onSameOptionAdded,
  });

  /// [ValueNotifier] to rebuild the poll widget
  final ValueNotifier<bool>? rebuildPollWidget;

  /// [LMChatPollViewData] to be displayed in the poll
  final LMChatConversationViewData pollData;

  /// Callback when the edit vote button is clicked
  final Function(LMChatPollViewData)? onEditVote;

  /// [LMChatPollStyle] Style for the poll
  final LMChatPollStyle? style;

  /// Callback when an option is selected
  final void Function(LMChatPollOptionViewData)? onOptionSelect;

  /// [bool] to show is poll votes are being edited
  bool isVoteEditing;

  /// Callback when the add option is submitted
  final void Function(String option)? onAddOptionSubmit;

  /// Callback when the vote is clicked
  final Function(LMChatPollOptionViewData)? onVoteClick;

  /// Callback when the submit button is clicked
  final Function(List<String> selectedOption)? onSubmit;

  /// Callback when the subtext is clicked
  final VoidCallback? onAnswerTextTap;

  /// [Widget Function(BuildContext)] Builder for the poll question
  final Widget Function(BuildContext)? pollQuestionBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll action
  final Widget Function(BuildContext)? pollActionBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll option
  final Widget Function(BuildContext)? pollOptionBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll selection text
  final Widget Function(BuildContext)? pollSelectionTextBuilder;

  /// [String] poll selection text
  final String? pollSelectionText;

  /// [Widget Function(BuildContext, LMChatButton,  Function(String))] Builder for the add option button
  final Widget Function(BuildContext, LMChatButton, Function(String))?
      addOptionButtonBuilder;

  /// [Widget Function(BuildContext)] Builder for the submit button
  final LMChatButtonBuilder? submitButtonBuilder;

  /// [Widget Function(BuildContext)] Builder for the subtext
  final Widget Function(BuildContext)? subTextBuilder;

  /// [VoidCallback] error callback to be called when same option is added
  final VoidCallback? onSameOptionAdded;

  @override
  State<LMChatPoll> createState() => _LMChatPollState();
}

class _LMChatPollState extends State<LMChatPoll> {
  String pollQuestion = '';
  List<String> pollOptions = [];
  String expiryTime = '';
  int multiSelectNo = 0;
  LMChatPollMultiSelectState multiSelectState =
      LMChatPollMultiSelectState.exactly;
  late LMChatPollStyle _lmChatPollStyle;
  final theme = LMChatTheme.theme;
  final TextEditingController _addOptionController = TextEditingController();
  late ValueNotifier<bool> _rebuildPollWidget;
  bool _isVoteEditing = false;

  void _setPollData() {
    pollQuestion = widget.pollData.answer;
    pollOptions = widget.pollData.poll?.map((e) => e.text).toList() ?? [];
    expiryTime =
        DateTime.fromMillisecondsSinceEpoch(widget.pollData.expiryTime ?? 0)
            .toString();
    multiSelectNo = widget.pollData.multipleSelectNo ?? 0;
    multiSelectState = widget.pollData.multipleSelectState ??
        LMChatPollMultiSelectState.exactly;
    _isVoteEditing = widget.isVoteEditing;
  }

  @override
  void initState() {
    super.initState();
    _lmChatPollStyle = widget.style ??
        LMChatPollStyle.basic(
          primaryColor: theme.primaryColor,
        );
    _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
    _setPollData();
  }

  // @override
  // void didUpdateWidget(covariant LMChatPoll oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _lmChatPollStyle = widget.style ??
  //       LMChatPollStyle.basic(
  //         primaryColor: theme.primaryColor,
  //       );
  //   _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
  //   _setPollData();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _rebuildPollWidget,
        builder: (context, value, __) {
          return Container(
            margin: _lmChatPollStyle.margin,
            padding: _lmChatPollStyle.padding ?? const EdgeInsets.all(16),
            decoration: _lmChatPollStyle.decoration?.copyWith(
                  color: _lmChatPollStyle.backgroundColor ?? theme.container,
                ) ??
                BoxDecoration(
                  color: _lmChatPollStyle.backgroundColor ?? theme.container,
                  borderRadius: _lmChatPollStyle.isComposable
                      ? BorderRadius.circular(8)
                      : null,
                  border: _lmChatPollStyle.isComposable
                      ? Border.all(
                          color: theme.inActiveColor,
                        )
                      : null,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LMChatText(
                      widget.pollData.pollTypeText ?? '',
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          height: 1.33,
                          fontSize: 14,
                          color: theme.inActiveColor,
                        ),
                      ),
                    ),
                    LMChatDefaultTheme.kHorizontalPaddingSmall,
                    // separator
                    LMChatText(
                      '●',
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          fontSize: 6,
                          color: theme.inActiveColor,
                        ),
                      ),
                    ),
                    LMChatDefaultTheme.kHorizontalPaddingSmall,
                    LMChatText(
                      widget.pollData.submitTypeText ?? '',
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          height: 1.33,
                          fontSize: 14,
                          color: theme.inActiveColor,
                        ),
                      ),
                    ),
                  ],
                ),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LMChatIcon(
                      type: LMChatIconType.svg,
                      assetPath: kPollIcon,
                      style: LMChatIconStyle(
                        // TODO: sort out the color issues with svg icons
                        color: theme.primaryColor,
                        size: 32,
                      ),
                    ),
                    LMChatDefaultTheme.kHorizontalPaddingSmall,
                    LMChatText(
                      LMChatPollUtils.getTimeLeftInPoll(
                          widget.pollData.expiryTime),
                      style: LMChatTextStyle(
                        borderRadius: 100,
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        textStyle: TextStyle(
                          height: 1.33,
                          fontSize: 14,
                          color: theme.container,
                        ),
                      ),
                    ),
                  ],
                ),
                widget.pollQuestionBuilder?.call(context) ?? _defPollQuestion(),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                widget.pollSelectionTextBuilder?.call(context) ??
                    _defPollSubtitle(),
                const SizedBox(height: 8),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: pollOptions.length,
                    itemBuilder: (context, index) {
                      return widget.pollOptionBuilder?.call(
                            context,
                          ) ??
                          _defPollOption(index);
                    }),
                //add and option button
                if (LMChatPollUtils.showAddOption(widget.pollData))
                  widget.addOptionButtonBuilder?.call(context,
                          _defAddOptionButton(context), _onAddOptionSubmit) ??
                      _defAddOptionButton(context),
                widget.subTextBuilder?.call(context) ?? _defSubText(),
                if (LMChatPollUtils.showSubmitButton(widget.pollData))
                  widget.submitButtonBuilder?.call(
                        _defSubmitButton(),
                      ) ??
                      _defSubmitButton(),
                if (widget.isVoteEditing)
                  widget.submitButtonBuilder?.call(
                        _defEditButton(),
                      ) ??
                      _defEditButton(),
              ],
            ),
          );
        });
  }

  LMChatText _defSubText() {
    return LMChatText(
      widget.pollData.pollAnswerText ?? '',
      onTap: widget.onAnswerTextTap,
      style: _lmChatPollStyle.pollAnswerStyle ??
          LMChatTextStyle(
            textStyle: TextStyle(
              height: 1.33,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            ),
          ),
    );
  }

  LMChatButton _defAddOptionButton(BuildContext context) {
    return LMChatButton(
      onTap: () {
        //add option bottom sheet
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: theme.container,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 8,
                    decoration: ShapeDecoration(
                      color: theme.disabledColor..withAlpha(200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LMChatText(
                        'Add new poll option',
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            height: 1.33,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      LMChatButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        style: const LMChatButtonStyle(
                          backgroundColor: Colors.transparent,
                          icon: LMChatIcon(
                              type: LMChatIconType.icon, icon: Icons.close),
                        ),
                      ),
                    ],
                  ),
                  LMChatDefaultTheme.kVerticalPaddingSmall,
                  LMChatText(
                    'Enter an option that you think is missing in this poll. This can not be undone.',
                    style: LMChatTextStyle(
                        textStyle: TextStyle(
                      height: 1.33,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.inActiveColor,
                      overflow: TextOverflow.visible,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextField(
                      controller: _addOptionController,
                      decoration: const InputDecoration(
                        hintText: 'Type new option',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  LMChatButton(
                    onTap: () {
                      _onAddOptionSubmit(_addOptionController.text);
                    },
                    text: LMChatText(
                      'SUBMIT',
                      style: _lmChatPollStyle.submitPollTextStyle ??
                          LMChatTextStyle(
                            textStyle: TextStyle(
                              height: 1.33,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: theme.container,
                            ),
                          ),
                    ),
                    style: _lmChatPollStyle.submitPollButtonStyle ??
                        LMChatButtonStyle(
                          backgroundColor: theme.primaryColor,
                          borderRadius: 100,
                          width: 150,
                          height: 44,
                        ),
                  ),
                  LMChatDefaultTheme.kVerticalPaddingMedium,
                ],
              ),
            ),
          ),
        );
      },
      text: const LMChatText(
        '+ Add an option',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            height: 1.33,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      style: LMChatButtonStyle(
        backgroundColor: theme.container,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        borderRadius: 8,
        border: Border.all(
          color: theme.primaryColor,
        ),
      ),
    );
  }

  void _onAddOptionSubmit(String optionText) {
    widget.onAddOptionSubmit?.call(optionText);
    Navigator.of(context).pop();
    _addOptionController.clear();
  }

  Widget _defPollSubtitle() {
    return LMChatText(
      _getPollSelectionText(widget.pollData.multipleSelectState,
              widget.pollData.multipleSelectNo) ??
          '',
      style: _lmChatPollStyle.pollInfoStyles ??
          const LMChatTextStyle(
            textStyle: TextStyle(
              height: 1.33,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
    );
  }

  String? _getPollSelectionText(
      LMChatPollMultiSelectState? pollMultiSelectState,
      int? pollMultiSelectNo) {
    if (pollMultiSelectNo == null || pollMultiSelectState == null) {
      return null;
    }
    switch (pollMultiSelectState) {
      case LMChatPollMultiSelectState.exactly:
        return "*Select ${pollMultiSelectState.name} $pollMultiSelectNo options.";
      case LMChatPollMultiSelectState.atMax:
        return "*Select ${pollMultiSelectState.name} $pollMultiSelectNo options.";
      case LMChatPollMultiSelectState.atLeast:
        return "*Select ${pollMultiSelectState.name} $pollMultiSelectNo options.";
      default:
        return null;
    }
  }

  LMChatExpandableText _defPollQuestion() {
    return LMChatExpandableText(
      pollQuestion,
      expandText: _lmChatPollStyle.pollQuestionExpandedText ?? "See more",
      onTagTap: (value) {},
      style: _lmChatPollStyle.pollQuestionStyle ??
          TextStyle(
            color: theme.onContainer,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget _defPollOption(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            widget.onOptionSelect?.call(widget.pollData.poll![index]);
          },
          child: Stack(
            children: [
              if (widget.pollData.toShowResults != null &&
                  widget.pollData.toShowResults! &&
                  !_isVoteEditing &&
                  !_lmChatPollStyle.isComposable)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(
                      value:
                          (widget.pollData.poll![index].percentage ?? 0) / 100,
                      color: widget.pollData.poll?[index].isSelected ?? false
                          ? _lmChatPollStyle
                              .pollOptionStyle?.pollOptionSelectedColor
                          : _lmChatPollStyle
                              .pollOptionStyle?.pollOptionOtherColor,
                      backgroundColor: theme.container,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration:
                    _lmChatPollStyle.pollOptionStyle?.pollOptionDecoration ??
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (!_lmChatPollStyle.isComposable &&
                                    widget.pollData.toShowResults != null &&
                                    !_isVoteEditing &&
                                    widget.pollData.toShowResults!
                                //     &&
                                //     widget.pollData.poll![index]
                                //         .isSelected) ||
                                // _isSelectedByUser(
                                //     widget.pollData.options?[index]) ||
                                // (widget.showTick != null &&
                                //     widget.showTick!(
                                //         widget.pollData.options![index])
                                )
                                ? _lmChatPollStyle.pollOptionStyle
                                        ?.pollOptionSelectedBorderColor ??
                                    theme.primaryColor
                                : theme.inActiveColor,
                          ),
                        ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LMChatText(pollOptions[index],
                            style: _lmChatPollStyle
                                    .pollOptionStyle?.pollOptionTextStyle ??
                                const LMChatTextStyle(
                                  maxLines: 1,
                                  textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    // color: theme.primaryColor,
                                    // _isSelectedByUser(widget
                                    //             .pollData.options?[index]) ||
                                    //         (widget.showTick != null &&
                                    //             widget.showTick!(widget
                                    //                 .pollData.options![index]))
                                    //     ? _lmChatPollStyle.pollOptionStyle
                                    //             ?.pollOptionSelectedTextColor ??
                                    //         theme.primaryColor
                                    //     : theme.onContainer,
                                    height: 1.25,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                        if (widget.pollData.allowAddOption ?? false)
                          LMChatText(
                              LMChatPollUtils.defAddedByMember(
                                  widget.pollData.poll?[index].member),
                              style: LMChatTextStyle(
                                maxLines: 1,
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.25,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: theme.inActiveColor,
                                ),
                              )),
                      ],
                    ),
                    if (LMChatPollUtils.showTick(widget.pollData,
                        widget.pollData.poll![index], [], _isVoteEditing))
                      Padding(
                        padding: widget.pollData.allowAddOption ?? false
                            ? const EdgeInsets.only(
                                top: 5,
                              )
                            : EdgeInsets.zero,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: LMChatIcon(
                            type: LMChatIconType.icon,
                            icon: Icons.check_circle,
                            style: LMChatIconStyle(
                              boxSize: 24,
                              size: 24,
                              color: _lmChatPollStyle.pollOptionStyle
                                      ?.pollOptionSelectedTickColor ??
                                  theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: LMChatText(
            LMChatPollUtils.voteText(widget.pollData.poll![index].noVotes ?? 0),
            onTap: () {
              widget.onVoteClick?.call(widget.pollData.poll![index]);
            },
            style: _lmChatPollStyle.pollOptionStyle?.votesCountStyles ??
                LMChatTextStyle(
                  textStyle: TextStyle(
                    height: 1.33,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.inActiveColor,
                  ),
                ),
          ),
        ),
        LMChatDefaultTheme.kVerticalPaddingMedium,
      ],
    );
  }

  LMChatButton _defEditButton() {
    return LMChatButton(
        onTap: () {
          widget.onSubmit?.call([]);
        },
        text: LMChatText(
          'Edit Vote',
          style: _lmChatPollStyle.submitPollTextStyle ??
              LMChatTextStyle(
                textStyle: TextStyle(
                  height: 1.33,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.primaryColor,
                ),
              ),
        ),
        style: _lmChatPollStyle.submitPollButtonStyle ??
            LMChatButtonStyle(
              icon: LMChatIcon(
                type: LMChatIconType.icon,
                icon: Icons.edit,
                style: LMChatIconStyle(
                  color: theme.primaryColor,
                ),
              ),
              backgroundColor: theme.container,
              borderRadius: 100,
              border: Border.all(
                color: theme.primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 8),
              spacing: 8,
            ));
  }

  LMChatButton _defSubmitButton() {
    return LMChatButton(
        onTap: () {
          widget.onSubmit?.call([]);
        },
        text: LMChatText(
          'Submit Vote',
          style: _lmChatPollStyle.submitPollTextStyle ??
              LMChatTextStyle(
                textStyle: TextStyle(
                  height: 1.33,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: theme.primaryColor,
                ),
              ),
        ),
        style: _lmChatPollStyle.submitPollButtonStyle ??
            LMChatButtonStyle(
              icon: LMChatIcon(
                type: LMChatIconType.icon,
                icon: Icons.touch_app_outlined,
                style: LMChatIconStyle(
                  color: theme.primaryColor,
                ),
              ),
              backgroundColor: theme.container,
              borderRadius: 100,
              border: Border.all(
                color: theme.primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 8),
              spacing: 8,
            ));
  }
}

/// {@template lm_chat_poll_utils}
/// Utility class for poll related operations.
/// {@endtemplate}
class LMChatPollUtils {
  /// Determines whether to show the edit vote button.
  static bool showEditVote(LMChatConversationViewData conversationData) {
    if (hasPollEnded(conversationData.expiryTime)) {
      return false;
    }
    if (isPollSubmitted(conversationData.poll ?? []) &&
        conversationData.pollType == LMChatPollType.deferred) {
      return true;
    }
    return false;
  }

  /// Determines whether to show the add option button.
  static bool showAddOption(LMChatConversationViewData conversationData) {
    // return false if poll has ended.
    if (hasPollEnded(conversationData.expiryTime)) {
      return false;
    }
    // if allowAddOption is true check if the poll is submitted or not
    if (conversationData.allowAddOption == true) {
      // if poll is not submitted return true
      if (!isPollSubmitted(conversationData.poll ?? [])) {
        return true;
      }
      // if poll is submitted and poll type is deferred return true
      if (conversationData.pollType == LMChatPollType.deferred) {
        return true;
      }
    }
    // return false if the above conditions are not met
    return false;
  }

  /// Determines whether to show the tick mark for a poll option.
  static bool showTick(
      LMChatConversationViewData conversationData,
      LMChatPollOptionViewData option,
      List<int> selectedOption,
      bool isVoteEditing) {
    if (isVoteEditing) {
      return selectedOption.contains(option.id);
    }
    if ((isMultiChoicePoll(conversationData.multipleSelectNo,
                conversationData.multipleSelectState) ||
            isInstantPoll(conversationData.pollType!) == false) &&
        option.isSelected == true) {
      return true;
    } else {
      return false;
    }
  }

  /// Returns the vote count text based on the number of votes.
  static String voteText(int voteCount) {
    if (voteCount == 1) {
      return '1 vote';
    } else {
      return '$voteCount votes';
    }
  }

  /// Determines whether to show the submit button for the poll.
  static bool showSubmitButton(LMChatConversationViewData conversationData) {
    if (isPollSubmitted(conversationData.poll ?? [])) {
      return false;
    }
    if ((conversationData.pollType != null &&
            isInstantPoll(conversationData.pollType!) &&
            isPollSubmitted(conversationData.poll!)) ||
        hasPollEnded(conversationData.expiryTime)) {
      return false;
    } else if (!isMultiChoicePoll(conversationData.multipleSelectNo,
        conversationData.multipleSelectState)) {
      return false;
    } else {
      return true;
    }
  }

  /// Checks if the poll has been submitted.
  static bool isPollSubmitted(List<LMChatPollOptionViewData> poll) {
    return poll.any((element) => element.isSelected ?? false);
  }

  /// Checks if the poll has ended based on the expiry time.
  static bool hasPollEnded(int? expiryTime) {
    return expiryTime != null &&
        DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  /// Checks if the poll is an instant poll.
  static bool isInstantPoll(LMChatPollType? pollType) {
    return pollType != null && pollType == LMChatPollType.instant;
  }

  /// Checks if the poll is a multi-choice poll.
  static bool isMultiChoicePoll(int? pollMultiSelectNo,
      LMChatPollMultiSelectState? pollMultiSelectState) {
    if (pollMultiSelectNo == null || pollMultiSelectState == null) {
      return false;
    }
    if (pollMultiSelectState == LMChatPollMultiSelectState.exactly &&
        pollMultiSelectNo == 1) {
      return false;
    }
    return true;
  }

  /// Determines whether the option is selected by the user.
  static bool isSelectedByUser(
      LMChatPollOptionViewData? optionViewData, List<int> selectedOption) {
    if (optionViewData == null) {
      return false;
    }
    return selectedOption.contains(optionViewData.id);
  }

  /// Returns the vote count text based on the number of votes.
  static String defAddedByMember(
    LMChatUserViewData? userViewData,
  ) {
    return "Added by ${userViewData?.name ?? ""}";
  }

  /// Returns the time left in the poll.
  static String getTimeLeftInPoll(int? expiryTime) {
    if (expiryTime == null) {
      return "";
    }
    DateTime expiryTimeInDateTime =
        DateTime.fromMillisecondsSinceEpoch(expiryTime);
    DateTime now = DateTime.now();
    Duration difference = expiryTimeInDateTime.difference(now);
    if (difference.isNegative) {
      return "Poll Ended";
    }
    if (difference.inDays > 1) {
      return "Ends in ${difference.inDays} days";
    } else if (difference.inDays > 0) {
      return "Ends in ${difference.inDays} day";
    } else if (difference.inHours > 0) {
      return "Ends in  ${difference.inHours} hours";
    } else if (difference.inMinutes > 0) {
      return "Ends in  ${difference.inMinutes} minutes";
    } else {
      return "Just Now";
    }
  }
}
