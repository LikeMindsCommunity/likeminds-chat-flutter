/// `LMWidgetViewData` is a data class that represents the data of a widget view.
/// This class is used to display the widget view in the chat screen.
class LMChatWidgetViewData {
  /// Unique identifier for the widget.
  final String id;

  /// Metadata associated with the widget, can be null.
  Map<String, dynamic>? lmMeta;

  /// Timestamp representing when the widget was created.
  int? createdAt;

  /// Additional metadata for the widget.
  Map<String, dynamic> metadata;

  /// Identifier for the parent entity of the widget.
  String? parentEntityId;

  /// Type of the parent entity of the widget.
  String? parentEntityType;

  /// Timestamp representing when the widget was last updated.
  int? updatedAt;

  LMChatWidgetViewData._({
    required this.id,
    this.lmMeta,
    this.createdAt,
    required this.metadata,
    this.parentEntityId,
    this.parentEntityType,
    this.updatedAt,
  });

  /// copyWith method is used to create a new instance of `LMChatWidgetViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatWidgetViewData copyWith({
    String? id,
    Map<String, dynamic>? lmMeta,
    int? createdAt,
    Map<String, dynamic>? metadata,
    String? parentEntityId,
    String? parentEntityType,
    int? updatedAt,
  }) {
    return LMChatWidgetViewData._(
      id: id ?? this.id,
      lmMeta: lmMeta ?? this.lmMeta,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
      parentEntityId: parentEntityId ?? this.parentEntityId,
      parentEntityType: parentEntityType ?? this.parentEntityType,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// `LMWidgetViewDataBuilder` is a builder class used to create an instance of `LMChatWidgetViewData`.
/// This class is used to create an instance of `LMChatWidgetViewData` with the provided values.
class LMWidgetViewDataBuilder {
  String? _id;
  Map<String, dynamic>? _lmMeta;
  int? _createdAt;
  Map<String, dynamic>? _metadata;
  String? _parentEntityId;
  String? _parentEntityType;
  int? _updatedAt;

  /// Sets the ID of the widget.
  ///
  /// [id] The ID to set.
  void id(String? id) {
    _id = id;
  }

  /// Sets the metadata for the widget.
  ///
  /// [lmMeta] The metadata to set.
  void lmMeta(Map<String, dynamic>? lmMeta) {
    _lmMeta = lmMeta;
  }

  /// Sets the creation timestamp of the widget.
  ///
  /// [createdAt] The creation timestamp to set.
  void createdAt(int? createdAt) {
    _createdAt = createdAt;
  }

  /// Sets additional metadata for the widget.
  ///
  /// [metadata] The additional metadata to set.
  void metadata(Map<String, dynamic>? metadata) {
    _metadata = metadata;
  }

  /// Sets the parent entity ID of the widget.
  ///
  /// [parentEntityId] The parent entity ID to set.
  void parentEntityId(String? parentEntityId) {
    _parentEntityId = parentEntityId;
  }

  /// Sets the parent entity type of the widget.
  ///
  /// [parentEntityType] The parent entity type to set.
  void parentEntityType(String? parentEntityType) {
    _parentEntityType = parentEntityType;
  }

  /// Sets the update timestamp of the widget.
  ///
  /// [updatedAt] The update timestamp to set.
  void updatedAt(int? updatedAt) {
    _updatedAt = updatedAt;
  }

  LMChatWidgetViewData build() {
    if (_id == null) {
      throw Exception("Missing required parameter: id");
    }

    return LMChatWidgetViewData._(
      id: _id!,
      lmMeta: _lmMeta,
      createdAt: _createdAt,
      metadata: _metadata ?? {},
      parentEntityId: _parentEntityId,
      parentEntityType: _parentEntityType,
      updatedAt: _updatedAt,
    );
  }
}
