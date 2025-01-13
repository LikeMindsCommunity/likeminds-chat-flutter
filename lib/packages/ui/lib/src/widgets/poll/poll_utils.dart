part of './poll.dart';

/// {@template lm_chat_poll_utils}
/// Utility class for poll related operations.
/// {@endtemplate}
class LMChatPollUtils {
  /// Determines whether to show the edit vote button.
  static bool showEditVote(
      LMChatConversationViewData conversationData, bool isVoteEditing) {
    if (hasPollEnded(
        conversationData.expiryTime, conversationData.noPollExpiry)) {
      return false;
    }
    if (isVoteEditing) {
      return false;
    }
    if (isPollSubmitted(conversationData.poll ?? []) &&
        (conversationData.pollType == LMChatPollType.deferred ||
            (conversationData.allowVoteChange ?? false))) {
      return true;
    }
    return false;
  }

  /// Determines whether to show the add option button.
  static bool showAddOption(LMChatConversationViewData conversationData) {
    // return false if poll has ended.
    if (hasPollEnded(
        conversationData.expiryTime, conversationData.noPollExpiry)) {
      return false;
    }
    // if allowAddOption is true check if the poll is submitted or not
    if (conversationData.allowAddOption == true) {
      // if poll is not submitted return true
      if (!isPollSubmitted(conversationData.poll ?? [])) {
        return true;
      }
      // if poll is submitted and poll type is deferred return true
      if (conversationData.pollType == LMChatPollType.deferred) {
        return true;
      }
    }
    // return false if the above conditions are not met
    return false;
  }

  /// Determines whether to show the tick mark for a poll option.
  static bool showTick(
    LMChatConversationViewData conversationData,
    LMChatPollOptionViewData option,
    List<int> selectedOption,
    bool isVoteEditing,
  ) {
    if (isVoteEditing) {
      return selectedOption.contains(option.id);
    }
    if (isMultiChoicePoll(conversationData.multipleSelectNo,
            conversationData.multipleSelectState) &&
        (option.isSelected == true || selectedOption.contains(option.id))) {
      return true;
    } else {
      return false;
    }
  }

  /// Returns the vote count text based on the number of votes.
  static String voteText(int voteCount) {
    if (voteCount == 1) {
      return '1 vote';
    } else {
      return '$voteCount votes';
    }
  }

  /// Determines whether to show the submit button for the poll.
  static bool showSubmitButton(
      LMChatConversationViewData conversationData, bool isVoteEditing) {
    if (isVoteEditing) {
      return true;
    }
    if (isPollSubmitted(conversationData.poll ?? [])) {
      return false;
    }
    if ((conversationData.pollType != null &&
            isInstantPoll(conversationData.pollType!) &&
            isPollSubmitted(conversationData.poll!)) ||
        hasPollEnded(
            conversationData.expiryTime, conversationData.noPollExpiry)) {
      return false;
    } else if (!isMultiChoicePoll(conversationData.multipleSelectNo,
        conversationData.multipleSelectState)) {
      return false;
    } else {
      return true;
    }
  }

  /// Checks if the poll has been submitted.
  static bool isPollSubmitted(List<LMChatPollOptionViewData> poll) {
    return poll.any((element) => element.isSelected ?? false);
  }

  /// Checks if the poll has ended based on the expiry time.
  static bool hasPollEnded(int? expiryTime, [bool? noPollExpiry = false]) {
    // if noPollExpiry is true, the poll will never expire.
    if (noPollExpiry ?? false) {
      return false;
    }
    return expiryTime != null &&
        DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  /// Checks if the poll is an instant poll.
  static bool isInstantPoll(LMChatPollType? pollType) {
    return pollType != null && pollType == LMChatPollType.instant;
  }

  /// Checks if the poll is a multi-choice poll.
  static bool isMultiChoicePoll(int? pollMultiSelectNo,
      LMChatPollMultiSelectState? pollMultiSelectState) {
    if (pollMultiSelectNo == null || pollMultiSelectState == null) {
      return false;
    }
    if (pollMultiSelectState == LMChatPollMultiSelectState.exactly &&
        pollMultiSelectNo == 1) {
      return false;
    }
    return true;
  }

  /// Determines whether the option is selected by the user.
  static bool isSelectedByUser(
      LMChatPollOptionViewData? optionViewData, List<int> selectedOption) {
    if (optionViewData == null) {
      return false;
    }
    return selectedOption.contains(optionViewData.id);
  }

  /// Returns the vote count text based on the number of votes.
  static String defAddedByMember(
    LMChatUserViewData? userViewData,
  ) {
    return "Added by ${userViewData?.name ?? ""}";
  }

  /// Returns the time left in the poll.
  static String getTimeLeftInPoll(int? expiryTime) {
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
    if (difference.inDays > 1) {
      return "Ends in ${difference.inDays} days";
    } else if (difference.inDays > 0) {
      return "Ends in ${difference.inDays} day";
    } else if (difference.inHours > 0) {
      return "Ends in  ${difference.inHours} hours";
    } else if (difference.inMinutes > 0) {
      return "Ends in  ${difference.inMinutes} minutes";
    } else {
      return "Just Now";
    }
  }

  /// checks if vote text should be shown
  static bool showVoteText(
    LMChatConversationViewData conversationData,
  ) {
    return conversationData.toShowResults ?? false;
  }
}
