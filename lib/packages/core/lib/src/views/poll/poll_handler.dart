import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/poll/poll_option_convertor.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> submitVote(
  BuildContext context,
  LMChatConversationViewData conversationData,
  List<LMChatPollOptionViewData> option,
  Map<String, bool> isVoteEditing,
  LMChatConversationViewData previousValue,
  ValueNotifier<bool> rebuildPostWidget,
) async {
  try {
    if (hasPollEnded(conversationData.expiryTime)) {
      toast(
        "Poll ended. Vote can not be submitted now.",
      );
      resetOptions(conversationData, previousValue);
      return;
    }
    if (isPollSubmitted(conversationData.poll!) &&
        isInstantPoll(conversationData.pollType!)) {
      resetOptions(conversationData, previousValue);
      return;
    } else {
      if (isMultiChoicePoll(conversationData.multipleSelectNo,
          conversationData.multipleSelectState)) {
        if (conversationData.multipleSelectState! ==
                LMChatPollMultiSelectState.exactly &&
            option.length != conversationData.multipleSelectNo) {
          toast(
            "Please select exactly ${conversationData.multipleSelectNo} poll",
          );
          // rebuildPostWidget.value = !rebuildPostWidget.value;
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
      bool isPollSubmittedBefore = isVoteEditing["value"] ?? false;
      isVoteEditing["value"] = false;
      rebuildPostWidget.value = !rebuildPostWidget.value;
      SubmitPollRequest request = (SubmitPollRequestBuilder()
            ..conversationId(conversationData.id)
            ..polls(option.map((e) => e.toPollOption()).toList()))
          .build();
      final response = await LMChatCore.client.submitPoll(request);
      if (!response.success) {
        for (int i = 0; i < option.length; i++) {
          int index = conversationData.poll!
              .indexWhere((element) => element.id == option[i]);
          if (index != -1) {
            // conversationData.poll![index].isSelected = false;
            // conversationData.poll![index].voteCount--;
            // conversationData.poll![index].percentage =
            //     (conversationData.poll![index].voteCount / totalVotes) * 100;
          }
        }

        conversationData = previousValue;
        resetOptions(conversationData, previousValue);
        toast(
          response.errorMessage ?? "Failed to submit vote",
        );
      } else {
        if (isPollSubmittedBefore) {
          // LMChatAnalyticsBloc.instance.add(LMChatFireAnalyticsEvent(
          //     eventName: LMChatAnalyticsKeys.pollVotesEdited,
          //     eventProperties: {
          //       LMChatStringConstants.pollId: conversationData.id,
          //       LMChatStringConstants.pollTitle: conversationData.pollOptions,
          //       LMChatStringConstants.pollNumberOfVotesSelected: poll.length,
          //     }));
        } else {
          // LMChatAnalyticsBloc.instance.add(LMChatFireAnalyticsEvent(
          //     eventName: LMChatAnalyticsKeys.pollVoted,
          //     eventProperties: {
          //       LMChatStringConstants.pollId: conversationData.id,
          //       LMChatStringConstants.pollTitle: conversationData.pollQuestion,
          //       LMChatStringConstants.pollNumberOfVotesSelected: poll.length,
          //       LMChatStringConstants.pollOptionVoted: poll.join(","),
          //     }));
        }
        toast(
          "Vote submitted successfully",
        );

        // PostDetailRequest postDetailRequest = (PostDetailRequestBuilder()
        //       ..postId(postId)
        //       ..pageSize(10)
        //       ..page(1))
        //     .build();
        // final postResponse =
        //     await LMChatCore.client.getPostDetails(postDetailRequest);

        // final Map<String, LMWidgetViewData> widgets = postResponse.widgets?.map(
        //         (key, value) => MapEntry(
        //             key, LMWidgetViewDataConvertor.fromWidgetModel(value))) ??
        //     {};

        // final Map<String, LMTopicViewData> topics =
        //     postResponse.topics?.map((key, value) => MapEntry(
        //             key,
        //             LMTopicViewDataConvertor.fromTopic(
        //               value,
        //               widgets: widgets,
        //             ))) ??
        //         {};

        // final Map<String, LMUserViewData> users =
        //     postResponse.users?.map((key, value) => MapEntry(
        //             key,
        //             LMUserViewDataConvertor.fromUser(
        //               value,
        //               widgets: widgets,
        //             ))) ??
        //         {};

        // final Map<String, LMPostViewData> repostedPosts =
        //     postResponse.repostedPosts?.map((key, value) => MapEntry(
        //             key,
        //             LMPostViewDataConvertor.fromPost(
        //               post: value,
        //               users: users,
        //               widgets: widgets,
        //               topics: topics,
        //               userTopics: postResponse.userTopics,
        //             ))) ??
        //         {};

        // final postViewData = LMPostViewDataConvertor.fromPost(
        //   post: postResponse.post!,
        //   users: users,
        //   widgets: widgets,
        //   repostedPosts: repostedPosts,
        //   topics: topics,
        //   userTopics: postResponse.userTopics,
        // );

        // LMChatPostBloc.instance.add(LMChatUpdatePostEvent(
        //   post: postViewData,
        //   actionType: LMChatPostActionType.pollSubmit,
        //   postId: postId,
        // ));
      }
    }
  } on Exception catch (e) {
    // int totalVotes = conversationData.poll?.fold(0,
    //         (previousValue, element) => previousValue! + element.voteCount) ??
    //     0;
    // for (int i = 0; i < poll.length; i++) {
    //   int index =
    //       conversationData.poll!.indexWhere((element) => element.id == poll[i]);
    //   if (index != -1) {
    //     conversationData.poll![index].isSelected = false;
    //     conversationData.poll![index].voteCount--;
    //     conversationData.poll![index].percentage =
    //         (conversationData.poll![index].voteCount / totalVotes) * 100;
    //   }
    // }

    // conversationData = previousValue;
    // resetOptions(conversationData, previousValue);
    toast(
      e.toString(),
    );
  }
}

void resetOptions(LMChatConversationViewData conversationData,
    LMChatConversationViewData previousValue) {
  conversationData = previousValue;
}

bool showTick(
    LMChatConversationViewData conversationData,
    LMChatPollOptionViewData option,
    List<String> selectedOption,
    bool isVoteEditing) {
  // if (isPollSubmitted(conversationData.poll!)) {
  //   return false;
  // }
  if (isVoteEditing) {
    return selectedOption.contains(option.id);
  }
  if ((isMultiChoicePoll(conversationData.multipleSelectNo,
                  conversationData.multipleSelectState) ==
              true ||
          isInstantPoll(conversationData.pollType!) == false) &&
      option.isSelected == true) {
    return true;
  } else {
    return false;
  }
}

bool showAddOptionButton(LMChatConversationViewData conversationData) {
  bool isAddOptionAllowedForInstantPoll =
      isInstantPoll(conversationData.pollType) &&
          !isPollSubmitted(conversationData.poll!);
  bool isAddOptionAllowedForDeferredPoll =
      !isInstantPoll(conversationData.pollType);

  if (conversationData.allowAddOption != null &&
      conversationData.allowAddOption! &&
      !hasPollEnded(conversationData.expiryTime) &&
      (isAddOptionAllowedForInstantPoll || isAddOptionAllowedForDeferredPoll)) {
    if (conversationData.poll!.length < 10) return true;
  }
  return false;
}

bool showSubmitButton(LMChatConversationViewData conversationData) {
  if (isPollSubmitted(conversationData.poll ?? [])) {
    return false;
  }
  if ((conversationData.pollType != null &&
          isInstantPoll(conversationData.pollType!) &&
          isPollSubmitted(conversationData.poll!)) ||
      hasPollEnded(conversationData.expiryTime)) {
    return false;
  } else if (!isMultiChoicePoll(conversationData.multipleSelectNo,
      conversationData.multipleSelectState)) {
    return false;
  } else
    return true;
}

Future<void> addOption(
  BuildContext context,
  LMChatConversationViewData conversationData,
  String option,
  LMChatUserViewData? currentUser,
  ValueNotifier<bool> rebuildPostWidget,
  LMChatWidgetSource source,
) async {
  if ((conversationData.poll?.length ?? 0) > 10) {
    toast(
      "You can add only 10 options",
    );
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
    conversationData.poll!.removeLast();
    conversationData.poll!.add(pollOptionViewData);
    toast(
      "Option added successfully",
    );
  }
}

bool isPollSubmitted(List<LMChatPollOptionViewData> poll) {
  return poll.any((element) => element.isSelected ?? false);
}

bool hasPollEnded(int? expiryTime) {
  return expiryTime != null &&
      DateTime.now().millisecondsSinceEpoch > expiryTime;
}

String getTimeLeftInPoll(int? expiryTime) {
  if (expiryTime == null) {
    return "";
  }
  DateTime expiryTimeInDateTime =
      DateTime.fromMillisecondsSinceEpoch(expiryTime);
  DateTime now = DateTime.now();
  Duration difference = expiryTimeInDateTime.difference(now);
  if (difference.isNegative) {
    return "Poll Ended";
  }
  if (difference.inDays > 0) {
    return "${difference.inDays}d left";
  } else if (difference.inHours > 0) {
    return "${difference.inHours}h left";
  } else if (difference.inMinutes > 0) {
    return "${difference.inMinutes}m left";
  } else {
    return "Just Now";
  }
}

String? getPollSelectionText(
    LMChatPollMultiSelectState? pollMultiSelectState, int? pollMultiSelectNo) {
  if (pollMultiSelectNo == null || pollMultiSelectState == null) {
    return null;
  }
  switch (pollMultiSelectState) {
    case LMChatPollMultiSelectState.exactly:
      if (pollMultiSelectNo == 1) {
        return null;
      } else {
        return "*Select exactly $pollMultiSelectNo poll";
      }
    case LMChatPollMultiSelectState.atMax:
      return "*Select at most $pollMultiSelectNo poll";
    case LMChatPollMultiSelectState.atLeast:
      return "*Select at least $pollMultiSelectNo poll";
    default:
      return null;
  }
}

bool isInstantPoll(LMChatPollType? pollType) {
  return pollType != null && pollType == LMChatPollType.instant;
}

bool isMultiChoicePoll(
    int? pollMultiSelectNo, LMChatPollMultiSelectState? pollMultiSelectState) {
  if (pollMultiSelectNo == null || pollMultiSelectState == null) {
    return false;
  }
  if (pollMultiSelectState == LMChatPollMultiSelectState.exactly &&
      pollMultiSelectNo == 1) {
    return false;
  }
  return true;
}

String getFormattedDateTime(int? expiryTime) {
  if (expiryTime == null) {
    return "";
  }
  DateTime expiryTimeInDateTime =
      DateTime.fromMillisecondsSinceEpoch(expiryTime);
  String formattedDateTime =
      DateFormat('d MMM y hh:mm a').format(expiryTimeInDateTime);
  return "Expires on $formattedDateTime";
}

void onVoteTextTap(BuildContext context,
    LMChatConversationViewData conversationData, LMChatWidgetSource source,
    {LMChatPollOptionViewData? option}) {
  if (conversationData.isAnonymous ?? false) {
    showDialog(
      context: context,
      builder: (context) => const SimpleDialog(
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
    );
  } else if (conversationData.toShowResults! ||
      hasPollEnded(conversationData.expiryTime)) {
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
