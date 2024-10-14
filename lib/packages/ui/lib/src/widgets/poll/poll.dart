import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/packages/expandable_text/expandable_text.dart';

part './poll_utils.dart';

/// {@template lm_chat_poll}
/// A widget that represents a poll in the LM Chat application.
///
/// This widget is a stateful widget that allows users to interact with
/// and participate in polls within the chat interface.
///
/// The `LMChatPoll` widget is designed to be used within the chat UI
/// and provides functionality for displaying poll options and handling
/// user input.
///
/// See also:
/// - [StatefulWidget], which is the base class for widgets that have mutable state.
/// - [LMChatPollState], which contains the state logic for this widget.
/// {@endtemplate}
class LMChatPoll extends StatefulWidget {
  /// {@macro lm_chat_poll}
  const LMChatPoll({
    super.key,
    required this.pollData,
    this.rebuildPollWidget,
    this.onEditVote,
    this.style,
    this.onOptionSelect,
    this.isVoteEditing = false,
    this.selectedOption = const [],
    this.onAddOptionSubmit,
    this.onVoteClick,
    this.onSubmit,
    this.onAnswerTextTap,
    this.pollQuestionBuilder,
    this.pollOptionBuilder,
    this.pollSelectionTextBuilder,
    this.addOptionButtonBuilder,
    this.submitButtonBuilder,
    this.editButtonBuilder,
    this.subTextBuilder,
    this.pollTypeTextBuilder,
    this.pollHeaderSeparatorBuilder,
    this.votingTypeTextBuilder,
    this.pollIconBuilder,
    this.timeLeftTextBuilder,
  });

  /// [ValueNotifier] to rebuild the poll widget
  final ValueNotifier<bool>? rebuildPollWidget;

  /// [LMChatPollViewData] to be displayed in the poll
  final LMChatConversationViewData pollData;

  /// Callback when the edit vote button is clicked
  final Function(LMChatConversationViewData)? onEditVote;

  /// [LMChatPollStyle] Style for the poll
  final LMChatPollStyle? style;

  /// Callback when an option is selected
  final void Function(LMChatPollOptionViewData)? onOptionSelect;

  /// [bool] to show is poll votes are being edited
  final bool isVoteEditing;

  /// [List<int>] selected option
  final List<int> selectedOption;

  /// Callback when the add option is submitted
  final void Function(String option)? onAddOptionSubmit;

  /// Callback when the vote is clicked
  final Function(LMChatPollOptionViewData)? onVoteClick;

  /// Callback when the submit button is clicked
  final Function(List<LMChatPollOptionViewData> selectedOption)? onSubmit;

  /// Callback when the subtext is clicked
  final VoidCallback? onAnswerTextTap;

  /// A builder function for creating a custom widget to display poll type text.
  ///
  /// The function takes a [BuildContext] and an optional [LMChatText] as parameters.
  ///
  /// - [context]: The build context in which the widget is built.
  /// - [pollTypeText]: An optional [LMChatText] object containing the poll type text.
  final Widget Function(BuildContext, LMChatText)? pollTypeTextBuilder;

  /// A builder function for creating a custom widget to display a separator in the poll header.
  ///
  /// The function takes a [BuildContext] as a parameter.
  ///
  /// - [context]: The build context in which the widget is built.
  final Widget Function(BuildContext)? pollHeaderSeparatorBuilder;

  /// A builder function for creating a custom widget to display voting type text.
  ///
  /// The function takes a [BuildContext] and an optional [LMChatText] as parameters.
  ///
  /// - [context]: The build context in which the widget is built.
  /// - [votingTypeText]: An optional [LMChatText] object containing the voting type text.
  final Widget Function(BuildContext, LMChatText)? votingTypeTextBuilder;

  /// A builder function for creating a custom widget to display a poll icon.
  ///
  /// The function takes a [BuildContext] and an optional [LMChatIcon] as parameters.
  ///
  /// - [context]: The build context in which the widget is built.
  /// - [pollIcon]: An optional [LMChatIcon] object containing the poll icon.
  final Widget Function(BuildContext, LMChatIcon)? pollIconBuilder;

