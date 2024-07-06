import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [ReportTagViewDataConvertor] is an extension on [ReportTag] class.
/// It converts [ReportTag] to [LMChatReportTagViewData].
/// It is used to convert [ReportTag] to [LMChatReportTagViewData].
extension ReportTagViewDataConvertor on ReportTag {
  /// Converts [ReportTag] to [LMChatReportTagViewData]
  LMChatReportTagViewData toReportTagViewData() {
    return (LMChatReportTagViewDataBuilder()
          ..id(id)
          ..name(name))
        .build();
  }
}

/// [ReportTagConvertor] is an extension on [LMChatReportTagViewData] class.
/// It converts [LMChatReportTagViewData] to [ReportTag].
/// It is used to convert [LMChatReportTagViewData] to [ReportTag].
extension ReportTagConvertor on LMChatReportTagViewData {
  /// Converts [LMChatReportTagViewData] to [ReportTag]
  ReportTag toReportTag() {
    return ReportTag(id: id, name: name);
  }
}
