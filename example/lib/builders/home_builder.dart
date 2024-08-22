import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/utils/timer_service.dart';

class CustomHomeBuilder extends LMChatHomeBuilderDelegate {
  /// Builds a home feed chatroom tile
  ///
  @override
  Widget homeFeedTileBuilder(
    BuildContext context,
    chatroom,
    tile,
  ) {
    return tile.copyWith(
      onTap: () {
        //start timer
        startTimer();
        tile.onTap?.call();
      },
    );
  }
}
