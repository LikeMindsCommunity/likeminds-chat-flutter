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
    required LMChatPollOptionViewData option,
    this.onOptionSelect,
    this.onVoteClick,
    pollOptionStyle,
  })  : _option = option,
        _pollData = pollData,
        _selectedOption = selectedOption,
        _isVoteEditing = isVoteEditing,
        _optionStyle = pollOptionStyle ?? LMChatPollOptionStyle.basic();

  final bool _isVoteEditing;

  final LMChatThemeData _theme = LMChatTheme.theme;
  final List<int> _selectedOption;
  final LMChatConversationViewData _pollData;
  final LMChatPollOptionViewData _option;
  final LMChatPollOptionStyle _optionStyle;

  /// callback when the option is selected
  final void Function(LMChatPollOptionViewData)? onOptionSelect;

  /// callback when the vote is clicked
  final void Function(LMChatPollOptionViewData)? onVoteClick;

  /// Creates a copy of this [LMChatPollOption] but with the given fields replaced with the new values.
  LMChatPollOption copyWith({
    bool? isVoteEditing,
    List<int>? selectedOption,
    LMChatConversationViewData? pollData,
    LMChatPollOptionViewData? option,
    void Function(LMChatPollOptionViewData)? onOptionSelect,
    void Function(LMChatPollOptionViewData)? onVoteClick,
    LMChatPollOptionStyle? pollOptionStyle,
  }) {
    return LMChatPollOption(
      isVoteEditing: isVoteEditing ?? _isVoteEditing,
      selectedOption: selectedOption ?? _selectedOption,
      pollData: pollData ?? _pollData,
      option: option ?? _option,
      onOptionSelect: onOptionSelect ?? this.onOptionSelect,
      onVoteClick: onVoteClick ?? this.onVoteClick,
      pollOptionStyle: pollOptionStyle ?? _optionStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            onOptionSelect?.call(_option);
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
                      value: (_option.percentage ?? 0) / 100,
                      color: _option.isSelected ?? false
                          ? _optionStyle.pollOptionSelectedColor
                          : _optionStyle.pollOptionOtherColor,
                      backgroundColor: _theme.container,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                decoration: _optionStyle.pollOptionDecoration ??
                    BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: LMChatPollUtils.showTick(
                          _pollData,
                          _option,
                          _selectedOption,
                          _isVoteEditing,
                        )
                            ? _optionStyle.pollOptionSelectedBorderColor ??
                                _theme.primaryColor
                            : _theme.inActiveColor,
                      ),
                    ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LMChatText(_option.text,
                            style: _optionStyle.pollOptionTextStyle ??
                                const LMChatTextStyle(
                                  maxLines: 1,
                                  textStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    height: 1.25,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                        if (_pollData.allowAddOption ?? false)
                          LMChatText(
                              LMChatPollUtils.defAddedByMember(_option.member),
                              style: LMChatTextStyle(
                                maxLines: 1,
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.25,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: _theme.inActiveColor,
                                ),
                              )),
                      ],
                    ),
                    if (LMChatPollUtils.showTick(
                      _pollData,
                      _option,
                      _selectedOption,
                      _isVoteEditing,
                    ))
                      Padding(
                        padding: _pollData.allowAddOption ?? false
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
                              color: _optionStyle.pollOptionSelectedTickColor ??
                                  _theme.primaryColor,
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
            LMChatPollUtils.voteText(_option.noVotes ?? 0),
            onTap: () {
              onVoteClick?.call(_option);
            },
            style: _optionStyle.votesCountStyles ??
                LMChatTextStyle(
                  textStyle: TextStyle(
                    height: 1.33,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _theme.inActiveColor,
                  ),
                ),
          ),
        ),
        LMChatDefaultTheme.kVerticalPaddingMedium,
      ],
    );
  }
}
