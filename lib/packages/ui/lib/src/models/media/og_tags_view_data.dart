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
}

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

  LMChatOGTagsViewData build() {
    return LMChatOGTagsViewData._(
      title: _title,
      description: _description,
      imageUrl: _imageUrl,
      url: _url,
    );
  }
}