import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

abstract class ILMPreferenceService {
  void storeUserData(User user);
  User? getUser();
  void clearUserData();
  void storeMemberRights(MemberStateResponse memberState);
  MemberStateResponse? getMemberRights();
  bool fetchMemberRight(int id);
  void clearMemberRights();
  void storeCommunityData(Community community);
  Community? getCommunity();
  void clearCommunityData();
  void clearLocalPrefs();
}

class LMChatPreferences extends ILMPreferenceService {
  // Singleton instance of LMChatPreference class
  static LMChatPreferences? _instance;
  static LMChatPreferences get instance => _instance ??= LMChatPreferences._();

  LMChatPreferences._();

  get getCurrentUser => getUser();

  @override
  Future<void> storeUserData(User user) async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInUser();
    await LMChatCore.instance.lmChatClient.insertOrUpdateLoggedInUser(user);
  }

  @override
  User? getUser() {
    return LMChatCore.instance.lmChatClient.getLoggedInUser().data;
  }

  @override
  Future<void> clearUserData() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInUser();
  }

  @override
  Future<void> storeMemberRights(MemberStateResponse memberState) async {
    await LMChatCore.instance.lmChatClient
        .insertOrUpdateLoggedInMemberState(memberState);
  }

  @override
  MemberStateResponse? getMemberRights() {
    return LMChatCore.instance.lmChatClient.getLoggedInMemberState().data;
  }

  @override
  bool fetchMemberRight(int id) {
    final memberStateResponse = getMemberRights();
    if (memberStateResponse == null) {
      return false;
    }
    final memberRights = memberStateResponse.memberRights;
    if (memberRights == null) {
      return false;
    } else {
      final right = memberRights.where((element) => element.state == id);
      if (right.isEmpty) {
        return false;
      } else {
        return right.first.isSelected;
      }
    }
  }

  @override
  Future<void> clearMemberRights() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInMemberState();
  }

  @override
  Future<void> storeCommunityData(Community community) async {
    await LMChatCore.instance.lmChatClient.insertOrUpdateCommunity(community);
  }

  @override
  Community? getCommunity() {
    return LMChatCore.instance.lmChatClient.getCommunity().data;
  }

  @override
  Future<void> clearCommunityData() async {
    await LMChatCore.instance.lmChatClient.deleteCommunity();
  }

  @override
  Future<void> clearLocalPrefs() async {
    await clearUserData();
    await clearMemberRights();
    await clearCommunityData();
  }
}
