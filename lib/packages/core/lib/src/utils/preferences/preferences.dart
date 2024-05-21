import 'dart:convert';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILMPreferenceService {
  Future<void> initialize();
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

  late SharedPreferences _sharedPreferences;

  LMChatPreferences._();

  User? currentUser;

  set setCurrentUser(User user) => currentUser = user;
  get getCurrentUser => currentUser;

  @override
  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> storeUserData(User user) async {
    setCurrentUser = user;
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    await _sharedPreferences.setString('user', userString);
  }

  @override
  User? getUser() {
    String? userString = _sharedPreferences.getString('user');
    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);
      UserEntity userEntity = UserEntity.fromJson(userData);
      return User.fromEntity(userEntity);
    }
    return null;
  }

  @override
  void clearUserData() {
    _sharedPreferences.remove('user');
  }

  @override
  Future<void> storeMemberRights(MemberStateResponse memberState) async {
    MemberStateResponseEntity memberStateEntity = memberState.toEntity();
    Map<String, dynamic> memberStateData = memberStateEntity.toJson();
    String memberStateString = jsonEncode(memberStateData);
    await _sharedPreferences.setString('memberState', memberStateString);
  }

  @override
  MemberStateResponse? getMemberRights() {
    String? memberStateString = _sharedPreferences.getString('memberState');
    if (memberStateString != null) {
      Map<String, dynamic> memberStateData = jsonDecode(memberStateString);
      MemberStateResponseEntity memberStateEntity =
          MemberStateResponseEntity.fromJson(memberStateData);
      return MemberStateResponse.fromEntity(memberStateEntity);
    }
    return null;
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
  void clearMemberRights() {
    _sharedPreferences.remove('memberState');
  }

  @override
  Future<void> storeCommunityData(Community community) async {
    CommunityEntity communityEntity = community.toEntity();
    Map<String, dynamic> communityData = communityEntity.toJson();
    String communityString = jsonEncode(communityData);
    await _sharedPreferences.setString('community', communityString);
  }

  @override
  Community? getCommunity() {
    String? communityString = _sharedPreferences.getString('community');
    if (communityString != null) {
      Map<String, dynamic> communityData = jsonDecode(communityString);
      CommunityEntity communityEntity = CommunityEntity.fromJson(communityData);
      return Community.fromEntity(communityEntity);
    }
    return null;
  }

  @override
  void clearCommunityData() {
    _sharedPreferences.remove('community');
  }

  @override
  void clearLocalPrefs() {
    _sharedPreferences.clear();
  }
}
