import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/poll/poll_option_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension PollConvertor on LMChatPollViewData {
  Poll toPoll() {
    return Poll(
      isAnonymous: isAnonymous,
      allowAddOption: allowAddOption,
      pollType: pollType,
      pollTypeText: pollTypeText,
      submitTypeText: submitTypeText,
      expiryTime: expiryTime,
      multipleSelectNum: multipleSelectNum,
      multipleSelectState: multipleSelectState,
      pollOptions: pollOptions?.map((e) => e.toPollOption()).toList(),
      pollAnswerText: pollAnswerText,
      isPollSubmitted: isPollSubmitted,
      toShowResult: toShowResult,
      conversationId: conversationId,
    );
  }
}

extension PollViewDataConvertor on Poll {
  LMChatPollViewData toLMChatPollViewData() {
    LMChatPollViewDataBuilder builder = LMChatPollViewDataBuilder()
      ..isAnonymous(isAnonymous)
      ..allowAddOption(allowAddOption)
      ..pollType(pollType)
      ..pollTypeText(pollTypeText)
      ..submitTypeText(submitTypeText)
      ..expiryTime(expiryTime)
      ..multipleSelectNum(multipleSelectNum)
      ..multipleSelectState(multipleSelectState)
      ..pollOptions(pollOptions?.map((e) => e.toPollOptionViewData()).toList())
      ..pollAnswerText(pollAnswerText)
      ..isPollSubmitted(isPollSubmitted)
      ..toShowResult(toShowResult)
      ..conversationId(conversationId);

    return builder.build();
  }
}
