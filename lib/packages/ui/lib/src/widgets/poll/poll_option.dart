import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_poll_option}
/// Poll option widget
/// responsible for rendering the poll option
/// {@endtemplate}
class LMChatPollOption extends StatelessWidget {
  /// {@macro lm_chat_poll_option}
  LMChatPollOption({
    super.key,
    bool isVoteEditing = false,
    required List<int> selectedOption,
    required LMChatConversationViewData pollData,
    required this.option,
    this.onOptionSelect,
    this.onVoteClick,
    this.style,
    this.userTextBuilder,
    this.optionTextBuilder,
    this.selectedIconBuilder,
    this.voteCountTextBuilder,
  })  : _pollData = pollData,
        _selectedOption = selectedOption,
        _isVoteEditing = isVoteEditing;

  final bool _isVoteEditing;
  final LMChatThemeData _theme = LMChatTheme.theme;
  final List<int> _selectedOption;
  final LMChatConversationViewData _pollData;

  /// poll option data
  final LMChatPollOptionViewData option;

  /// poll option style
  final LMChatPollOptionStyle? style;

  /// callback when the option is selected
  final void Function(LMChatPollOptionViewData)? onOptionSelect;

  /// callback when the vote is clicked
  final void Function(LMChatPollOptionViewData)? onVoteClick;

  /// Builder for user text
  final LMChatTextBuilder? userTextBuilder;

  /// Builder for option text
  final LMChatTextBuilder? optionTextBuilder;

  /// Builder for selected icon
  final LMChatIconBuilder? selectedIconBuilder;

  /// Builder for vote count text
  final LMChatTextBuilder? voteCountTextBuilder;

  /// Creates a copy of this [LMChatPollOption] but with the given fields replaced with the new values.
  LMChatPollOption copyWith({
    Key? key,
    bool? isVoteEditing,
    List<int>? selectedOption,
    LMChatConversationViewData? pollData,
    LMChatPollOptionViewData? option,
    LMChatPollOptionStyle? style,
    void Function(LMChatPollOptionViewData)? onOptionSelect,
    void Function(LMChatPollOptionViewData)? onVoteClick,
    LMChatTextBuilder? userTextBuilder,
    LMChatTextBuilder? optionTextBuilder,
    LMChatIconBuilder? selectedIconBuilder,
    LMChatTextBuilder? voteCountTextBuilder,
  }) {
    return LMChatPollOption(
      key: key ?? this.key,
      isVoteEditing: isVoteEditing ?? _isVoteEditing,
      selectedOption: selectedOption ?? _selectedOption,
      pollData: pollData ?? _pollData,
      option: option ?? this.option,
      style: style ?? this.style,
      onOptionSelect: onOptionSelect ?? this.onOptionSelect,
      onVoteClick: onVoteClick ?? this.onVoteClick,
      userTextBuilder: userTextBuilder ?? this.userTextBuilder,
      optionTextBuilder: optionTextBuilder ?? this.optionTextBuilder,
      selectedIconBuilder: selectedIconBuilder ?? this.selectedIconBuilder,
      voteCountTextBuilder: voteCountTextBuilder ?? this.voteCountTextBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            onOptionSelect?.call(option);
          },
          child: Stack(
            children: [
              if (_pollData.toShowResults != null &&
                  _pollData.toShowResults! &&
                  !_isVoteEditing)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: LinearProgressIndicator(
                      value: (option.percentage ?? 0) / 100,
                      color: option.isSelected ?? false
                          ? style?.pollOptionSelectedColor
                          : style?.pollOptionOtherColor,
                      backgroundColor: _theme.container,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                decoration: style?.pollOptionDecoration ??
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: LMChatPollUtils.showTick(
                          _pollData,
                          option,
                          _selectedOption,
                          _isVoteEditing,
                        )
                            ? style?.pollOptionSelectedBorderColor ??
                                _theme.primaryColor
                            : _theme.inActiveColor,
                      ),
                    ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          optionTextBuilder?.call(
                                  context, _defPollOptionText()) ??
                              _defPollOptionText(),
                          if (_pollData.allowAddOption ?? false)
                            userTextBuilder?.call(context, _defAddedByText()) ??
                                _defAddedByText(),
                        ],
                      ),
                    ),
                    if (LMChatPollUtils.showTick(
                        _pollData, option, _selectedOption, _isVoteEditing))
                      selectedIconBuilder?.call(context, _defSelectedIcon()) ??
                          _defSelectedIcon(),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (LMChatPollUtils.showVoteText(
          _pollData,
        ))
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: voteCountTextBuilder?.call(
                  context,
                  _defVoteText(),
                ) ??
                _defVoteText(),
          ),
        LMChatDefaultTheme.kVerticalPaddingMedium,
      ],
    );
  }

  LMChatText _defVoteText() {
    return LMChatText(
      LMChatPollUtils.voteText(option.noVotes ?? 0),
      onTap: () {
        onVoteClick?.call(option);
      },
      style: style?.votesCountStyles ??
          LMChatTextStyle(
            textStyle: TextStyle(
              height: 1.33,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _theme.inActiveColor,
            ),
          ),
    );
  }

  LMChatIcon _defSelectedIcon() {
    return LMChatIcon(
      type: LMChatIconType.svg,
      assetPath: kTickIcon,
      style: LMChatIconStyle(
        boxSize: 22,
        margin: const EdgeInsets.only(left: 4),
        boxBorderRadius: 100,
        boxPadding: const EdgeInsets.all(4),
        size: 20,
        color: _theme.container,
        backgroundColor:
            style?.pollOptionSelectedCheckColor ?? _theme.primaryColor,
      ),
    );
  }

  LMChatText _defPollOptionText() {
    return LMChatText(option.text,
        style: style?.pollOptionTextStyle ??
            const LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                height: 1.50,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ));
  }

  LMChatText _defAddedByText() {
    return LMChatText(LMChatPollUtils.defAddedByMember(option.member),
        style: LMChatTextStyle(
          maxLines: 1,
          textStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            height: 1.25,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _theme.inActiveColor,
          ),
        ));
  }
}
