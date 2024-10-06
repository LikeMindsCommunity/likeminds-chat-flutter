import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// `LMTagType` is an enum class that holds the values for the tag type.
/// This class is used to differentiate between the group tag and user tag.
/// The values are `groupTag` and `userTag`.
enum LMTagType { groupTag, userTag }

/// `LMChatTagViewData` is a model class that holds the data for the tag view.
/// This class is used to display the tag information in the chat screen.
class LMChatTagViewData {
  //common values
  final String name;
  final String imageUrl;
  final LMTagType tagType;

  // groupTag specific values
  final String? description;
  final String? route;
  final String? tag;

  // userTag specific values
  final String? customTitle;
  final int? id;
  final bool? isGuest;
  final String? userUniqueId;
  final String? uuid;
  final LMChatSDKClientInfoViewData? sdkClientInfoViewData;

  LMChatTagViewData._({
    required this.name,
    required this.imageUrl,
    required this.tagType,
    this.description,
    this.route,
    this.tag,
    this.customTitle,
    this.id,
    this.isGuest,
    this.userUniqueId,
    this.uuid,
    this.sdkClientInfoViewData,
  });

  /// copyWith method is used to create a new instance of `LMChatTagViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatTagViewData copyWith({
    String? name,
    String? imageUrl,
    LMTagType? tagType,
    String? description,
    String? route,
    String? tag,
    String? customTitle,
    int? id,
    bool? isGuest,
    String? userUniqueId,
    String? uuid,
    LMChatSDKClientInfoViewData? sdkClientInfoViewData,
  }) {
    return LMChatTagViewData._(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      tagType: tagType ?? this.tagType,
      description: description ?? this.description,
      route: route ?? this.route,
      tag: tag ?? this.tag,
      customTitle: customTitle ?? this.customTitle,
      id: id ?? this.id,
      isGuest: isGuest ?? this.isGuest,
      userUniqueId: userUniqueId ?? this.userUniqueId,
      uuid: uuid ?? this.uuid,
      sdkClientInfoViewData:
          sdkClientInfoViewData ?? this.sdkClientInfoViewData,
    );
  }
}

/// `LMChatTagViewDataBuilder` is a builder class used to create an instance of `LMChatTagViewData`.
/// This class is used to create an instance of `LMChatTagViewData` with the provided values.
class LMChatTagViewDataBuilder {
  String? _name;
  String? _imageUrl;
  LMTagType? _tagType;
  String? _description;
  String? _route;
  String? _tag;
  String? _customTitle;
  int? _id;
  bool? _isGuest;
  String? _userUniqueId;
  String? _uuid;
  LMChatSDKClientInfoViewData? _sdkClientInfoViewData;

  void name(String name) {
    _name = name;
  }

  void imageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  void tagType(LMTagType tagType) {
    _tagType = tagType;
  }

  void description(String? description) {
    _description = description;
  }

  void route(String? route) {
    _route = route;
  }

  void tag(String? tag) {
    _tag = tag;
  }

  void customTitle(String? customTitle) {
    _customTitle = customTitle;
  }

  void id(int? id) {
    _id = id;
  }

  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  void userUniqueId(String? userUniqueId) {
    _userUniqueId = userUniqueId;
  }

  void uuid(String? uuid) {
    _uuid = uuid;
  }

  void sdkClientInfoViewData(
      LMChatSDKClientInfoViewData? sdkClientInfoViewData) {
    _sdkClientInfoViewData = sdkClientInfoViewData;
  }

  /// build method is used to create an instance of `LMChatTagViewData` with the provided values.
  LMChatTagViewData build() {
    if (_name == null) {
      throw StateError("name is required");
    }
    if (_imageUrl == null) {
      throw StateError("imageUrl is required");
    }
    if (_tagType == null) {
      throw StateError("lmTagType is required");
    }

    return LMChatTagViewData._(
      name: _name!,
      imageUrl: _imageUrl!,
      tagType: _tagType!,
      description: _description,
      route: _route,
      tag: _tag,
      customTitle: _customTitle,
      id: _id,
      isGuest: _isGuest,
      userUniqueId: _userUniqueId,
      uuid: _uuid,
      sdkClientInfoViewData: _sdkClientInfoViewData,
    );
  }
}
