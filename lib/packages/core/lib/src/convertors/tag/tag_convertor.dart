import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

//TODO: remove this code to convertor class
//factory constructor for groupTag
// factory LMChatTagViewData.fromGroupTag(GroupTag groupTag) {
//   return (LMChatTagViewDataBuilder()
//         ..name(groupTag.name!)
//         ..imageUrl(groupTag.imageUrl!)
//         ..tagType(LMTagType.groupTag)
//         ..description(groupTag.description)
//         ..route(groupTag.route)
//         ..tag(groupTag.tag))
//       .build();
// }

//TODO: remove this code to convertor class
//factory constructor for userTag
// factory LMChatTagViewData.fromUserTag(UserTag userTag) {
//   return (LMChatTagViewDataBuilder()
//         ..name(userTag.name!)
//         ..imageUrl(userTag.imageUrl!)
//         ..tagType(LMTagType.userTag)
//         ..customTitle(userTag.customTitle)
//         ..id(userTag.id)
//         ..isGuest(userTag.isGuest)
//         ..userUniqueId(userTag.userUniqueId))
//       .build();
// }

extension GroupTagConvertor on GroupTag {
  LMChatTagViewData toLMChatTagViewData() {
    LMChatTagViewDataBuilder builder = LMChatTagViewDataBuilder()
      ..name(name!)
      ..imageUrl(imageUrl!)
      ..tagType(LMTagType.groupTag)
      ..description(description)
      ..route(route)
      ..tag(tag);
    return builder.build();
  }
}

extension UserTagConvertor on UserTag {
  LMChatTagViewData toLMChatTagViewData() {
    LMChatTagViewDataBuilder builder = LMChatTagViewDataBuilder()
      ..name(name!)
      ..imageUrl(imageUrl!)
      ..tagType(LMTagType.userTag)
      ..customTitle(customTitle)
      ..id(id)
      ..isGuest(isGuest)
      ..userUniqueId(userUniqueId);
    return builder.build();
  }
}
