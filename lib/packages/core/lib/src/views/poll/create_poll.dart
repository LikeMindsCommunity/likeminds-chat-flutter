import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatCreatePoll extends StatefulWidget {
  const LMChatCreatePoll({
    super.key,
    // this.attachmentMeta,
    this.appBarBuilder,
    this.pollQuestionStyle,
    this.optionStyle,
    this.advancedButtonBuilder,
    this.postButtonBuilder,
    this.addOptionButtonBuilder,
  });

  // /// [LMAttachmentMetaViewData] to prefill the poll data
  // final LMChatAttachmentMetaViewData? attachmentMeta;

  /// [LMChatPostAppBarBuilder] Builder for app bar
  final LMChatAppBarBuilder? appBarBuilder;

  /// [LMChatTextFieldStyle] for poll question
  final LMChatTextFieldStyle? pollQuestionStyle;

  /// [LMChatTextFieldStyle] for poll options
  final LMChatTextFieldStyle? optionStyle;

  /// [LMChatButtonBuilder] Builder for advanced settings button
  final LMChatButtonBuilder? advancedButtonBuilder;

  /// [LMChatButtonBuilder] Builder for post button
  final LMChatButtonBuilder? postButtonBuilder;

  /// [LMChatButtonBuilder] Builder for add option button
  final LMChatButtonBuilder? addOptionButtonBuilder;

  @override
  State<LMChatCreatePoll> createState() => _LMChatCreatePollState();
}

class _LMChatCreatePollState extends State<LMChatCreatePoll> {
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

