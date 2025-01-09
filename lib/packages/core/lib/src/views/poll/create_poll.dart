import 'dart:async';

import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:overlay_support/overlay_support.dart';

/// {@template lm_chat_create_poll_bottom_sheet}
/// Create Poll widget
/// responsible for creating the poll
/// {@endtemplate}
class LMChatCreatePollScreen extends StatefulWidget {
  /// {@macro lm_chat_create_poll_bottom_sheet}
  const LMChatCreatePollScreen({
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
  final LMChatTextBuilder? postButtonBuilder;

  /// [LMChatButtonBuilder] Builder for add option button
  final Widget Function(BuildContext, LMChatTile)? addOptionButtonBuilder;

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

  /// Creates a copy of this [LMChatCreatePollScreen] but with the given fields replaced with the new values.
  LMChatCreatePollScreen copyWith({
    Key? key,
    int? chatroomId,
    String? repliedConversationId,
    LMChatTextFieldStyle? pollQuestionStyle,
    Widget Function(BuildContext, TextEditingController)? pollQuestionBuilder,
    LMChatTextFieldStyle? optionStyle,
    Widget Function(BuildContext, LMChatOptionTile, int index)? optionBuilder,
    LMChatButtonBuilder? advancedButtonBuilder,
    LMChatTextBuilder? postButtonBuilder,
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
    return LMChatCreatePollScreen(
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
  State<LMChatCreatePollScreen> createState() => _LMChatCreatePollScreenState();
}

class _LMChatCreatePollScreenState extends State<LMChatCreatePollScreen> {
  late Size screenSize;
  LMChatThemeData theme = LMChatTheme.theme;
  LMChatUserViewData? user =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  List<String> options = ["", ""];
  final ValueNotifier<bool> _optionBuilder = ValueNotifier(false);
  String exactlyDialogKey = 'exactly';
  int exactlyValue = 1;
  final TextEditingController _questionController = TextEditingController();
  final ValueNotifier<DateTime?> _expiryDateBuilder = ValueNotifier(null);
  final ValueNotifier<LMChatPollMultiSelectState> _multiSelectStateBuilder =
      ValueNotifier(LMChatPollMultiSelectState.exactly);
  final ValueNotifier<bool> _rebuildMultiSelectStateBuilder =
      ValueNotifier(false);
  final ValueNotifier<int> _multiSelectNoBuilder = ValueNotifier(1);
  final ValueNotifier<bool> _showResultsWithoutVoteBuilder =
      ValueNotifier(false);
  final ValueNotifier<bool> _hideResultsUntilPollEndBuilder =
      ValueNotifier(false);
  final ValueNotifier<bool> _isAnonymousBuilder = ValueNotifier(false);
  final ValueNotifier<bool> _allowAddOptionBuilder = ValueNotifier(false);
  final ValueNotifier<bool> _allowVoteChangeBuilder = ValueNotifier(false);
  final ValueNotifier<bool> _rebuildAdvancedOptionsBuilder =
      ValueNotifier(false);
  final StreamController<bool> _isValidatedController =
      StreamController<bool>.broadcast();

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

  bool checkForUniqueOptions(bool showError) {
    Set<String> uniqueOptions = options.toSet();
    if (uniqueOptions.length != options.length) {
      if (showError) showSnackBar('Options should be unique');
      return false;
    }
    return true;
  }

  bool validatePoll({bool showError = true}) {
    // check if question is empty
    if (_questionController.text.trim().isEmpty) {
      if (showError) showSnackBar('Question cannot be empty');
      return false;
    }

    // trim options and check if options are empty
    for (int i = 0; i < options.length; i++) {
      options[i] = options[i].trim();
      if (options[i].isEmpty) {
        if (showError) showSnackBar('Option ${i + 1} cannot be empty');
        return false;
      }
    }

    // check if options are unique
    if (!checkForUniqueOptions(showError)) {
      return false;
    }

    // check if expiry date is empty only when poll type is deferred = {showResultsWithoutVoting == false && hideResultUtilPollEnds == true }
    // in other cases expiry date can be empty and poll expiry will be set to infinite by `no_poll_expiry : true` flag
    // if expiry date is set then it should be in future
    if (_showResultsWithoutVoteBuilder.value == false &&
        _hideResultsUntilPollEndBuilder.value == true &&
        _expiryDateBuilder.value == null) {
      if (showError) showSnackBar('Expiry date cannot be empty');
      return false;
    }

    // check if expiry date is in past
    if (_expiryDateBuilder.value != null &&
        _expiryDateBuilder.value!.isBefore(DateTime.now())) {
      if (showError) showSnackBar('Expiry date cannot be in the past');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.container,
      appBar: LMChatAppBar(
        title: widget.titleTextBuilder?.call(
              context,
              _defTitleText(),
            ) ??
            _defTitleText(),
        trailing: [
          StreamBuilder(
              stream: _isValidatedController.stream,
              builder: (context, snapshot) {
                final bool isValidated = snapshot.data ?? false;
                return widget.postButtonBuilder
                        ?.call(context, _defPostButton(isValidated)) ??
                    _defPostButton(isValidated);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _defUserTile(),
            widget.pollQuestionBuilder?.call(context, _questionController) ??
                _defPollQuestionContainer(),
            const SizedBox(height: 16),
            _defPollOptionList(),
            const SizedBox(height: 16),
            // Advanced settings
            _defAdvancedOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _defAdvancedOptions(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _rebuildAdvancedOptionsBuilder,
        builder: (context, _, __) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                    valueListenable: _showResultsWithoutVoteBuilder,
                    builder: (context, value, child) {
                      return _defShowResultsTile(value);
                    }),
                // if show results without voting is false only then show poll type switch
                if (_showResultsWithoutVoteBuilder.value == false)
                  ValueListenableBuilder(
                      valueListenable: _hideResultsUntilPollEndBuilder,
                      builder: (context, value, child) {
                        return _defHideResultsTile(value);
                      }),
                ValueListenableBuilder(
                    valueListenable: _allowAddOptionBuilder,
                    builder: (context, value, child) {
                      return _defAllowVotesTile(value);
                    }),
                if (_hideResultsUntilPollEndBuilder.value == false)
                  ValueListenableBuilder(
                      valueListenable: _allowVoteChangeBuilder,
                      builder: (context, value, child) {
                        return _defAllowVoteChange(value);
                      }),
                ValueListenableBuilder(
                    valueListenable: _isAnonymousBuilder,
                    builder: (context, value, child) {
                      return _defAnonymousTile(value);
                    }),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LMChatText(
                        'Allow users to select:',
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: theme.inActiveColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: _multiSelectStateBuilder,
                              builder: (context, value, child) {
                                return DropdownButtonFormField<
                                    LMChatPollMultiSelectState>(
                                  value: value,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _multiSelectStateBuilder.value = value;
                                    }
                                  },
                                  dropdownColor: theme.container,
                                  iconEnabledColor: theme.onContainer,
                                  style: TextStyle(
                                    color: theme.onContainer,
                                  ),
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                        minWidth: 40.w, maxWidth: 40.w),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: LMChatPollMultiSelectState.exactly,
                                      child: LMChatText(
                                        LMChatPollMultiSelectState.exactly.name,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: LMChatPollMultiSelectState.atLeast,
                                      child: LMChatText(
                                        LMChatPollMultiSelectState.atLeast.name,
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: LMChatPollMultiSelectState.atMax,
                                      child: LMChatText(
                                        LMChatPollMultiSelectState.atMax.name,
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
                              valueListenable: _rebuildMultiSelectStateBuilder,
                              builder: (context, _, __) {
                                return ValueListenableBuilder(
                                    valueListenable: _multiSelectNoBuilder,
                                    builder: (context, value, child) {
                                      return DropdownButtonFormField<int>(
                                        value: value,
                                        decoration: InputDecoration(
                                          constraints: BoxConstraints(
                                              minWidth: 40.w, maxWidth: 40.w),
                                        ),
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
                                        dropdownColor: theme.container,
                                        iconEnabledColor: theme.onContainer,
                                        style: TextStyle(
                                          color: theme.onContainer,
                                        ),
                                        onChanged: (value) {
                                          if (value != null) {
                                            _multiSelectNoBuilder.value = value;
                                          }
                                        },
                                      );
                                    });
                              })
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _defExpiryTime(context),
              ],
            ),
          );
        });
  }

  LMChatUserTile _defUserTile() {
    return LMChatUserTile(
      userViewData: LMChatLocalPreference.instance.getUser().toUserViewData(),
    );
  }

  SwitchListTile _defShowResultsTile(bool value) {
    return SwitchListTile(
      value: value,
      onChanged: (value) {
        _showResultsWithoutVoteBuilder.value = value;
        if (value == true) {
          _hideResultsUntilPollEndBuilder.value = false;
        }
        _rebuildAdvancedOptionsBuilder.value =
            !_rebuildAdvancedOptionsBuilder.value;
        _isValidatedController.add(validatePoll(showError: false));
      },
      activeColor: theme.primaryColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      title: LMChatText(
        'Show results without voting',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.inActiveColor,
          ),
        ),
      ),
    );
  }

  SwitchListTile _defHideResultsTile(bool value) {
    return SwitchListTile(
      value: value,
      onChanged: (value) {
        _hideResultsUntilPollEndBuilder.value = value;
        _rebuildAdvancedOptionsBuilder.value =
            !_rebuildAdvancedOptionsBuilder.value;
        _isValidatedController.add(validatePoll(showError: false));
      },
      activeColor: theme.primaryColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      title: LMChatText(
        'Hide results until poll ends',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.inActiveColor,
          ),
        ),
      ),
    );
  }

  SwitchListTile _defAnonymousTile(bool value) {
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
            color: theme.inActiveColor,
          ),
        ),
      ),
    );
  }

  SwitchListTile _defAllowVoteChange(bool value) {
    return SwitchListTile(
      value: value,
      onChanged: (value) {
        _allowVoteChangeBuilder.value = value;
      },
      activeColor: theme.primaryColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      title: LMChatText(
        'Allow Users to change their vote',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.inActiveColor,
          ),
        ),
      ),
    );
  }

  SwitchListTile _defAllowVotesTile(bool value) {
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
            color: theme.inActiveColor,
          ),
        ),
      ),
    );
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
                _isValidatedController.add(validatePoll(showError: false));
              },
              child: Row(
                children: [
                  LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: Icons.calendar_today,
                    style: LMChatIconStyle(
                        size: 15,
                        color: theme.primaryColor,
                        margin: const EdgeInsets.only(right: 8)),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _expiryDateBuilder,
                      builder: (context, value, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.expiryDateTextBuilder?.call(
                                    context, _defExpiryDateText(value)) ??
                                _defExpiryDateText(value),
                            LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.mode_edit_outline_outlined,
                              style: LMChatIconStyle(
                                size: 20,
                                color: theme.inActiveColor,
                                margin: const EdgeInsets.only(right: 8),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
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
          color: value == null ? theme.primaryColor : theme.onContainer,
        ),
      ),
    );
  }

  LMChatText _defExpiryDateTitle() {
    String labelText = 'Set expiration date and time';
    return LMChatText(
      _hideResultsUntilPollEndBuilder.value ? '$labelText*' : labelText,
      style: LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _defPollOptionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: widget.answerTitleBuilder?.call(
                context,
                _defAnswerTitleText(),
              ) ??
              _defAnswerTitleText(),
        ),
        ValueListenableBuilder(
            valueListenable: _optionBuilder,
            builder: (context, _, __) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return widget.optionBuilder
                              ?.call(context, _defPollOption(index), index) ??
                          _defPollOption(index);
                    }),
              );
            }),
        widget.addOptionButtonBuilder?.call(context, _defAddOptionTile()) ??
            _defAddOptionTile(),
      ],
    );
  }

  LMChatText _defAnswerTitleText() {
    return LMChatText(
      'Options*',
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
        _isValidatedController.add(validatePoll(showError: false));
      },
      style: LMChatTileStyle.basic().copyWith(
          padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      )),
      leading: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.add,
        style: LMChatIconStyle(
          size: 24,
          color: theme.primaryColor,
        ),
      ),
      title: LMChatText(
        'Add option',
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
          _isValidatedController.add(validatePoll(showError: false));
        }
      },
      onChanged: (value) {
        options[index] = value;
        _isValidatedController.add(validatePoll(showError: false));
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
            minLines: 3,
            maxLength: 250,
            buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) {
              return LMChatText(
                '$currentLength/$maxLength character limit',
                style: LMChatTextStyle(
                  padding: EdgeInsets.zero,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: theme.inActiveColor,
                  ),
                ),
              );
            },
            style: TextStyle(
              color: theme.onContainer,
            ),
            onChanged: (value) {
              _isValidatedController.add(validatePoll(showError: false));
            },
            decoration: widget.pollQuestionStyle?.inputDecoration ??
                InputDecoration(
                  fillColor: const Color.fromRGBO(242, 244, 247, 1),
                  filled: true,
                  hintText: 'Ask a question',
                  hintStyle: TextStyle(
                    color: theme.inActiveColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  LMChatText _defPollQuestionTitle() {
    return LMChatText(
      'Question*',
      style: LMChatTextStyle(
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.primaryColor),
        padding: const EdgeInsets.only(bottom: 8),
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

  LMChatText _defPostButton(bool isValidated) {
    return LMChatText(
      "DONE",
      onTap: isValidated ? onPollSubmit : null,
      style: LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isValidated ? theme.primaryColor : theme.inActiveColor,
        ),
      ),
    );
  }

  int _getPollType() {
    /// instant poll - 0 : {show results without voting == false && hideResultUtilPollEnds == false}
    /// deferred poll - 1 : {show results without voting == false && hideResultUtilPollEnds == true}
    /// open poll - 2 : {show results without voting == true}
    if (_showResultsWithoutVoteBuilder.value) {
      return 2;
    } else if (_hideResultsUntilPollEndBuilder.value) {
      return 1;
    } else {
      return 0;
    }
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
          pollType: _getPollType(),
          multipleSelectState: _multiSelectStateBuilder.value.index,
          multipleSelectNo: _multiSelectNoBuilder.value,
          isAnonymous: _isAnonymousBuilder.value,
          allowAddOption: _allowAddOptionBuilder.value,
          expiryTime: _expiryDateBuilder.value?.millisecondsSinceEpoch,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: theme.onContainer,
        ),
        decoration: widget.optionStyle?.inputDecoration ??
            InputDecoration(
              fillColor: const Color.fromRGBO(242, 244, 247, 1),
              filled: true,
              hintText: 'Option ${widget.index + 1}',
              hintStyle: TextStyle(
                color: theme.inActiveColor,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
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
    );
  }
}
