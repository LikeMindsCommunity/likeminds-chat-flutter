/// `LMChatOGTagsViewData` is a model class that contains the data required to display the Open Graph tags in the chat.
/// This class is used to display the Open Graph tags in the chat screen.
class LMChatOGTagsViewData {
  String? title;
  String? description;
  String? imageUrl;
  String? url;

  LMChatOGTagsViewData._({
    this.title,
    this.description,
    this.imageUrl,
    this.url,
  });

  /// copyWith method is used to create a new instance of `LMChatOGTagsViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatOGTagsViewData copyWith({
    String? title,
    String? description,
    String? imageUrl,
    String? url,
  }) {
    return LMChatOGTagsViewData._(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
    );
  }
}

/// `LMChatOGTagsViewDataBuilder` is a builder class used to create an instance of `LMChatOGTagsViewData`.
/// This class is used to create an instance of `LMChatOGTagsViewData` with the provided values.
class LMChatOGTagsViewDataBuilder {
  String? _title;
  String? _description;
  String? _imageUrl;
  String? _url;

  void title(String? title) {
    _title = title;
  }

  void description(String? description) {
    _description = description;
  }

  void imageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
  }

  void url(String? url) {
    _url = url;
  }

  /// build method is used to create an instance of `LMChatOGTagsViewData` with the provided values.
  LMChatOGTagsViewData build() {
    return LMChatOGTagsViewData._(
      title: _title,
      description: _description,
      imageUrl: _imageUrl,
      url: _url,
    );
  }
}
