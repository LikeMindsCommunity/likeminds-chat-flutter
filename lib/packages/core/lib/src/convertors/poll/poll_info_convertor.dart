import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/poll/poll_converter.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension PollInfoConvertor on PollInfoData {
  LMChatPollInfoViewData toLMChatPollViewData() {
    final LMChatPollInfoViewDataBuilder builder =
        LMChatPollInfoViewDataBuilder()
          ..isAnonymous(isAnonymous)
          ..allowAddOption(allowAddOption)
          ..pollType(pollType)
          ..pollTypeText(pollTypeText)
          ..submitTypeText(submitTypeText)
          ..expiryTime(expiryTime)
          ..multipleSelectNum(multipleSelectNum)
          ..multipleSelectState(multipleSelectState)
          ..pollViewDataList(
              pollViewDataList?.map((e) => e.toLMChatPollViewData()).toList())
          ..pollAnswerText(pollAnswerText)
          ..isPollSubmitted(isPollSubmitted)
          ..toShowResult(toShowResult)
          ..conversationId(conversationId);

    return builder.build();
  }
}

extension PollInfoDataConvertor on LMChatPollInfoViewData {
  PollInfoData toPollInfoData() {
    return PollInfoData(
      isAnonymous: isAnonymous,
      allowAddOption: allowAddOption,
      pollType: pollType,
      pollTypeText: pollTypeText,
      submitTypeText: submitTypeText,
      expiryTime: expiryTime,
      multipleSelectNum: multipleSelectNum,
      multipleSelectState: multipleSelectState,
      pollViewDataList:
          pollViewDataList?.map((e) => e.toPoll()).toList(),
      pollAnswerText: pollAnswerText,
      isPollSubmitted: isPollSubmitted,
      toShowResult: toShowResult,
      conversationId: conversationId,
    );
  }
}
