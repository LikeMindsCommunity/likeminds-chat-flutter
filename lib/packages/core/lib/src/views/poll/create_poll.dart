import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:overlay_support/overlay_support.dart';

/// {@template lm_chat_create_poll_bottom_sheet}
/// Create Poll widget
/// responsible for creating the poll
/// {@endtemplate}
class LMChatCreatePollBottomSheet extends StatefulWidget {
  /// {@macro lm_chat_create_poll_bottom_sheet}
  const LMChatCreatePollBottomSheet({
    super.key,
    required this.chatroomId,
    this.repliedConversationId,
    this.pollQuestionStyle,
    this.pollQuestionBuilder,
    this.optionStyle,
    this.optionBuilder,
    this.advancedButtonBuilder,
    this.postButtonBuilder,
    this.addOptionButtonBuilder,
    this.scrollController,
    this.expiryDateTitleBuilder,
    this.expiryDateTextBuilder,
    this.titleTextBuilder,
    this.cancelButtonBuilder,
    this.questionTitleBuilder,
    this.answerTitleBuilder,
    this.headerBuilder,
  });

  /// [chatroomId] chatroomId for which poll is created
  final int chatroomId;

  /// [repliedConversationId] repliedConversationId for which poll is created
  final String? repliedConversationId;

  /// [LMChatTextFieldStyle] for poll question
  final LMChatTextFieldStyle? pollQuestionStyle;

  /// [pollQuestionBuilder] Builder for poll question
  final Widget Function(BuildContext, TextEditingController)?
      pollQuestionBuilder;

  /// [LMChatTextFieldStyle] for poll options
  final LMChatTextFieldStyle? optionStyle;

  /// [optionBuilder] Builder for poll options
  final Widget Function(BuildContext, LMChatOptionTile, int index)?
      optionBuilder;

  /// [LMChatButtonBuilder] Builder for advanced settings button
  final LMChatButtonBuilder? advancedButtonBuilder;

  /// [LMChatButtonBuilder] Builder for post button
  final LMChatButtonBuilder? postButtonBuilder;

  /// [LMChatButtonBuilder] Builder for add option button
  final Widget Function(BuildContext, LMChatTile)? addOptionButtonBuilder;

  /// [ScrollController] scrollController for the widget
  final ScrollController? scrollController;

  /// [LMChatTextBuilder] Builder for expiry date title
  final LMChatTextBuilder? expiryDateTitleBuilder;

  /// [LMChatTextBuilder] Builder for expiry date text
  final LMChatTextBuilder? expiryDateTextBuilder;

  /// [LMChatTextBuilder] Builder for title
  final LMChatTextBuilder? titleTextBuilder;

  /// [LMChatButton] Builder for cancel button
  final LMChatButtonBuilder? cancelButtonBuilder;

  /// [LMChatTextBuilder] Builder for Question title text
  final LMChatTextBuilder? questionTitleBuilder;

  /// [LMChatTextBuilder] Builder for Answer title text
  final LMChatTextBuilder? answerTitleBuilder;

  /// [LMChatContextWidgetBuilder] Builder for header
  final LMChatContextWidgetBuilder? headerBuilder;

