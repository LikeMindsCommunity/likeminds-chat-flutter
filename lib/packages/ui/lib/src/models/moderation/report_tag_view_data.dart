/// {@template lm_chat_report_tag_view_data}
/// A view data class to hold the report tag data.
/// [id] is the id of the report tag.
/// [name] is the name of the report tag.
/// {@endtemplate}
class LMChatReportTagViewData {
  /// The id of the report tag.
  final int id;

  /// The name of the report tag.
  final String name;

  const LMChatReportTagViewData._({
    required this.id,
    required this.name,
  });

  /// copy the [LMChatReportTagViewData] with new values.
  /// [id] is the id of the report tag.
  /// [name] is the name of the report tag.
  LMChatReportTagViewData copyWith({
    int? id,
    String? name,
  }) {
    return LMChatReportTagViewData._(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

/// {@template lm_chat_report_tag_view_data_builder}
/// A builder class to build [LMChatReportTagViewData]
/// [id] is the id of the report tag.
/// [name] is the name of the report tag.
/// {@endtemplate}
class LMChatReportTagViewDataBuilder {
  int? _id;
  String? _name;

  /// Set the id of the report tag.
  void id(int id) {
    _id = id;
  }

  /// Set the name of the report tag.
  void name(String name) {
    _name = name;
  }

  /// Builds the [LMChatReportTagViewData]
  LMChatReportTagViewData build() {
    return LMChatReportTagViewData._(
      id: _id!,
      name: _name!,
    );
  }
}