  /// A builder function for creating a custom widget to display the time left for the poll.
  ///
  /// The function takes a [BuildContext] and an optional [LMChatText] as parameters.
  ///
  /// - [context]: The build context in which the widget is built.
  /// - [timeLeftText]: An optional [LMChatText] object containing the time left text.
  final Widget Function(BuildContext, LMChatText)? timeLeftTextBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll question
  final Widget Function(BuildContext, LMChatExpandableText)?
      pollQuestionBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll selection text
  final Widget Function(BuildContext, LMChatText)? pollSelectionTextBuilder;

  /// [Widget Function(BuildContext)] Builder for the poll option
  final Widget Function(
    BuildContext,
    LMChatPollOption,
    LMChatPollOptionViewData,
  )? pollOptionBuilder;

  /// [Widget Function(BuildContext, LMChatButton,  Function(String))] Builder for the add option button
  final Widget Function(BuildContext, LMChatButton, Function(String))?
      addOptionButtonBuilder;

  /// [LMChatButtonBuilder] Builder for the submit button
  final LMChatButtonBuilder? submitButtonBuilder;

  /// [LMChatButtonBuilder] Builder for the edit button
  final LMChatButtonBuilder? editButtonBuilder;

  /// [Widget Function(BuildContext)] Builder for the subtext
  final Widget Function(BuildContext, LMChatText)? subTextBuilder;

  /// copyWith method for the LMChatPoll
  /// Returns a new instance of LMChatPoll with the updated values
  /// The values that are not updated remain the same
  LMChatPoll copyWith({
    ValueNotifier<bool>? rebuildPollWidget,
    LMChatConversationViewData? pollData,
    Function(LMChatConversationViewData)? onEditVote,
    LMChatPollStyle? style,
    void Function(LMChatPollOptionViewData)? onOptionSelect,
    bool? isVoteEditing,
    List<int>? selectedOption,
    void Function(String option)? onAddOptionSubmit,
    Function(LMChatPollOptionViewData)? onVoteClick,
    Function(List<LMChatPollOptionViewData> selectedOption)? onSubmit,
    VoidCallback? onAnswerTextTap,
    Widget Function(BuildContext, LMChatText)? pollTypeTextBuilder,
    Widget Function(BuildContext)? pollHeaderSeparatorBuilder,
    Widget Function(BuildContext, LMChatText)? voteTypeTextBuilder,
    Widget Function(BuildContext, LMChatIcon)? pollIconBuilder,
    Widget Function(BuildContext, LMChatText)? timeLeftTextBuilder,
    Widget Function(BuildContext, LMChatExpandableText)? pollQuestionBuilder,
    Widget Function(BuildContext, LMChatText)? pollSelectionTextBuilder,
    Widget Function(
      BuildContext,
      LMChatPollOption,
      LMChatPollOptionViewData,
    )? pollOptionBuilder,
    Widget Function(BuildContext, LMChatButton, Function(String))?
        addOptionButtonBuilder,
    LMChatButtonBuilder? submitButtonBuilder,
    LMChatButtonBuilder? editButtonBuilder,
    Widget Function(BuildContext, LMChatText)? subTextBuilder,
  }) {
    return LMChatPoll(
      rebuildPollWidget: rebuildPollWidget ?? this.rebuildPollWidget,
      pollData: pollData ?? this.pollData,
      onEditVote: onEditVote ?? this.onEditVote,
      style: style ?? this.style,
      onOptionSelect: onOptionSelect ?? this.onOptionSelect,
      isVoteEditing: isVoteEditing ?? this.isVoteEditing,
      selectedOption: selectedOption ?? this.selectedOption,
      onAddOptionSubmit: onAddOptionSubmit ?? this.onAddOptionSubmit,
      onVoteClick: onVoteClick ?? this.onVoteClick,
      onSubmit: onSubmit ?? this.onSubmit,
      onAnswerTextTap: onAnswerTextTap ?? this.onAnswerTextTap,
      pollTypeTextBuilder: pollTypeTextBuilder ?? this.pollTypeTextBuilder,
      pollHeaderSeparatorBuilder:
          pollHeaderSeparatorBuilder ?? this.pollHeaderSeparatorBuilder,
      votingTypeTextBuilder: voteTypeTextBuilder ?? this.votingTypeTextBuilder,
      pollIconBuilder: pollIconBuilder ?? this.pollIconBuilder,
      timeLeftTextBuilder: timeLeftTextBuilder ?? this.timeLeftTextBuilder,
      pollQuestionBuilder: pollQuestionBuilder ?? this.pollQuestionBuilder,
      pollSelectionTextBuilder:
          pollSelectionTextBuilder ?? this.pollSelectionTextBuilder,
      pollOptionBuilder: pollOptionBuilder ?? this.pollOptionBuilder,
      addOptionButtonBuilder:
          addOptionButtonBuilder ?? this.addOptionButtonBuilder,
      submitButtonBuilder: submitButtonBuilder ?? this.submitButtonBuilder,
      editButtonBuilder: editButtonBuilder ?? this.editButtonBuilder,
      subTextBuilder: subTextBuilder ?? this.subTextBuilder,
    );
  }

