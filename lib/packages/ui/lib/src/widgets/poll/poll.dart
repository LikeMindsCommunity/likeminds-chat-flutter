import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';

class PollTestScreen extends StatefulWidget {
  const PollTestScreen({super.key});

  @override
  State<PollTestScreen> createState() => _PollTestScreenState();
}

class _PollTestScreenState extends State<PollTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poll Test'),
      ),
      body: SingleChildScrollView(
        child: LMChatPoll(
          pollData: (LMChatConversationViewDataBuilder()
                ..answer("This is a poll conversation")
                ..createdAt(DateTime.now().toIso8601String())
                ..id(1)
                ..pollTypeText('Instant poll')
                ..submitTypeText("Public voting")
                ..multipleSelectNo(2)
                ..multipleSelectState(LMChatPollMultiSelectState.atLeast)
                ..pollAnswerText("Poll Answer Text")
                ..expiryTime(DateTime.now().millisecondsSinceEpoch)
                ..multipleSelectState(LMChatPollMultiSelectState.atLeast)
                ..multipleSelectNo(2)
                ..allowAddOption(true)
                ..poll([
                  (LMChatPollOptionViewDataBuilder()
                        ..text("Option 0")
                        ..noVotes(0))
                      .build(),
                  (LMChatPollOptionViewDataBuilder()
                        ..text("Option 1")
                        ..noVotes(1))
                      .build(),
                  (LMChatPollOptionViewDataBuilder()
                        ..text("Option 2")
                        ..noVotes(2))
                      .build(),
                  (LMChatPollOptionViewDataBuilder()
                        ..text("Option 3")
                        ..noVotes(3))
                      .build(),
                  (LMChatPollOptionViewDataBuilder()
                        ..text("Option 4")
                        ..noVotes(4))
                      .build(),
                ]))
              .build(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LMChatPoll extends StatefulWidget {
  LMChatPoll({
    super.key,
    required this.pollData,
    this.rebuildPollWidget,
    this.onEditVote,
    this.style = const LMChatPollStyle(),
    this.onOptionSelect,
    this.showSubmitButton = false,
    this.showAddOptionButton = false,
    this.showEditVoteButton = false,
    this.isVoteEditing = false,
    this.showTick,
    this.timeLeft,
    this.onAddOptionSubmit,
    this.onVoteClick,
    this.selectedOption = const [],
    this.onSubmit,
    this.onSubtextTap,
    this.pollQuestionBuilder,
    this.pollOptionBuilder,
    this.pollSelectionTextBuilder,
    this.pollSelectionText,
    this.addOptionButtonBuilder,
    this.submitButtonBuilder,
    this.subTextBuilder,
    this.pollActionBuilder,
    this.onSameOptionAdded,
    this.isMultiChoicePoll,
  });

  /// [ValueNotifier] to rebuild the poll widget
  final ValueNotifier<bool>? rebuildPollWidget;

  /// [LMChatPollViewData] to be displayed in the poll
  final LMChatConversationViewData pollData;

  /// Callback when the edit vote button is clicked
  final Function(LMChatPollViewData)? onEditVote;

  /// [LMChatPollStyle] Style for the poll
  final LMChatPollStyle style;

  /// Callback when an option is selected
  final void Function(LMChatPollViewData)? onOptionSelect;

  /// [bool] to show the submit button
  final bool showSubmitButton;

  /// [bool] to show edit vote button
  final bool showEditVoteButton;

  /// [bool] to show the add option button
  final bool showAddOptionButton;

  /// [bool] to show is poll votes are being edited
  bool isVoteEditing;

  /// [bool Function(LMPollOptionViewData optionViewData)] to show the tick
  final bool Function(LMChatPollViewData optionViewData)? showTick;

  /// [String] time left for the poll to end
  final String? timeLeft;

  /// Callback when the add option is submitted
  final void Function(String option)? onAddOptionSubmit;

  /// Callback when the vote is clicked
  final Function(LMChatPollViewData)? onVoteClick;

  /// [List<String>] selected options
  List<String> selectedOption;

  /// Callback when the submit button is clicked
  final Function(List<String> selectedOption)? onSubmit;

  /// Callback when the subtext is clicked
  final VoidCallback? onSubtextTap;

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

  /// [bool] to show if the poll is multi choice
  final bool? isMultiChoicePoll;

  @override
  State<LMChatPoll> createState() => _LMChatPollState();

  LMChatPoll copyWith({
    ValueNotifier<bool>? rebuildPollWidget,
    LMChatConversationViewData? pollData,
    Function(LMChatPollViewData)? onEditVote,
    LMChatPollStyle? style,
    void Function(LMChatPollViewData)? onOptionSelect,
    bool? showSubmitButton,
    bool? showAddOptionButton,
    bool? showEditVoteButton,
    bool? isVoteEditing,
    bool Function(LMChatPollViewData)? showTick,
    String? timeLeft,
    void Function(String option)? onAddOptionSubmit,
    Function(LMChatPollViewData)? onVoteClick,
    List<String>? selectedOption,
    Function(List<String> selectedOption)? onSubmit,
    VoidCallback? onSubtextTap,
    Widget Function(BuildContext)? pollQuestionBuilder,
    Widget Function(BuildContext)? pollOptionBuilder,
    Widget Function(BuildContext)? pollSelectionTextBuilder,
    String? pollSelectionText,
    Widget Function(BuildContext, LMChatButton, Function(String))?
        addOptionButtonBuilder,
    LMChatButtonBuilder? submitButtonBuilder,
    Widget Function(BuildContext)? subTextBuilder,
    VoidCallback? onSameOptionAdded,
    bool? isMultiChoicePoll,
  }) {
    return LMChatPoll(
      rebuildPollWidget: rebuildPollWidget ?? this.rebuildPollWidget,
      pollData: pollData ?? this.pollData,
      onEditVote: onEditVote ?? this.onEditVote,
      style: style ?? this.style,
      onOptionSelect: onOptionSelect ?? this.onOptionSelect,
      showSubmitButton: showSubmitButton ?? this.showSubmitButton,
      showAddOptionButton: showAddOptionButton ?? this.showAddOptionButton,
      showEditVoteButton: showEditVoteButton ?? this.showEditVoteButton,
      isVoteEditing: isVoteEditing ?? this.isVoteEditing,
      showTick: showTick ?? this.showTick,
      timeLeft: timeLeft ?? this.timeLeft,
      onAddOptionSubmit: onAddOptionSubmit ?? this.onAddOptionSubmit,
      onVoteClick: onVoteClick ?? this.onVoteClick,
      selectedOption: selectedOption ?? this.selectedOption,
      onSubmit: onSubmit ?? this.onSubmit,
      onSubtextTap: onSubtextTap ?? this.onSubtextTap,
      pollQuestionBuilder: pollQuestionBuilder ?? this.pollQuestionBuilder,
      pollOptionBuilder: pollOptionBuilder ?? this.pollOptionBuilder,
      pollSelectionTextBuilder:
          pollSelectionTextBuilder ?? this.pollSelectionTextBuilder,
      pollSelectionText: pollSelectionText ?? this.pollSelectionText,
      addOptionButtonBuilder:
          addOptionButtonBuilder ?? this.addOptionButtonBuilder,
      submitButtonBuilder: submitButtonBuilder ?? this.submitButtonBuilder,
      subTextBuilder: subTextBuilder ?? this.subTextBuilder,
      onSameOptionAdded: onSameOptionAdded ?? this.onSameOptionAdded,
      isMultiChoicePoll: isMultiChoicePoll ?? this.isMultiChoicePoll,
    );
  }
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
    pollQuestion = 'This is a poll';
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
    _lmChatPollStyle = widget.style;
    _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
    _setPollData();
  }

  @override
  void didUpdateWidget(covariant LMChatPoll oldWidget) {
    super.didUpdateWidget(oldWidget);
    _lmChatPollStyle = widget.style;
    _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
    _setPollData();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _rebuildPollWidget,
        builder: (context, value, __) {
          return Container(
            margin: _lmChatPollStyle.margin ,
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
                      type: LMChatIconType.icon,
                      icon: Icons.poll,
                      style: LMChatIconStyle(
                        color: theme.primaryColor,
                        size: 28,
                      ),
                    ),
                    LMChatDefaultTheme.kHorizontalPaddingSmall,
                    LMChatText(
                      widget.timeLeft ?? 'Ends in 8 days',
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
                if (widget.pollData.allowAddOption ?? false)
                  widget.addOptionButtonBuilder?.call(context,
                          _defAddOptionButton(context), _onAddOptionSubmit) ??
                      _defAddOptionButton(context),
                widget.subTextBuilder?.call(context) ?? _defSubText(),
                // if (widget.showSubmitButton ||
                //     (_isVoteEditing && (widget.isMultiChoicePoll ?? false)))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: widget.submitButtonBuilder?.call(
                        _defSubmitButton(),
                      ) ??
                      _defSubmitButton(),
                ),
              ],
            ),
          );
        });
  }

  LMChatText _defSubText() {
    return LMChatText(widget.pollData.pollAnswerText ?? '',
        onTap: widget.onSubtextTap,
        style: _lmChatPollStyle.pollAnswerStyle ??
            LMChatTextStyle(
              textStyle: TextStyle(
                height: 1.33,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: theme.primaryColor,
              ),
            ));
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
    // if ((widget.pollData.options?.length ?? 0) > 10) {
    //   widget.onAddOptionSubmit?.call(optionText);
    //   Navigator.of(context).pop();
    //   return;
    // }
    // String text = optionText.trim();
    // if (text.isEmpty) {
    //   _addOptionController.clear();
    //   return;
    // }
    // for (LMPollOptionViewData option in widget.pollData.options ?? []) {
    //   if (option.text == text) {
    //     Navigator.of(context).pop();
    //     _addOptionController.clear();
    //     widget.onSameOptionAdded?.call();
    //     return;
    //   }
    // }
    // setState(() {
    //   final LMPollOptionViewData newOption = (LMPostOptionViewDataBuilder()
    //         ..text(text)
    //         ..percentage(0)
    //         ..votes(0)
    //         ..isSelected(false))
    //       .build();
    //   widget.pollData.options?.add(newOption);
    //   _setPollData();
    // });
    // widget.onAddOptionSubmit?.call(optionText);
    // Navigator.of(context).pop();
    // _addOptionController.clear();
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
        if (pollMultiSelectNo == 1) {
          return null;
        } else {
          return "*Select ${pollMultiSelectState.name} $pollMultiSelectNo options.";
        }
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
            // widget.onOptionSelect?.call(widget.pollData.options![index]);
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
                      //Here you pass the percentage
                      value: 60 / 100,
                      // widget.pollData.options![index].percentage / 100,
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
                              _defAddedByMember(
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
                    // if (_isSelectedByUser(widget.pollData.options?[index]) ||
                    //     (widget.showTick != null &&
                    //         widget.showTick!(widget.pollData.options![index])))
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
        // if (!_lmChatPollStyle.isComposable &&
        //     widget.pollData.toShowResult != null &&
        //     !_isVoteEditing &&
        //     widget.pollData.toShowResult!)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: LMChatText(
            voteText(widget.pollData.poll![index].noVotes ?? 0),
            onTap: () {
              // widget.onVoteClick?.call(widget.pollData.options![index]);
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

  bool _isSelectedByUser(LMChatPollViewData? optionViewData) {
    if (optionViewData == null) {
      return false;
    }
    return widget.selectedOption.contains(optionViewData);
  }

  String _defAddedByMember(
    LMChatUserViewData? userViewData,
  ) {
    return "Added by ${userViewData?.name ?? ""}";
  }

  LMChatButton _defSubmitButton() {
    return LMChatButton(
        onTap: () {
          widget.onSubmit?.call(widget.selectedOption);
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
            ));
  }
}

String voteText(int voteCount) {
  if (voteCount == 1) {
    return '1 vote';
  } else {
    return '$voteCount votes';
  }
}
