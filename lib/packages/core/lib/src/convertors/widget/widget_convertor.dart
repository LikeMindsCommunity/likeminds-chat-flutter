import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// Extension to convert LMWidgetData to LMChatWidgetViewData
extension LMChatWidgetViewDataConvertor on LMWidgetData {
  /// Converts LMWidgetData to LMChatWidgetViewData
  LMChatWidgetViewData toWidgetViewData() {
    final LMWidgetViewDataBuilder widgetBuilder = LMWidgetViewDataBuilder()
      ..id(id)
      ..lmMeta(lmMeta)
      ..createdAt(createdAt)
      ..metadata(metadata)
      ..parentEntityId(parentEntityId)
      ..parentEntityType(parentEntityType)
      ..updatedAt(updatedAt);
    return widgetBuilder.build();
  }
}

/// Extension to convert LMChatWidgetViewData to LMWidgetData
extension LMWidgetDataConvertor on LMChatWidgetViewData {
  /// Converts LMChatWidgetViewData to LMWidgetData
  LMWidgetData toWidgetData() {
    return LMWidgetData(
      id: id,
      lmMeta: lmMeta,
      createdAt: createdAt,
      metadata: metadata,
      parentEntityId: parentEntityId,
      parentEntityType: parentEntityType,
      updatedAt: updatedAt,
    );
  }
}
