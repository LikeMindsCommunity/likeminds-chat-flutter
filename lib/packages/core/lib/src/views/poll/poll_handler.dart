import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/poll/poll_option_convertor.dart';
import 'package:overlay_support/overlay_support.dart';

/// Handles the poll submission logic
Future<void> submitVote(
  BuildContext context,
  LMChatConversationViewData conversationData,
  List<LMChatPollOptionViewData> option,
  Map<String, bool> isVoteEditing,
  LMChatConversationViewData previousValue,
  int chatroomId,
) async {
  try {
    if (option.isEmpty) {
      toast(
        "Please select an option",
      );
      return;
    }
    if (LMChatPollUtils.hasPollEnded(
        conversationData.expiryTime, conversationData.noPollExpiry)) {
      toast(
        "Poll ended. Vote can not be submitted now.",
      );

      return;
    }
    if (LMChatPollUtils.isPollSubmitted(conversationData.poll!) &&
        !(conversationData.allowVoteChange ?? false)) {
      return;
    } else {
      if (LMChatPollUtils.isMultiChoicePoll(conversationData.multipleSelectNo,
          conversationData.multipleSelectState)) {
        if (conversationData.multipleSelectState! ==
                LMChatPollMultiSelectState.exactly &&
            option.length != conversationData.multipleSelectNo) {
          toast(
            "Please select exactly ${conversationData.multipleSelectNo} poll",
          );
          return;
        } else if (conversationData.multipleSelectState! ==
                LMChatPollMultiSelectState.atLeast &&
            option.length < conversationData.multipleSelectNo!) {
          toast(
            "Please select at least ${conversationData.multipleSelectNo} poll",
          );
          return;
        } else if (conversationData.multipleSelectState! ==
                LMChatPollMultiSelectState.atMax &&
            option.length > conversationData.multipleSelectNo!) {
          toast(
            "Please select at most ${conversationData.multipleSelectNo} poll",
          );
          return;
        }
      }
      SubmitPollRequest request = (SubmitPollRequestBuilder()
            ..conversationId(conversationData.id)
            ..polls(option.map((e) => e.toPollOption()).toList()))
          .build();
      final response = await LMChatCore.client.submitPoll(request);
      if (!response.success) {
        toast(
          response.errorMessage ?? "Failed to submit vote",
        );
      } else {
        LMChatConversationBloc.instance.add(
          LMChatUpdateConversationsEvent(
            conversationId: conversationData.id,
            chatroomId: chatroomId,
            shouldUpdate: true,
          ),
        );
        toast(
          "Vote submitted successfully",
        );
      }
    }
  } on Exception catch (e) {
    toast(
      e.toString(),
    );
  }
}

/// Handles the poll option addition logic
Future<void> addOption(
  BuildContext context,
  LMChatConversationViewData conversationData,
  String option,
  LMChatUserViewData? currentUser,
  ValueNotifier<bool> rebuildChatWidget,
  LMChatWidgetSource source,
) async {
  String optionText = option.trim();
  // check if the answer is empty
  if (optionText.isEmpty) {
    toast(
      "Option can not be empty",
    );
    return;
  }
  // check if the option already exists
  if (conversationData.poll!.any((element) => element.text == optionText)) {
    toast('Options should be unique');
    return;
  }

  AddPollOptionRequest request = (AddPollOptionRequestBuilder()
        ..conversationId(conversationData.id)
        ..poll(option))
      .build();

  final response = await LMChatCore.client.addPollOption(request);
  if (response.success) {
    final LMChatPollOptionViewData pollOptionViewData =
        response.data!.poll!.toPollOptionViewData();
    conversationData.poll!.add(pollOptionViewData);
    toast(
      "Option added successfully",
    );
    rebuildChatWidget.value = !rebuildChatWidget.value;
  }
}

/// Handles the poll vote text tap logic
void onVoteTextTap(BuildContext context,
    LMChatConversationViewData conversationData, LMChatWidgetSource source,
    {LMChatPollOptionViewData? option}) {
  if (conversationData.isAnonymous ?? false) {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          useMaterial3: false,
        ),
        child: const SimpleDialog(
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 8,
          ),
          children: [
            LMChatText(
              'This being an anonymous poll, the names of the voters can not be disclosed.',
              style: LMChatTextStyle(
                maxLines: 3,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  } else if (conversationData.toShowResults! ||
      LMChatPollUtils.hasPollEnded(
          conversationData.expiryTime, conversationData.noPollExpiry)) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LMChatPollResultScreen(
          conversationId: conversationData.id,
          pollTitle: conversationData.answer,
          pollOptions: conversationData.poll ?? [],
          selectedOptionId: option?.id,
        ),
      ),
    );
  } else {
    toast(
      "Results will be shown after the poll ends",
    );
  }
}
