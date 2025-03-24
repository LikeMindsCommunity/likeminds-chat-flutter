import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/sdk_client_info_convertor.dart';

/// Extension to convert between UserRole and LMChatUserRole
extension UserRoleConvertor on UserRole {
  /// Converts UserRole to LMChatUserRole
  LMChatUserRole toLMChatUserRole() {
    switch (this) {
      case UserRole.chatbot:
        return LMChatUserRole.chatbot;
      case UserRole.member:
        return LMChatUserRole.member;
      case UserRole.admin:
        return LMChatUserRole.admin;
      default:
        return LMChatUserRole.member;
    }
  }
}

/// Extension to convert between LMChatUserRole and UserRole
extension LMChatUserRoleConvertor on LMChatUserRole {
  /// Converts LMChatUserRole to UserRole
  UserRole toUserRole() {
    switch (this) {
      case LMChatUserRole.chatbot:
        return UserRole.chatbot;
      case LMChatUserRole.member:
        return UserRole.member;
      case LMChatUserRole.admin:
        return UserRole.admin;
      default:
        return UserRole.member;
    }
  }
}

/// Extension to convert User to LMChatUserViewData
extension UserViewDataConvertor on User {
  /// Converts User to LMChatUserViewData
  LMChatUserViewData toUserViewData() {
    final LMChatUserViewDataBuilder userBuilder = LMChatUserViewDataBuilder()
      ..id(id)
      ..name(name)
      ..imageUrl(imageUrl)
      ..isGuest(isGuest)
      ..uuid(userUniqueId)
      ..organisationName(organisationName)
      ..sdkClientInfo(sdkClientInfo?.toSDKClientInfoViewdata())
      ..updatedAt(updatedAt)
      ..isOwner(isOwner)
      ..customTitle(customTitle)
      ..memberSince(memberSince)
      ..route(route)
      ..state(state)
      ..communityId(communityId)
      ..createdAt(createdAt)
      ..roles(roles?.map((role) => role.toLMChatUserRole()).toList());
    return userBuilder.build();
  }
}

/// Extension to convert LMChatUserViewData to User
extension UserViewConvertor on LMChatUserViewData {
  /// Converts LMChatUserViewData to User
  User toUser() {
    return User(
      id: id,
      name: name,
      imageUrl: imageUrl,
      isGuest: isGuest!,
      userUniqueId: uuid,
      organisationName: organisationName,
      sdkClientInfo: sdkClientInfo?.toSDKClientInfo(),
      updatedAt: updatedAt,
      isOwner: isOwner,
      customTitle: customTitle,
      memberSince: memberSince,
      route: route,
      state: state,
      communityId: communityId,
      createdAt: createdAt,
      roles: roles?.map((role) => role.toUserRole()).toList(),
    );
  }
}
