import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension SdkClientInfoConvertor on SDKClientInfo {
  LMChatSDKClientInfoViewData toSDKClientInfoViewdata() {
    LMSDKClientInfoViewDataBuilder builder = LMSDKClientInfoViewDataBuilder()
      ..community(community!)
      ..user(user!)
      ..uuid(uuid!);
    return builder.build();
  }
}

extension LMChatSDKClientInfoViewDataConvertor on LMChatSDKClientInfoViewData {
  SDKClientInfo toSDKClientInfo() {
    return SDKClientInfo(
      community: community,
      user: user,
      uuid: uuid,
    );
  }
}
