/// {@template lm_chat_delete_reason_view_data}
/// A data class to hold the delete reason data.
/// {@endtemplate}
class LMChatDeleteReasonViewData {
  /// The id of the delete reason.
  final int id;

  /// The reason for the delete.
  final String name;

  /// {@macro lm_chat_delete_reason_view_data}
  const LMChatDeleteReasonViewData._({
    required this.id,
    required this.name,
  });
}

/// {@template lm_delete_reason_view_data_builder}
/// A builder class to build [LMChatDeleteReasonViewData]
/// {@endtemplate}

class LMChatDeleteReasonViewDataBuilder {
  int? _id;
  String? _name;

  /// Set the id of the delete reason.
  void id(int id) {
    _id = id;
  }

  /// Set the name of the delete reason.
  void name(String name) {
    _name = name;
  }

  /// Builds the [LMChatDeleteReasonViewData]
  /// 
  LMChatDeleteReasonViewData build() {
    return LMChatDeleteReasonViewData._(
      id: _id!,
      name: _name!,
    );
  }
}
