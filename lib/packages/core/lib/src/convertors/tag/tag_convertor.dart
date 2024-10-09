import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/sdk_client_info_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

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
      ..userUniqueId(userUniqueId)
      ..uuid(uuid)
      ..sdkClientInfoViewData(sdkClientInfo?.toSDKClientInfoViewdata());
    return builder.build();
  }
}
