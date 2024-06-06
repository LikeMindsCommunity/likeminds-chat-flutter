import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';


extension PollConvertor on LMChatPollViewData {
  PollViewData toPoll() {
    return PollViewData(
      id: id,
      text: text,
      isSelected: isSelected,
      percentage: percentage,
      noVotes: noVotes,
      memberId: memberId,
      conversationId: conversationId,
      chatroomId: chatroomId,
      count: count,
    );
  }
}

extension PollViewDataConvertor on PollViewData {
  LMChatPollViewData toLMChatPollViewData() {
    LMChatPollViewDataBuilder builder = LMChatPollViewDataBuilder()
      ..id(id)
      ..text(text)
      ..isSelected(isSelected)
      ..percentage(percentage)
      ..noVotes(noVotes)
      ..memberId(memberId)
      ..conversationId(conversationId)
      ..chatroomId(chatroomId)
      ..count(count);

    return builder.build();
  }
}