  void loadInitialData() {
    // if (widget.attachmentMeta != null) {
    //   LMAttachmentMetaViewData attachmentMeta = widget.attachmentMeta!;
    //   _questionController.text = attachmentMeta.pollQuestion ?? '';
    //   options = attachmentMeta.pollOptions ?? [];
    //   _expiryDateBuilder.value = attachmentMeta.expiryTime != null
    //       ? DateTime.fromMillisecondsSinceEpoch(attachmentMeta.expiryTime!)
    //       : null;
    //   _multiSelectStateBuilder.value =
    //       attachmentMeta.multiSelectState ?? LMChatPollMultiSelectState.exactly;
    //   _multiSelectNoBuilder.value = attachmentMeta.multiSelectNo ?? 1;
    //   _pollTypeBuilder.value =
    //       attachmentMeta.pollType == LMChatPollType.deferred;
    //   _isAnonymousBuilder.value = attachmentMeta.isAnonymous ?? false;
    //   _allowAddOptionBuilder.value = attachmentMeta.allowAddOption ?? false;
    // }
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.sizeOf(context);
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
          _defHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: theme.container,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LMChatText(
                          'Poll question',
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.primaryColor),
                          ),
                        ),
                        TextField(
                          controller: _questionController,
                          maxLines: 3,
                          minLines: 1,
                          style: TextStyle(
                            color: theme.onContainer,
                          ),
                          decoration: widget.pollQuestionStyle?.decoration ??
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
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: theme.container,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          child: LMChatText(
                            'Answer Options',
                            style: LMChatTextStyle(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: theme.primaryColor),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: _optionBuilder,
                            builder: (context, _, __) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    return OptionTile(
                                      index: index,
                                      isRemovable: options.length > 2,
                                      option: options[index],
                                      onDelete: () {
                                        if (options.length > 2) {
                                          options.removeAt(index);
                                          _optionBuilder.value =
                                              !_optionBuilder.value;
                                          _rebuildMultiSelectStateBuilder
                                                  .value =
                                              !_rebuildMultiSelectStateBuilder
                                                  .value;
                                          if (_multiSelectNoBuilder.value >
                                              options.length) {
                                            _multiSelectNoBuilder.value = 1;
                                          }
                                        }
                                      },
                                      onChanged: (value) {
                                        options[index] = value;
                                      },
                                    );
                                  });
                            }),
                        LMChatTile(
                          onTap: () {
                            if (options.length < 10) {
                              options.add('');
                              _optionBuilder.value = !_optionBuilder.value;
                              _rebuildMultiSelectStateBuilder.value =
                                  !_rebuildMultiSelectStateBuilder.value;
                              debugPrint('Add option');
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    color: theme.container,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LMChatText(
                          'Poll expires on',
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.primaryColor),
                          ),
                        ),
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
                                      return LMChatText(
                                        value == null
                                            ? 'DD-MM-YYYY hh:mm'
                                            : getFormattedDate(value),
                                        style: LMChatTextStyle(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: theme.inActiveColor,
                                          ),
                                        ),
                                      );
                                    })),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Advanced settings
                  ValueListenableBuilder(
                      valueListenable: _advancedBuilder,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: value
                                  ? Container(
                                      color: theme.container,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ValueListenableBuilder(
                                              valueListenable:
                                                  _allowAddOptionBuilder,
                                              builder: (context, value, child) {
                                                return SwitchListTile(
                                                  value: value,
                                                  onChanged: (value) {
                                                    _allowAddOptionBuilder
                                                        .value = value;
                                                  },
                                                  activeColor:
                                                      theme.primaryColor,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 18,
                                                  ),
                                                  title: LMChatText(
                                                    'Allow voters to add options',
                                                    style: LMChatTextStyle(
                                                      textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            theme.onContainer,
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
                                              valueListenable:
                                                  _isAnonymousBuilder,
                                              builder: (context, value, child) {
                                                return SwitchListTile(
                                                  value: value,
                                                  onChanged: (value) {
                                                    _isAnonymousBuilder.value =
                                                        value;
                                                  },
                                                  activeColor:
                                                      theme.primaryColor,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 18,
                                                  ),
                                                  title: LMChatText(
                                                    'Anonymous poll',
                                                    style: LMChatTextStyle(
                                                      textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            theme.onContainer,
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
                                                    _pollTypeBuilder.value =
                                                        value;
                                                  },
                                                  activeColor:
                                                      theme.primaryColor,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 18,
                                                  ),
                                                  title: LMChatText(
                                                    'Don\'t show live results',
                                                    style: LMChatTextStyle(
                                                      textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            theme.onContainer,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                LMChatText(
                                                  'User can vote for',
                                                  style: LMChatTextStyle(
                                                    textStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          theme.inActiveColor,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ValueListenableBuilder(
                                                        valueListenable:
                                                            _multiSelectStateBuilder,
                                                        builder: (context,
                                                            value, child) {
                                                          return DropdownButton<
                                                              LMChatPollMultiSelectState>(
                                                            value: value,
                                                            onChanged: (value) {
                                                              if (value !=
                                                                  null) {
                                                                _multiSelectStateBuilder
                                                                        .value =
                                                                    value;
                                                              }
                                                            },
                                                            dropdownColor:
                                                                theme.container,
                                                            iconEnabledColor:
                                                                theme
                                                                    .onContainer,
                                                            style: TextStyle(
                                                              color: theme
                                                                  .onContainer,
                                                            ),
                                                            items: [
                                                              DropdownMenuItem(
                                                                value:
                                                                    LMChatPollMultiSelectState
                                                                        .exactly,
                                                                child:
                                                                    LMChatText(
                                                                  LMChatPollMultiSelectState
                                                                      .exactly
                                                                      .name,
                                                                ),
                                                              ),
                                                              DropdownMenuItem(
                                                                value:
                                                                    LMChatPollMultiSelectState
                                                                        .atLeast,
                                                                child:
                                                                    LMChatText(
                                                                  LMChatPollMultiSelectState
                                                                      .atLeast
                                                                      .name,
                                                                ),
                                                              ),
                                                              DropdownMenuItem(
                                                                value:
                                                                    LMChatPollMultiSelectState
                                                                        .atMax,
                                                                child:
                                                                    LMChatText(
                                                                  LMChatPollMultiSelectState
                                                                      .atMax
                                                                      .name,
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
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: theme
                                                              .inActiveColor,
                                                        ),
                                                      ),
                                                    ),
                                                    ValueListenableBuilder(
                                                        valueListenable:
                                                            _rebuildMultiSelectStateBuilder,
                                                        builder:
                                                            (context, _, __) {
                                                          return ValueListenableBuilder(
                                                              valueListenable:
                                                                  _multiSelectNoBuilder,
                                                              builder: (context,
                                                                  value,
                                                                  child) {
                                                                return DropdownButton<
                                                                    int>(
                                                                  value: value,
                                                                  items: [
                                                                    // create dropdown items based on current options length min 1 and max options.length
                                                                    for (int i =
                                                                            1;
                                                                        i <=
                                                                            options.length;
                                                                        i++)
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            i,
                                                                        child:
                                                                            LMChatText(
                                                                          '$i ${i == 1 ? 'option' : 'options'}',
                                                                        ),
                                                                      ),
                                                                  ],
                                                                  dropdownColor:
                                                                      theme
                                                                          .container,
                                                                  iconEnabledColor:
                                                                      theme
                                                                          .onContainer,
                                                                  style:
                                                                      TextStyle(
                                                                    color: theme
                                                                        .onContainer,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value !=
                                                                        null) {
                                                                      _multiSelectNoBuilder
                                                                              .value =
                                                                          value;
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
                            widget.addOptionButtonBuilder
                                    ?.call(_defAdvancedButton(value)) ??
                                _defAdvancedButton(value),
                          ],
                        );
                      }),
                  _defPostButton(),
                ],
              ),
            ),
          ),
        ],
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
          LMChatButton(
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
          ),
          const Spacer(
            flex: 1,
          ),
          const LMChatText(
            'New Poll',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
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

  onPollSubmit() {
    if (validatePoll()) {
      // LMAttachmentMetaViewDataBuilder attachmentMetaViewDataBuilder =
      //     LMAttachmentMetaViewDataBuilder()
      //       ..pollQuestion(_questionController.text)
      //       ..expiryTime(_expiryDateBuilder.value?.millisecondsSinceEpoch)
      //       ..pollOptions(options)
      //       ..multiSelectState(_multiSelectStateBuilder.value)
      //       ..pollType(_pollTypeBuilder.value
      //           ? LMChatPollType.deferred
      //           : LMChatPollType.instant)
      //       ..multiSelectNo(_multiSelectNoBuilder.value)
      //       ..isAnonymous(_isAnonymousBuilder.value)
      //       ..allowAddOption(_allowAddOptionBuilder.value);

      debugPrint('Poll submitted');
      // LMChatComposeBloc.instance.add(LMChatComposeAddPollEvent(
      //   attachmentMetaViewData: attachmentMetaViewDataBuilder.build(),
      // ));
      Navigator.pop(context);
    }
  }
}

class OptionTile extends StatefulWidget {
  const OptionTile({
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

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
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
            decoration: widget.optionStyle?.decoration ??
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