  /// Creates a copy of this [LMChatCreatePollBottomSheet] but with the given fields replaced with the new values.
  LMChatCreatePollBottomSheet copyWith({
    Key? key,
    int? chatroomId,
    String? repliedConversationId,
    LMChatTextFieldStyle? pollQuestionStyle,
    Widget Function(BuildContext, TextEditingController)? pollQuestionBuilder,
    LMChatTextFieldStyle? optionStyle,
    Widget Function(BuildContext, LMChatOptionTile, int index)? optionBuilder,
    LMChatButtonBuilder? advancedButtonBuilder,
    LMChatButtonBuilder? postButtonBuilder,
    Widget Function(BuildContext, LMChatTile)? addOptionButtonBuilder,
    ScrollController? scrollController,
    LMChatTextBuilder? expiryDateTitleBuilder,
    LMChatTextBuilder? expiryDateTextBuilder,
    LMChatTextBuilder? titleTextBuilder,
    LMChatButtonBuilder? cancelButtonBuilder,
    LMChatTextBuilder? questionTitleBuilder,
    LMChatTextBuilder? answerTitleBuilder,
    LMChatContextWidgetBuilder? headerBuilder,
  }) {
    return LMChatCreatePollBottomSheet(
      key: key ?? this.key,
      chatroomId: chatroomId ?? this.chatroomId,
      repliedConversationId:
          repliedConversationId ?? this.repliedConversationId,
      pollQuestionStyle: pollQuestionStyle ?? this.pollQuestionStyle,
      pollQuestionBuilder: pollQuestionBuilder ?? this.pollQuestionBuilder,
      optionStyle: optionStyle ?? this.optionStyle,
      optionBuilder: optionBuilder ?? this.optionBuilder,
      advancedButtonBuilder:
          advancedButtonBuilder ?? this.advancedButtonBuilder,
      postButtonBuilder: postButtonBuilder ?? this.postButtonBuilder,
      addOptionButtonBuilder:
          addOptionButtonBuilder ?? this.addOptionButtonBuilder,
      scrollController: scrollController ?? this.scrollController,
      expiryDateTitleBuilder:
          expiryDateTitleBuilder ?? this.expiryDateTitleBuilder,
      expiryDateTextBuilder:
          expiryDateTextBuilder ?? this.expiryDateTextBuilder,
      titleTextBuilder: titleTextBuilder ?? this.titleTextBuilder,
      cancelButtonBuilder: cancelButtonBuilder ?? this.cancelButtonBuilder,
      questionTitleBuilder: questionTitleBuilder ?? this.questionTitleBuilder,
      answerTitleBuilder: answerTitleBuilder ?? this.answerTitleBuilder,
      headerBuilder: headerBuilder ?? this.headerBuilder,
    );
  }

  @override
  State<LMChatCreatePollBottomSheet> createState() =>
      _LMChatCreatePollBottomSheetState();
}

