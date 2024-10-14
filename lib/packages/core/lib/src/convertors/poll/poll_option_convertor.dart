import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension PollOptionViewDataConvertor on PollOption {
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

extension PollOptionConvertor on LMChatPollOptionViewData {
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
