import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension UserViewDataConvertor on User {
  LMChatUserViewData toUserViewData() {
    final LMChatUserViewDataBuilder userBuilder = LMChatUserViewDataBuilder()
      ..id(id)
      ..name(name)
      ..imageUrl(imageUrl)
      ..isGuest(isGuest)
      ..uuid(userUniqueId)
      ..organisationName(organisationName)
      // ..sdkClientInfo(sdkClientInfo.toSDKClientInfoViewData())
      ..updatedAt(updatedAt)
      ..isOwner(isOwner)
      ..customTitle(customTitle)
      ..memberSince(memberSince)
      ..route(route)
      ..state(state)
      ..communityId(communityId)
      ..createdAt(createdAt);
    return userBuilder.build();
  }
}

extension UserViewConvertor on LMChatUserViewData {
  User toUser() {
    return User(
      id: id,
      name: name,
      imageUrl: imageUrl!,
      isGuest: isGuest!,
      userUniqueId: uuid,
      organisationName: organisationName,
      // sdkClientInfo: sdkClientInfo!.toSDKClientInfo(),
      updatedAt: updatedAt,
      isOwner: isOwner,
      customTitle: customTitle,
      memberSince: memberSince,
      route: route,
      state: state,
      communityId: communityId,
      createdAt: createdAt,
    );
  }
}


