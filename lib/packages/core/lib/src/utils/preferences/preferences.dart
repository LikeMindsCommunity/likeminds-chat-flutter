import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

class LMChatLocalPreference {
  // Singleton instance of LMChatPreference class
  static LMChatLocalPreference? _instance;
  static LMChatLocalPreference get instance =>
      _instance ??= LMChatLocalPreference._();

  LMChatLocalPreference._();

  Future<void> storeUserData1(User user) async {
    await clearUserData();
    await LMChatCore.instance.lmChatClient.insertOrUpdateLoggedInUser(user);
  }

  User? getUser() {
    return LMChatCore.instance.lmChatClient.getLoggedInUser().data;
  }

  Future<void> clearUserData() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInUser();
  }

  Future<void> storeMemberRights(MemberStateResponse memberState) async {
    await clearMemberRights();
    await LMChatCore.instance.lmChatClient
        .insertOrUpdateLoggedInMemberState(memberState);
  }

  MemberStateResponse? getMemberRights() {
    return LMChatCore.instance.lmChatClient.getLoggedInMemberState().data;
  }

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

  Future<void> clearMemberRights() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInMemberState();
  }

  Future<void> storeCommunityData(Community community) async {
    await clearCommunityData();
    await LMChatCore.instance.lmChatClient.insertOrUpdateCommunity(community);
  }

  Community? getCommunityData() {
    return LMChatCore.instance.lmChatClient.getCommunity().data;
  }

  Future<void> clearCommunityData() async {
    await LMChatCore.instance.lmChatClient.deleteCommunity();
  }

  Future<LMResponse> storeCache(LMChatCache cache) {
    return LMChatCore.client.insertOrUpdateCache(cache);
  }

  LMChatCache? fetchCache(String key) {
    LMResponse response = LMChatCore.client.getCache(key);

    if (response.success) {
      return response.data!;
    } else {
      return null;
    }
  }

  Future<LMResponse> deleteCache(String key) {
    return LMChatCore.client.deleteCache(key);
  }

  Future<LMResponse> clearCache() {
    return LMChatCore.client.clearCache();
  }

  Future<void> clearLocalData() async {
    await clearUserData();
    await clearMemberRights();
    await clearCommunityData();
    await clearCache();
  }
}
