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
      body: Center(
        child: SizedBox(
          height: 50.h,
          child: LMChatPoll(
            pollData: (LMChatConversationViewDataBuilder()
                  ..answer("This is a poll conversation")
                  ..createdAt(DateTime.now().toIso8601String())
                  ..id(1)
                  ..pollAnswerText("Poll Answer Text")
                  ..expiryTime(DateTime.now().millisecondsSinceEpoch)
                  ..multipleSelectState(LMChatPollMultiSelectState.atLeast)
                  ..multipleSelectNo(2)
                  ..poll([
                    (LMChatPollOptionViewDataBuilder()..text("Option 1"))
                        .build(),
                    (LMChatPollOptionViewDataBuilder()..text("Option 2"))
                        .build(),
                    (LMChatPollOptionViewDataBuilder()..text("Option 3"))
                        .build(),
                  ]))
                .build(),
          ),
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
            margin: _lmChatPollStyle.margin ??
                const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
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
                widget.pollQuestionBuilder?.call(context) ?? _defPollQuestion(),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                widget.pollSelectionTextBuilder?.call(context) ??
                    _defPollSubtitle(),
                const SizedBox(height: 8),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: pollOptions.length,
                    itemBuilder: (context, index) {
                      return widget.pollOptionBuilder?.call(
                            context,
                          ) ??
                          _defPollOption(index);
                    }),
                //add and option button
                if (widget.showAddOptionButton)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: widget.addOptionButtonBuilder?.call(context,
                            _defAddOptionButton(context), _onAddOptionSubmit) ??
                        _defAddOptionButton(context),
                  ),

                if (widget.showSubmitButton ||
                    (_isVoteEditing && (widget.isMultiChoicePoll ?? false)))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: widget.submitButtonBuilder?.call(
                          _defSubmitButton(),
                        ) ??
                        _defSubmitButton(),
                  ),
                widget.subTextBuilder?.call(context) ?? _defSubText(),
              ],
            ),
          );
        });
  }

  Row _defSubText() {
    return Row(
      children: [
        LMChatText(widget.pollData?.pollAnswerText ?? '',
            onTap: widget.onSubtextTap,
            style: _lmChatPollStyle.pollAnswerStyle ??
                LMChatTextStyle(
                  textStyle: TextStyle(
                    height: 1.33,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.primaryColor,
                  ),
                )),
        LMChatDefaultTheme.kHorizontalPaddingSmall,
        LMChatText(
          '●',
          style: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: LMChatDefaultTheme.kFontSmall,
              color: theme.inActiveColor,
            ),
          ),
        ),
        LMChatDefaultTheme.kHorizontalPaddingSmall,
        LMChatText(
          widget.timeLeft ?? '',
          style: _lmChatPollStyle.timeStampStyle ??
              LMChatTextStyle(
                textStyle: TextStyle(
                  height: 1.33,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: theme.inActiveColor,
                ),
              ),
        ),
        if (widget.showEditVoteButton && !_isVoteEditing)
          Row(
            children: [
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              LMChatText(
                '●',
                style: LMChatTextStyle(
                  textStyle: TextStyle(
                    fontSize: LMChatDefaultTheme.kFontSmall,
                    color: theme.inActiveColor,
                  ),
                ),
              ),
              LMChatDefaultTheme.kHorizontalPaddingSmall,
              LMChatText(
                'Edit Vote',
                onTap: () {
                  // widget.onEditVote?.call(widget.pollData);
                  _isVoteEditing = true;
                  _rebuildPollWidget.value = !_rebuildPollWidget.value;
                },
                style: _lmChatPollStyle.editPollOptionsStyles ??
                    LMChatTextStyle(
                      textStyle: TextStyle(
                        height: 1.33,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.primaryColor,
                      ),
                    ),
              ),
            ],
          ),
      ],
    );
  }

  LMChatButton _defAddOptionButton(BuildContext context) {
    return LMChatButton(
      onTap: () {
        //add option bottom sheet
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: LMChatText(
                      'Add new poll option',
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          height: 1.33,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        borderRadius: 8,
        border: Border.all(
          color: theme.inActiveColor,
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
    return widget.pollSelectionText == null
        ? const SizedBox.shrink()
        : LMChatText(
            widget.pollSelectionText!,
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
                          // border: Border.all(
                          //   color: (!_lmChatPollStyle.isComposable &&
                          //               widget.pollData.toShowResult != null &&
                          //               !_isVoteEditing &&
                          //               widget.pollData.toShowResult! &&
                          //               widget.pollData.options![index]
                          //                   .isSelected) ||
                          //           _isSelectedByUser(
                          //               widget.pollData.options?[index]) ||
                          //           (widget.showTick != null &&
                          //               widget.showTick!(
                          //                   widget.pollData.options![index]))
                          //       ? _lmChatPollStyle.pollOptionStyle
                          //               ?.pollOptionSelectedBorderColor ??
                          //           theme.primaryColor
                          //       : theme.inActiveColor,
                          // ),
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
                                LMChatTextStyle(
                                  maxLines: 1,
                                  textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: theme.primaryColor,
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
                        // if (widget.pollData.allowAddOption ?? false)
                        LMChatText("user",
                            // _defAddedByMember(
                            //     widget.pollData.options?[index].userViewData),
                            style: LMChatTextStyle(
                              maxLines: 1,
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                height: 1.25,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: true
                                    // _isSelectedByUser(
                                    //             widget.pollData.options?[index]) ||
                                    //         (widget.showTick != null &&
                                    //             widget.showTick!(widget
                                    //                 .pollData.options![index]))
                                    ? _lmChatPollStyle.pollOptionStyle
                                            ?.pollOptionSelectedTextColor ??
                                        theme.primaryColor
                                    : _lmChatPollStyle.pollOptionStyle
                                            ?.pollOptionOtherTextColor ??
                                        theme.inActiveColor,
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
                            boxSize: 20,
                            size: 20,
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
            "12",
            // voteText(widget.pollData.options![index].voteCount),
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
                  color: theme.container,
                ),
              ),
        ),
        style: _lmChatPollStyle.submitPollButtonStyle ??
            LMChatButtonStyle(
              backgroundColor: theme.primaryColor,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
