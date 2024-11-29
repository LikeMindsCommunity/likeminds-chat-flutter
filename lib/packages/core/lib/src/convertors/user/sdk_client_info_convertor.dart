import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// Extension to convert SDKClientInfo to view data
extension SdkClientInfoConvertor on SDKClientInfo {
  /// Converts SDKClientInfo to LMChatSDKClientInfoViewData
  LMChatSDKClientInfoViewData toSDKClientInfoViewdata() {
    LMSDKClientInfoViewDataBuilder builder = LMSDKClientInfoViewDataBuilder()
      ..community(community!)
      ..user(user!)
      ..uuid(uuid!);
    return builder.build();
  }
}

/// Extension to convert LMChatSDKClientInfoViewData back to SDKClientInfo
extension LMChatSDKClientInfoViewDataConvertor on LMChatSDKClientInfoViewData {
  /// Converts LMChatSDKClientInfoViewData to SDKClientInfo
  SDKClientInfo toSDKClientInfo() {
    return SDKClientInfo(
      community: community,
      user: user,
      uuid: uuid,
    );
  }
}
