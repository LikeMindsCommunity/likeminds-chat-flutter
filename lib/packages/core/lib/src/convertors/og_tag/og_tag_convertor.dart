import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension OGTagConvertor on OgTags {
  LMChatOGTagsViewData toLMChatOGTagViewData() {
    final LMChatOGTagsViewDataBuilder builder = LMChatOGTagsViewDataBuilder()
      ..description(description)
      ..imageUrl(image)
      ..title(title)
      ..url(url);

    return builder.build();
  }
}

extension OGTagViewDataConvertor on LMChatOGTagsViewData {
  OgTags toOGTag() {
    return OgTags(
      description: description,
      image: imageUrl,
      title: title,
      url: url,
    );
  }
}
