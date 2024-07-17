import 'package:likeminds_chat_flutter_ui/src/models/sdk/sdk_client_info_view_data.dart';
import 'package:likeminds_chat_flutter_ui/src/models/widget/widget_view_data.dart';

/// {@template lm_user_view_data}
/// A view data class to hold the user data.
/// {@endtemplate}
class LMChatUserViewData {
  /// unique identifier of the user
  int id;

  /// name of the user
  String name;

  /// image url of the user
  String? imageUrl;
  bool? isGuest;
  bool? isDeleted;
  String uuid;
  String? organisationName;
  LMChatSDKClientInfoViewData? sdkClientInfo;
  int? updatedAt;
  bool? isOwner;

  /// custom title of the user
  /// eg: Community Manager
  String? customTitle;

  /// date since the user is a member of the community
  String? memberSince;
  String? route;
  int? state;

  /// community id of the community to which the user belongs
  int? communityId;
  int? createdAt;
  String? customIntroText;
  int? memberSinceEpoch;

  /// widget for storing custom data
  LMChatWidgetViewData? widget;

  /// {@macro user_view_data}
  LMChatUserViewData._({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isGuest,
    required this.uuid,
    this.organisationName,
    required this.sdkClientInfo,
    this.updatedAt,
    this.isOwner,
    this.customTitle,
    this.memberSince,
    this.route,
    this.state,
    this.communityId,
    this.createdAt,
    this.isDeleted,
    this.widget,
  });

  /// copyWith method is used to create a new instance of `LMChatUserViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatUserViewData copyWith({
    int? id,
    String? name,
    String? imageUrl,
    bool? isGuest,
    bool? isDeleted,
    String? uuid,
    String? organisationName,
    LMChatSDKClientInfoViewData? sdkClientInfo,
    int? updatedAt,
    bool? isOwner,
    String? customTitle,
    String? memberSince,
    String? route,
    int? state,
    int? communityId,
    int? createdAt,
    LMChatWidgetViewData? widget,
  }) {
    return LMChatUserViewData._(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isGuest: isGuest ?? this.isGuest,
      uuid: uuid ?? this.uuid,
      organisationName: organisationName ?? this.organisationName,
      sdkClientInfo: sdkClientInfo ?? this.sdkClientInfo,
      updatedAt: updatedAt ?? this.updatedAt,
      isOwner: isOwner ?? this.isOwner,
      customTitle: customTitle ?? this.customTitle,
      memberSince: memberSince ?? this.memberSince,
      route: route ?? this.route,
      state: state ?? this.state,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      widget: widget ?? this.widget,
    );
  }
}

/// {@template user_view_data_builder}
/// A builder class to build [LMUserViewData]
/// {@endtemplate}
class LMChatUserViewDataBuilder {
  int? _id;
  String? _name;
  String? _imageUrl;
  bool? _isGuest;
  bool? _isDeleted;
  String? _uuid;
  String? _organisationName;
  LMChatSDKClientInfoViewData? _sdkClientInfo;
  int? _updatedAt;
  bool? _isOwner;
  String? _customTitle;
  String? _memberSince;
  String? _route;
  int? _state;
  int? _communityId;
  int? _createdAt;
  LMChatWidgetViewData? _widget;
  void id(int? id) {
    _id = id;
  }

  void name(String? name) {
    _name = name;
  }

  void imageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
  }

  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  void isDeleted(bool? isDeleted) {
    _isDeleted = isDeleted;
  }

  void uuid(String? uuid) {
    _uuid = uuid;
  }

  void organisationName(String? organisationName) {
    _organisationName = organisationName;
  }

  void sdkClientInfo(LMChatSDKClientInfoViewData? sdkClientInfo) {
    _sdkClientInfo = sdkClientInfo;
  }

  void updatedAt(int? updatedAt) {
    _updatedAt = updatedAt;
  }

  void isOwner(bool? isOwner) {
    _isOwner = isOwner;
  }

  void customTitle(String? customTitle) {
    _customTitle = customTitle;
  }

  void memberSince(String? memberSince) {
    _memberSince = memberSince;
  }

  void route(String? route) {
    _route = route;
  }

  void state(int? state) {
    _state = state;
  }

  void communityId(int? communityId) {
    _communityId = communityId;
  }

  void createdAt(int? createdAt) {
    _createdAt = createdAt;
  }

  void widget(LMChatWidgetViewData? widget) {
    _widget = widget;
  }

  /// {@macro user_view_data_builder}
  LMChatUserViewData build() {
    if (_id == null) {
      throw Exception('id must not be null');
    }
    if (_name == null) {
      throw Exception('name must not be null');
    }
    if (_uuid == null) {
      throw Exception('uuid must not be null');
    }

    return LMChatUserViewData._(
      id: _id!,
      name: _name!,
      imageUrl: _imageUrl,
      isGuest: _isGuest,
      uuid: _uuid!,
      organisationName: _organisationName,
      sdkClientInfo: _sdkClientInfo,
      updatedAt: _updatedAt,
      isOwner: _isOwner,
      customTitle: _customTitle,
      memberSince: _memberSince,
      route: _route,
      state: _state,
      communityId: _communityId,
      createdAt: _createdAt,
      isDeleted: _isDeleted,
      widget: _widget,
    );
  }
}
