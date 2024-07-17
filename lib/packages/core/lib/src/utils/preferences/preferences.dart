import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// [LMChatLocalPreference] is responsible for handling the local preferences of the chat.
/// It has a singleton instance [instance] which is used to access the preferences.
/// It has functions to store and fetch the user data, member rights, community data, cache data and clear the local data.
class LMChatLocalPreference {
  // Singleton instance of LMChatPreference class
  static LMChatLocalPreference? _instance;

  /// Singleton instance of [LMChatLocalPreference]
  static LMChatLocalPreference get instance =>
      _instance ??= LMChatLocalPreference._();

  LMChatLocalPreference._();

  /// This function is used to store the user data in the local preferences.
  Future<void> storeUserData(User user) async {
    await LMChatCore.instance.lmChatClient.insertOrUpdateLoggedInUser(user);
  }

  /// This function is used to fetch the user data from the local preferences.
  User getUser() {
    final User? user = LMChatCore.instance.lmChatClient.getLoggedInUser().data;
    return user ?? (throw Exception('User not found'));
  }

  /// This function is used to clear the user data from the local preferences.
  Future<void> clearUserData() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInUser();
  }

  /// This function is used to store the member rights in the local preferences.
  Future<void> storeMemberRights(MemberStateResponse memberState) async {
    await LMChatCore.instance.lmChatClient
        .insertOrUpdateLoggedInMemberState(memberState);
  }

  /// This function is used to fetch the member rights from the local preferences.
  MemberStateResponse? getMemberRights() {
    return LMChatCore.instance.lmChatClient.getLoggedInMemberState().data;
  }

  /// This function is used to fetch the member right of a particular state from the local preferences.
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

  /// This function is used to clear the member rights from the local preferences.
  Future<void> clearMemberRights() async {
    await LMChatCore.instance.lmChatClient.deleteLoggedInMemberState();
  }

  /// This function is used to store the community data in the local preferences.
  Future<void> storeCommunityData(Community community) async {
    await clearCommunityData();
    await LMChatCore.instance.lmChatClient.insertOrUpdateCommunity(community);
  }

  /// This function is used to fetch the community data from the local preferences.
  Community? getCommunityData() {
    return LMChatCore.instance.lmChatClient.getCommunity().data;
  }

  /// This function is used to clear the community data from the local preferences.
  Future<void> clearCommunityData() async {
    await LMChatCore.instance.lmChatClient.deleteCommunity();
  }

  /// This function is used to store the cache data in the local preferences.
  Future<LMResponse> storeCache(LMChatCache cache) {
    return LMChatCore.client.insertOrUpdateCache(cache);
  }

  /// This function is used to fetch the cache data from the local preferences.
  LMChatCache? fetchCache(String key) {
    LMResponse response = LMChatCore.client.getCache(key);

    if (response.success) {
      return response.data!;
    } else {
      return null;
    }
  }

  /// This function is used to delete the cache data from the local preferences.
  Future<LMResponse> deleteCache(String key) {
    return LMChatCore.client.deleteCache(key);
  }

  /// This function is used to clear the cache data from the local preferences.
  Future<LMResponse> clearCache() {
    return LMChatCore.client.clearCache();
  }

  /// This function is used to clear the local data from the local preferences.
  Future<void> clearLocalData() async {
    await clearUserData();
    await clearMemberRights();
    await clearCommunityData();
    await clearCache();
  }
}