  @override
  State<LMChatPoll> createState() => _LMChatPollState();
}

class _LMChatPollState extends State<LMChatPoll> {
  final theme = LMChatTheme.theme;
  late LMChatPollStyle _lmChatPollStyle;
  final TextEditingController _addOptionController = TextEditingController();
  late ValueNotifier<bool> _rebuildPollWidget;
  bool _isVoteEditing = false;
  late List<int> selectedOption;
  late LMChatConversationViewData pollData;

// set poll data
  void _setPollData() {
    pollData = widget.pollData;
    _isVoteEditing = widget.isVoteEditing;
    selectedOption = widget.selectedOption;
  }

  @override
  void initState() {
    super.initState();
    // set poll style
    _lmChatPollStyle = widget.style ?? theme.pollStyle;
    // assign value notifier
    _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
    _setPollData();
  }

  @override
  void didUpdateWidget(covariant LMChatPoll oldWidget) {
    super.didUpdateWidget(oldWidget);
    // set poll style
    _lmChatPollStyle = widget.style ?? theme.pollStyle;
    // assign value notifier
    _rebuildPollWidget = widget.rebuildPollWidget ?? ValueNotifier(false);
    _setPollData();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _rebuildPollWidget,
        builder: (context, value, __) {
          return Container(
            margin: _lmChatPollStyle.margin,
            padding: _lmChatPollStyle.padding,
            decoration: _lmChatPollStyle.decoration?.copyWith(
                  color: _lmChatPollStyle.backgroundColor ?? theme.container,
                ) ??
                BoxDecoration(
                  color: _lmChatPollStyle.backgroundColor ?? theme.container,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.pollTypeTextBuilder?.call(
                          context,
                          _defPollTypeText(),
                        ) ??
                        _defPollTypeText(),
                    widget.pollHeaderSeparatorBuilder?.call(context) ??
                        _defHeaderSeparator(),
                    widget.votingTypeTextBuilder?.call(
                          context,
                          _defVotingTypeText(),
                        ) ??
                        _defVotingTypeText(),
                  ],
                ),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.pollIconBuilder?.call(
                          context,
                          _defPollIcon(),
                        ) ??
                        _defPollIcon(),
                    widget.timeLeftTextBuilder?.call(
                          context,
                          _defTimeLeftText(),
                        ) ??
                        _defTimeLeftText(),
                  ],
                ),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                widget.pollQuestionBuilder?.call(context, _defPollQuestion()) ??
                    _defPollQuestion(),
                LMChatDefaultTheme.kVerticalPaddingMedium,
                widget.pollSelectionTextBuilder?.call(
                      context,
                      _defPollSelection(),
                    ) ??
                    _defPollSelection(),
                const SizedBox(height: 8),
                _defPollOptionList(),
                //add and option button
                if (LMChatPollUtils.showAddOption(widget.pollData))
                  widget.addOptionButtonBuilder?.call(context,
                          _defAddOptionButton(context), _onAddOptionSubmit) ??
                      _defAddOptionButton(context),
                widget.subTextBuilder?.call(
                      context,
                      _defSubText(),
                    ) ??
                    _defSubText(),
                if (LMChatPollUtils.showSubmitButton(
                    widget.pollData, _isVoteEditing))
                  widget.submitButtonBuilder?.call(
                        _defSubmitButton(),
                      ) ??
                      _defSubmitButton(),
                if (LMChatPollUtils.showEditVote(
                    widget.pollData, _isVoteEditing))
                  widget.editButtonBuilder?.call(
                        _defEditButton(),
                      ) ??
                      _defEditButton(),
              ],
            ),
          );
        });
  }

  ListView _defPollOptionList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: pollData.poll?.length,
      itemBuilder: (context, index) {
        return widget.pollOptionBuilder?.call(
              context,
              _defPollOption(index),
              pollData.poll![index],
            ) ??
            _defPollOption(index);
      },
    );
  }

  LMChatText _defPollTypeText() {
    return LMChatText(
      pollData.pollTypeText ?? pollData.pollType?.name ?? '',
      style: LMChatTextStyle(
        textStyle: TextStyle(
          height: 1.33,
          fontSize: 14,
          color: theme.inActiveColor,
        ),
      ),
    );
  }

  LMChatText _defTimeLeftText() {
    return LMChatText(
      LMChatPollUtils.getTimeLeftInPoll(widget.pollData.expiryTime),
      style: LMChatTextStyle(
        borderRadius: 100,
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        textStyle: TextStyle(
          height: 1.33,
          fontSize: 14,
          color: theme.container,
        ),
      ),
    );
  }

  LMChatIcon _defPollIcon() {
    return LMChatIcon(
      type: LMChatIconType.svg,
      assetPath: kPollIcon,
      style: LMChatIconStyle(
        size: 32,
        backgroundColor: theme.primaryColor,
        boxPadding: const EdgeInsets.all(8),
        boxBorderRadius: 100,
      ),
    );
  }

  LMChatText _defVotingTypeText() {
    return LMChatText(
      widget.pollData.submitTypeText ?? '',
      style: _lmChatPollStyle.voteTypeTextStyle,
    );
  }

  LMChatText _defHeaderSeparator() {
    return LMChatText(
      '●',
      style: LMChatTextStyle(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        textStyle: TextStyle(
          fontSize: 6,
          color: theme.inActiveColor,
        ),
      ),
    );
  }

  LMChatText _defSubText() {
    return LMChatText(
      widget.pollData.pollAnswerText ?? '',
      onTap: widget.onAnswerTextTap,
      style: _lmChatPollStyle.pollAnswerStyle,
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
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          height: 1.33,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: theme.container,
                        ),
                      ),
                    ),
                    style: LMChatButtonStyle(
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
      style: _lmChatPollStyle.addPollOptionButtonStyle!,
    );
  }

  void _onAddOptionSubmit(String optionText) {
    widget.onAddOptionSubmit?.call(optionText);
    Navigator.of(context).pop();
    _addOptionController.clear();
  }

  LMChatText _defPollSelection() {
    return LMChatText(
        _getPollSelectionText(widget.pollData.multipleSelectState,
                widget.pollData.multipleSelectNo) ??
            '',
        style: _lmChatPollStyle.pollInfoStyle);
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
      pollData.answer,
      expandText: _lmChatPollStyle.pollTypeTextStyle ?? "See more",
      onTagTap: (value) {},
      style: _lmChatPollStyle.pollQuestionStyle,
    );
  }

  LMChatPollOption _defPollOption(int index) {
    return LMChatPollOption(
      style: widget.style?.pollOptionStyle ?? theme.pollStyle.pollOptionStyle,
      option: pollData.poll![index],
      isVoteEditing: _isVoteEditing,
      selectedOption: selectedOption,
      pollData: pollData,
      onOptionSelect: widget.onOptionSelect,
      onVoteClick: widget.onVoteClick,
    );
  }

  LMChatButton _defEditButton() {
    return LMChatButton(
      onTap: () {
        _isVoteEditing = true;
        widget.onEditVote?.call(widget.pollData);
      },
      text: LMChatText(
        'EDIT VOTE',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            height: 1.33,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor,
          ),
        ),
      ),
      style: _lmChatPollStyle.editPollButtonStyle,
    );
  }

  LMChatButton _defSubmitButton() {
    return LMChatButton(
        onTap: () {
          final selectedOptions = widget.pollData.poll
              ?.where((element) => selectedOption.contains(element.id))
              .toList();
          widget.onSubmit?.call(selectedOptions ?? []);
        },
        text: LMChatText(
          'SUBMIT VOTE',
          style: LMChatTextStyle(
            textStyle: TextStyle(
              height: 1.33,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: theme.primaryColor,
            ),
          ),
        ),
        style: _lmChatPollStyle.submitPollButtonStyle);
  }
}
