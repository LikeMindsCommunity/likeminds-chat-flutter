import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_member_right_util}
/// A utility class to check the rights of a member.
/// {@endtemplate}
class LMChatMemberRightUtil {
  /// check if user has read permissions
  static bool checkRespondRights(MemberStateResponse? memberStateResponse) {
    if (memberStateResponse == null ||
        memberStateResponse.memberRights == null) {
      return true;
    }
    MemberRight? respondRights = memberStateResponse.memberRights
        ?.firstWhere((element) => element.state == 3);
    if (respondRights == null) {
      return true;
    } else {
      return respondRights.isSelected;
    }
  }

  /// check if user has delete permissions
  /// [conversationViewData] is the conversation for which delete permissions are to be checked.
  static bool checkDeletePermissions(
      LMChatConversationViewData conversationViewData) {
    final MemberStateResponse? memberRight =
        LMChatLocalPreference.instance.getMemberRights();
    // check if user is cm state = 4 and owner state = 1
    if (memberRight != null &&
        memberRight.member?.state == 1  &&
        conversationViewData.deletedByUserId == null) {
      return true;
    } else {
      // check if conversation is created by user
      final currentUser = LMChatLocalPreference.instance.getUser();
      if (currentUser.id == conversationViewData.memberId &&
          conversationViewData.deletedByUserId == null) {
        return true;
      }
    }
    return false;
  }

  /// check if user has edit permissions
  /// [conversationViewData] is the conversation for which edit permissions are to be checked.
  static bool checkEditPermissions(
      LMChatConversationViewData conversationViewData) {
    final currentUser = LMChatLocalPreference.instance.getUser();
    return currentUser.id == conversationViewData.memberId;
  }
}