class _LMChatCreatePollBottomSheetState
    extends State<LMChatCreatePollBottomSheet> {
  late Size screenSize;
  LMChatThemeData theme = LMChatTheme.theme;
  LMChatUserViewData? user =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  List<String> options = ["", ""];
  final ValueNotifier<bool> _optionBuilder = ValueNotifier(false);
  String exactlyDialogKey = 'exactly';
  int exactlyValue = 1;
  final ValueNotifier<bool> _advancedBuilder = ValueNotifier(false);
  final TextEditingController _questionController = TextEditingController();
  final ValueNotifier<DateTime?> _expiryDateBuilder = ValueNotifier(null);
  final ValueNotifier<LMChatPollMultiSelectState> _multiSelectStateBuilder =
      ValueNotifier(LMChatPollMultiSelectState.exactly);
  final ValueNotifier<bool> _rebuildMultiSelectStateBuilder =
      ValueNotifier(false);
  final ValueNotifier<int> _multiSelectNoBuilder = ValueNotifier(1);
  final ValueNotifier<bool> _pollTypeBuilder = ValueNotifier(false);
  final ValueNotifier<bool> _isAnonymousBuilder = ValueNotifier(false);
  final ValueNotifier<bool> _allowAddOptionBuilder = ValueNotifier(false);

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    // unfocus text fields if any and request focus for date picker
    FocusScope.of(context).requestFocus(FocusNode());

    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now();
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: 'Start date',
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: theme.primaryColor,
                  onPrimary: theme.onPrimary,
                ),
                useMaterial3: false,
              ),
              child: child!);
        });

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.primaryColor,
                onPrimary: theme.onPrimary,
              ),
              useMaterial3: false,
            ),
            child: child!);
      },
    );
    if (selectedTime == null) return null;
    DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (selectedDateTime.isBefore(DateTime.now())) {
      showSnackBar('Expiry date cannot be in the past');
      return null;
    }

    return selectedDateTime;
  }

  String getFormattedDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

    return '$day-$month-${date.year} $hour:$minute';
  }

  void showSnackBar(String message) {
    toast(message);
  }

  bool checkForUniqueOptions() {
    Set<String> uniqueOptions = options.toSet();
    if (uniqueOptions.length != options.length) {
      showSnackBar('Options should be unique');
      return false;
    }
    return true;
  }

  bool validatePoll() {
    // check if question is empty
    if (_questionController.text.trim().isEmpty) {
      showSnackBar('Question cannot be empty');
      return false;
    }

    // trim options and check if options are empty
    for (int i = 0; i < options.length; i++) {
      options[i] = options[i].trim();
      if (options[i].isEmpty) {
        showSnackBar('Option ${i + 1} cannot be empty');
        return false;
      }
    }

    // check if options are unique
    if (!checkForUniqueOptions()) {
      return false;
    }

    // check if expiry date is empty and in future
    if (_expiryDateBuilder.value == null) {
      showSnackBar('Expiry date cannot be empty');
      return false;
    } else if (_expiryDateBuilder.value!.isBefore(DateTime.now())) {
      showSnackBar('Expiry date cannot be in the past');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.headerBuilder?.call(context) ?? _defHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  widget.pollQuestionBuilder
                          ?.call(context, _questionController) ??
                      _defPollQuestionContainer(),
                  const SizedBox(height: 16),
                  _defPollOptionList(),
                  const SizedBox(height: 16),
                  _defExpiryTime(context),
                  const SizedBox(height: 16),
                  // Advanced settings
                  _defAdvancedOptions(),
                  widget.postButtonBuilder?.call(_defPostButton()) ??
                      _defPostButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder<bool> _defAdvancedOptions() {
    return ValueListenableBuilder(
        valueListenable: _advancedBuilder,
        builder: (context, value, child) {
          return Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: value
                    ? Container(
                        color: theme.container,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: _allowAddOptionBuilder,
                                builder: (context, value, child) {
                                  return SwitchListTile(
                                    value: value,
                                    onChanged: (value) {
                                      _allowAddOptionBuilder.value = value;
                                    },
                                    activeColor: theme.primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    title: LMChatText(
                                      'Allow voters to add options',
                                      style: LMChatTextStyle(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: theme.onContainer,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            Divider(
                              color: theme.inActiveColor,
                              height: 0,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _isAnonymousBuilder,
                                builder: (context, value, child) {
                                  return SwitchListTile(
                                    value: value,
                                    onChanged: (value) {
                                      _isAnonymousBuilder.value = value;
                                    },
                                    activeColor: theme.primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    title: LMChatText(
                                      'Anonymous poll',
                                      style: LMChatTextStyle(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: theme.onContainer,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            Divider(
                              color: theme.inActiveColor,
                              height: 0,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _pollTypeBuilder,
                                builder: (context, value, child) {
                                  return SwitchListTile(
                                    value: value,
                                    onChanged: (value) {
                                      _pollTypeBuilder.value = value;
                                    },
                                    activeColor: theme.primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    title: LMChatText(
                                      'Don\'t show live results',
                                      style: LMChatTextStyle(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: theme.onContainer,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            Divider(
                              color: theme.inActiveColor,
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LMChatText(
                                    'User can vote for',
                                    style: LMChatTextStyle(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: theme.inActiveColor,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable:
                                              _multiSelectStateBuilder,
                                          builder: (context, value, child) {
                                            return DropdownButton<
                                                LMChatPollMultiSelectState>(
                                              value: value,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  _multiSelectStateBuilder
                                                      .value = value;
                                                }
                                              },
                                              dropdownColor: theme.container,
                                              iconEnabledColor:
                                                  theme.onContainer,
                                              style: TextStyle(
                                                color: theme.onContainer,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  value:
                                                      LMChatPollMultiSelectState
                                                          .exactly,
                                                  child: LMChatText(
                                                    LMChatPollMultiSelectState
                                                        .exactly.name,
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value:
                                                      LMChatPollMultiSelectState
                                                          .atLeast,
                                                  child: LMChatText(
                                                    LMChatPollMultiSelectState
                                                        .atLeast.name,
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value:
                                                      LMChatPollMultiSelectState
                                                          .atMax,
                                                  child: LMChatText(
                                                    LMChatPollMultiSelectState
                                                        .atMax.name,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      LMChatText(
                                        '=',
                                        style: LMChatTextStyle(
                                          textStyle: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                            color: theme.inActiveColor,
                                          ),
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable:
                                              _rebuildMultiSelectStateBuilder,
                                          builder: (context, _, __) {
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    _multiSelectNoBuilder,
                                                builder:
                                                    (context, value, child) {
                                                  return DropdownButton<int>(
                                                    value: value,
                                                    items: [
                                                      // create dropdown items based on current options length min 1 and max options.length
                                                      for (int i = 1;
                                                          i <= options.length;
                                                          i++)
                                                        DropdownMenuItem(
                                                          value: i,
                                                          child: LMChatText(
                                                            '$i ${i == 1 ? 'option' : 'options'}',
                                                          ),
                                                        ),
                                                    ],
                                                    dropdownColor:
                                                        theme.container,
                                                    iconEnabledColor:
                                                        theme.onContainer,
                                                    style: TextStyle(
                                                      color: theme.onContainer,
                                                    ),
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        _multiSelectNoBuilder
                                                            .value = value;
                                                      }
                                                    },
                                                  );
                                                });
                                          })
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              widget.advancedButtonBuilder?.call(_defAdvancedButton(value)) ??
                  _defAdvancedButton(value),
            ],
          );
        });
  }

  Container _defExpiryTime(BuildContext context) {
    return Container(
      color: theme.container,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.expiryDateTitleBuilder?.call(context, _defExpiryDateTitle()) ??
              _defExpiryDateTitle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showDateTimePicker(
                  context: context,
                  initialDate: _expiryDateBuilder.value,
                );
                if (selectedDate != null) {
                  _expiryDateBuilder.value = selectedDate;
                }
              },
              child: SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                      valueListenable: _expiryDateBuilder,
                      builder: (context, value, child) {
                        return widget.expiryDateTextBuilder
                                ?.call(context, _defExpiryDateText(value)) ??
                            _defExpiryDateText(value);
                      })),
            ),
          )
        ],
      ),
    );
  }

  LMChatText _defExpiryDateText(DateTime? value) {
    return LMChatText(
      value == null ? 'DD-MM-YYYY hh:mm' : getFormattedDate(value),
      style: LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.inActiveColor,
        ),
      ),
    );
  }

  LMChatText _defExpiryDateTitle() {
    return LMChatText(
      'Poll expires on',
      style: LMChatTextStyle(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor),
      ),
    );
  }

  Container _defPollOptionList() {
    return Container(
      color: theme.container,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: widget.answerTitleBuilder?.call(
                  context,
                  _defAnswerTitleText(),
                ) ??
                _defAnswerTitleText(),
          ),
          ValueListenableBuilder(
              valueListenable: _optionBuilder,
              builder: (context, _, __) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return widget.optionBuilder
                              ?.call(context, _defPollOption(index), index) ??
                          _defPollOption(index);
                    });
              }),
          widget.addOptionButtonBuilder?.call(context, _defAddOptionTile()) ??
              _defAddOptionTile(),
        ],
      ),
    );
  }

  LMChatText _defAnswerTitleText() {
    return LMChatText(
      'Answer Options',
      style: LMChatTextStyle(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor),
      ),
    );
  }

  LMChatTile _defAddOptionTile() {
    return LMChatTile(
      onTap: () {
        if (options.length < 10) {
          options.add('');
          _optionBuilder.value = !_optionBuilder.value;
          _rebuildMultiSelectStateBuilder.value =
              !_rebuildMultiSelectStateBuilder.value;
        } else {
          showSnackBar('You can add at max 10 options');
        }
      },
      style: LMChatTileStyle.basic().copyWith(
          padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      )),
      leading: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.add_circle_outline,
        style: LMChatIconStyle(
          size: 24,
          color: theme.primaryColor,
        ),
      ),
      title: LMChatText(
        'Add an option...',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  LMChatOptionTile _defPollOption(int index) {
    return LMChatOptionTile(
      index: index,
      isRemovable: options.length > 2,
      option: options[index],
      optionStyle: widget.optionStyle,
      onDelete: () {
        if (options.length > 2) {
          options.removeAt(index);
          _optionBuilder.value = !_optionBuilder.value;
          _rebuildMultiSelectStateBuilder.value =
              !_rebuildMultiSelectStateBuilder.value;
          if (_multiSelectNoBuilder.value > options.length) {
            _multiSelectNoBuilder.value = 1;
          }
        }
      },
      onChanged: (value) {
        options[index] = value;
      },
    );
  }

  Container _defPollQuestionContainer() {
    return Container(
      color: theme.container,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.questionTitleBuilder?.call(
                context,
                _defPollQuestionTitle(),
              ) ??
              _defPollQuestionTitle(),
          TextField(
            controller: _questionController,
            maxLines: 3,
            minLines: 1,
            style: TextStyle(
              color: theme.onContainer,
            ),
            decoration: widget.pollQuestionStyle?.inputDecoration ??
                InputDecoration(
                  hintText: 'Ask a question',
                  hintStyle: TextStyle(
                    color: theme.inActiveColor,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
          ),
        ],
      ),
    );
  }

  LMChatText _defPollQuestionTitle() {
    return LMChatText(
      'Poll question',
      style: LMChatTextStyle(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor),
      ),
    );
  }

  LMChatButton _defAdvancedButton(bool value) {
    return LMChatButton(
      onTap: () {
        _advancedBuilder.value = !_advancedBuilder.value;
      },
      text: LMChatText(
        'ADVANCED',
        style: LMChatTextStyle(
            textStyle: TextStyle(
          color: theme.onContainer,
        )),
      ),
      isActive: value,
      style: LMChatButtonStyle(
        placement: LMChatIconButtonPlacement.end,
        activeIcon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.expand_less,
          style: LMChatIconStyle(
            color: theme.onContainer,
          ),
        ),
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.expand_more,
          style: LMChatIconStyle(
            color: theme.onContainer,
          ),
        ),
      ),
    );
  }

  Widget _defHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      child: Row(
        children: [
          widget.cancelButtonBuilder?.call(
                _defCancelButton(),
              ) ??
              _defCancelButton(),
          const Spacer(
            flex: 1,
          ),
          widget.titleTextBuilder?.call(
                context,
                _defTitleText(),
              ) ??
              _defTitleText(),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  LMChatButton _defCancelButton() {
    return LMChatButton(
      onTap: () => Navigator.pop(context),
      text: LMChatText(
        "Cancel",
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  LMChatText _defTitleText() {
    return const LMChatText(
      'New Poll',
      style: LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  LMChatButton _defPostButton() {
    return LMChatButton(
      onTap: onPollSubmit,
      style: LMChatButtonStyle(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 56,
          vertical: 14,
        ),
        margin: const EdgeInsets.only(
          top: 48,
          bottom: 24,
        ),
        borderRadius: 24,
      ),
      text: const LMChatText(
        'POST',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void onPollSubmit() {
    if (validatePoll()) {
      // create poll
      String pollQuestion = _questionController.text.trim();
      LMChatConversationBloc.instance.add(
        LMChatPostPollConversationEvent(
          chatroomId: widget.chatroomId,
          text: pollQuestion,
          polls: options,
          pollType: _pollTypeBuilder.value ? 1 : 0,
          multipleSelectState: _multiSelectStateBuilder.value.index,
          multipleSelectNo: _multiSelectNoBuilder.value,
          isAnonymous: _isAnonymousBuilder.value,
          allowAddOption: _allowAddOptionBuilder.value,
          expiryTime: _expiryDateBuilder.value!.millisecondsSinceEpoch,
          temporaryId: DateTime.now().millisecondsSinceEpoch.toString(),
          repliedConversationId: widget.repliedConversationId,
        ),
      );

      Navigator.pop(context);
    }
  }
}

/// {@template lm_chat_option_tile}
/// Option tile for poll
/// responsible for creating the poll option
/// {@endtemplate}
class LMChatOptionTile extends StatefulWidget {
  /// {@macro lm_chat_option_tile}
  const LMChatOptionTile({
    super.key,
    required this.index,
    this.option,
    this.onDelete,
    this.onChanged,
    this.isRemovable = true,
    this.optionStyle,
  });
  final int index;
  final String? option;
  final VoidCallback? onDelete;
  final Function(String)? onChanged;
  final bool isRemovable;
  final LMChatTextFieldStyle? optionStyle;

  /// Creates a copy of this [LMChatOptionTile] but with the given fields replaced with the new values.
  /// {@macro lm_chat_option_tile}
  LMChatOptionTile copyWith({
    Key? key,
    int? index,
    String? option,
    VoidCallback? onDelete,
    Function(String)? onChanged,
    bool? isRemovable,
    LMChatTextFieldStyle? optionStyle,
  }) {
    return LMChatOptionTile(
      key: key ?? this.key,
      index: index ?? this.index,
      option: option ?? this.option,
      onDelete: onDelete ?? this.onDelete,
      onChanged: onChanged ?? this.onChanged,
      isRemovable: isRemovable ?? this.isRemovable,
      optionStyle: optionStyle ?? this.optionStyle,
    );
  }

  @override
  State<LMChatOptionTile> createState() => _LMChatOptionTileState();
}

class _LMChatOptionTileState extends State<LMChatOptionTile> {
  final TextEditingController _controller = TextEditingController();
  final LMChatThemeData theme = LMChatTheme.theme;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.option ?? '';
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.text = widget.option ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: TextStyle(
              color: theme.onContainer,
            ),
            decoration: widget.optionStyle?.inputDecoration ??
                InputDecoration(
                  hintText: 'Option',
                  hintStyle: TextStyle(
                    color: theme.inActiveColor,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffixIconColor: theme.inActiveColor,
                  suffixIcon: widget.isRemovable
                      ? IconButton(
                          isSelected: true,
                          icon: const Icon(Icons.close),
                          onPressed: widget.onDelete,
                        )
                      : null,
                ),
          ),
        ),
        Divider(
          color: theme.inActiveColor,
          height: 0,
        ),
      ],
    );
  }
}
