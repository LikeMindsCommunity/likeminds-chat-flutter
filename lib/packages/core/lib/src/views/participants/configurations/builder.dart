import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_participant_builder_delegate}
/// Delegate class for building the participant widget
/// {@endtemplate}
class LMChatParticipantBuilderDelegate {
  /// {@macro lm_chat_participant_builder_delegate}
  const LMChatParticipantBuilderDelegate();

  /// Builds the first page error indicator.
  Widget firstPageErrorIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the new page error indicator.
  Widget newPageErrorIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the first page progress indicator.
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the new page progress indicator.
  Widget newPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  /// Builds the no items found indicator.
  Widget noItemsFoundIndicatorBuilder(
    BuildContext context,
  ) {
    return const Center(
        child: LMChatText(
      'No search results found',
      style: LMChatTextStyle(
          textStyle: TextStyle(
        fontSize: 16,
      )),
    ));
  }

  /// Builds the no more items indicator.
  Widget noMoreItemsIndicatorBuilder(
    BuildContext context,
  ) {
    return const SizedBox();
  }

  /// Builds the app bar.
  PreferredSizeWidget appBarBuilder(
    BuildContext context,
    LMChatAppBar appBar,
  ) {
    return appBar;
  }

  /// Builds the list view.
  Widget userTileBuilder(
    BuildContext context,
    LMChatUserViewData user,
    LMChatUserTile userTile,
  ) {
    return userTile;
  }
}
