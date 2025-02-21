import 'dart:io';

/// `LMChatAttachmentViewData` is a model class that holds the data for the attachment view.
class LMChatAttachmentViewData {
  final int? answerId;
  final int? createdAt;
  final dynamic dimensions;
  final String? fileUrl;
  final String? url;
  final File? attachmentFile;
  final dynamic height;
  final int? id;
  final int? index;
  final dynamic locationLat;
  final dynamic locationLong;
  final dynamic locationName;
  final dynamic meta;
  final String? name;
  final String? thumbnailUrl;
  final File? thumbnailFile;
  final String? type;
  final dynamic width;

  LMChatAttachmentViewData._({
    required this.answerId,
    required this.createdAt,
    required this.dimensions,
    required this.fileUrl,
    required this.url,
    required this.attachmentFile,
    required this.height,
    required this.id,
    required this.index,
    required this.locationLat,
    required this.locationLong,
    required this.locationName,
    required this.meta,
    required this.name,
    required this.thumbnailUrl,
    required this.thumbnailFile,
    required this.type,
    required this.width,
  });

  /// copyWith method is used to create a new instance of `LMChatAttachmentViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatAttachmentViewData copyWith({
    int? answerId,
    int? createdAt,
    dynamic dimensions,
    String? fileUrl,
    String? url,
    File? attachmentFile,
    dynamic height,
    int? id,
    int? index,
    dynamic locationLat,
    dynamic locationLong,
    dynamic locationName,
    dynamic meta,
    String? name,
    String? thumbnailUrl,
    File? thumbnailFile,
    String? type,
    dynamic width,
  }) {
    return LMChatAttachmentViewData._(
      answerId: answerId ?? this.answerId,
      createdAt: createdAt ?? this.createdAt,
      dimensions: dimensions ?? this.dimensions,
      fileUrl: fileUrl ?? this.fileUrl,
      url: url ?? this.url,
      attachmentFile: attachmentFile ?? this.attachmentFile,
      height: height ?? this.height,
      id: id ?? this.id,
      index: index ?? this.index,
      locationLat: locationLat ?? this.locationLat,
      locationLong: locationLong ?? this.locationLong,
      locationName: locationName ?? this.locationName,
      meta: meta ?? this.meta,
      name: name ?? this.name,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      thumbnailFile: thumbnailFile ?? this.thumbnailFile,
      type: type ?? this.type,
      width: width ?? this.width,
    );
  }
}

/// `LMChatAttachmentViewDataBuilder` is a builder class that helps in building the `LMChatAttachmentViewData` object.
class LMChatAttachmentViewDataBuilder {
  int? _answerId;
  int? _createdAt;
  dynamic _dimensions;
  String? _fileUrl;
  String? _url;
  File? _attachmentFile;
  dynamic _height;
  int? _id;
  int? _index;
  dynamic _locationLat;
  dynamic _locationLong;
  dynamic _locationName;
  dynamic _meta;
  String? _name;
  String? _thumbnailUrl;
  File? _thumbnailFile;
  String? _type;
  dynamic _width;

  void answerId(int? answerId) {
    _answerId = answerId;
  }

  void createdAt(int? createdAt) {
    _createdAt = createdAt;
  }

  void dimensions(dynamic dimensions) {
    _dimensions = dimensions;
  }

  void fileUrl(String? fileUrl) {
    _fileUrl = fileUrl;
  }

  void url(String? url) {
    _url = url;
  }

  void attachmentFile(File? attachmentFile) {
    _attachmentFile = attachmentFile;
  }

  void height(dynamic height) {
    _height = height;
  }

  void id(int? id) {
    _id = id;
  }

  void index(int? index) {
    _index = index;
  }

  void locationLat(dynamic locationLat) {
    _locationLat = locationLat;
  }

  void locationLong(dynamic locationLong) {
    _locationLong = locationLong;
  }

  void locationName(dynamic locationName) {
    _locationName = locationName;
  }

  void meta(dynamic meta) {
    _meta = meta;
  }

  void name(String? name) {
    _name = name;
  }

  void thumbnailUrl(String? thumbnailUrl) {
    _thumbnailUrl = thumbnailUrl;
  }

  void thumbnailFile(File? thumbnailFile) {
    _thumbnailFile = thumbnailFile;
  }

  void type(String? type) {
    _type = type;
  }

  void width(dynamic width) {
    _width = width;
  }

  /// build method is used to create a new instance of `LMChatAttachmentViewData` with the provided values.
  LMChatAttachmentViewData build() {
    return LMChatAttachmentViewData._(
      answerId: _answerId,
      createdAt: _createdAt,
      dimensions: _dimensions,
      fileUrl: _fileUrl,
      url: _url,
      attachmentFile: _attachmentFile,
      height: _height,
      id: _id,
      index: _index,
      locationLat: _locationLat,
      locationLong: _locationLong,
      locationName: _locationName,
      meta: _meta,
      name: _name,
      thumbnailUrl: _thumbnailUrl,
      thumbnailFile: _thumbnailFile,
      type: _type,
      width: _width,
    );
  }
}
