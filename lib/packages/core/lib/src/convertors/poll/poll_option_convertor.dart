import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// Extension to convert [PollOption] to [LMChatPollOptionViewData]
extension PollOptionViewDataConvertor on PollOption {
  /// Converts [PollOption] to [LMChatPollOptionViewData]
  LMChatPollOptionViewData toPollOptionViewData({
    Map<int, User>? userMeta,
  }) {
    LMChatPollOptionViewDataBuilder builder = LMChatPollOptionViewDataBuilder()
      ..id(id)
      ..text(text)
      ..isSelected(isSelected)
      ..percentage(percentage)
      ..noVotes(noVotes)
      ..member(member?.toUserViewData());
    if (userId != null && userMeta != null) {
      final user = userMeta[userId];
      if (user != null) {
        builder.member(user.toUserViewData());
      }
    }

    return builder.build();
  }
}

/// Extension to convert [LMChatPollOptionViewData] to [PollOption]
extension PollOptionConvertor on LMChatPollOptionViewData {
  /// Converts [LMChatPollOptionViewData] to [PollOption]
  PollOption toPollOption() {
    return PollOption(
      id: id,
      text: text,
      isSelected: isSelected,
      percentage: percentage,
      noVotes: noVotes,
      member: member?.toUser(),
    );
  }
}
