import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

enum LMTagType { groupTag, userTag }

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
  });

  //factory constructor for groupTag
  factory LMChatTagViewData.fromGroupTag(GroupTag groupTag) {
    return (LMChatTagViewDataBuilder()
          ..name(groupTag.name!)
          ..imageUrl(groupTag.imageUrl!)
          ..tagType(LMTagType.groupTag)
          ..description(groupTag.description)
          ..route(groupTag.route)
          ..tag(groupTag.tag))
        .build();
  }

  //factory constructor for userTag
  factory LMChatTagViewData.fromUserTag(UserTag userTag) {
    return (LMChatTagViewDataBuilder()
          ..name(userTag.name!)
          ..imageUrl(userTag.imageUrl!)
          ..tagType(LMTagType.userTag)
          ..customTitle(userTag.customTitle)
          ..id(userTag.id)
          ..isGuest(userTag.isGuest)
          ..userUniqueId(userTag.userUniqueId))
        .build();
  }
}

// Builder class
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
    );
  }
}
