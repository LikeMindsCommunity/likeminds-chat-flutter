import 'package:likeminds_chat_flutter_ui/src/models/sdk/sdk_client_info_view_data.dart';
import 'package:likeminds_chat_flutter_ui/src/models/widget/widget_view_data.dart';

/// Enum representing different roles a user can have
/// Enum representing different roles a user can have in a chat
/// - [chatbot]: Represents an automated chatbot user
/// - [member]: Represents a regular member user
/// - [admin]: Represents an administrator user
enum LMChatUserRole {
  /// Represents a chatbot user in the chat system
  chatbot('chatbot'),

  /// Represents a regular member user in the chat system
  member('member'),

  /// Represents an administrator user with elevated privileges
  admin('admin');

  /// The string value associated with the role
  final String value;

  /// Creates a new [LMChatUserRole] with the given string value
  const LMChatUserRole(this.value);

  /// Creates a [LMChatUserRole] from a JSON string representation
  ///
  /// The input string is case-insensitive. If an invalid role is provided,
  /// defaults to [LMChatUserRole.member]
  factory LMChatUserRole.fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'chatbot':
        return LMChatUserRole.chatbot;
      case 'member':
        return LMChatUserRole.member;
      case 'admin':
        return LMChatUserRole.admin;
      default:
        return LMChatUserRole.member;
    }
  }

  /// Converts the role to its integer representation
  ///
  /// Returns:
  /// - 0 for chatbot
  /// - 1 for admin
  /// - 4 for member
  int toIntValue() {
    switch (this) {
      case LMChatUserRole.admin:
        return 1;
      case LMChatUserRole.chatbot:
        return 0;
      case LMChatUserRole.member:
        return 4;
    }
  }
}

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

  /// isGuest is a boolean value to check if the user is a guest user
  bool? isGuest;

  /// isDeleted is a boolean value to check if the user is deleted
  bool? isDeleted;

  /// uuid is a unique identifier of the user
  String uuid;

  /// roles is a list of roles assigned to the user
  List<LMChatUserRole>? roles;

  /// organisationName is the name of the organisation to which the user belongs
  String? organisationName;

  /// sdkClientInfo is a view data class to hold the sdk client info data
  LMChatSDKClientInfoViewData? sdkClientInfo;

  /// updatedAt is the timestamp when the user data is updated
  int? updatedAt;

  /// isOwner is a boolean value to check if the user is the owner of the community
  bool? isOwner;

  /// custom title of the user
  /// eg: Community Manager
  String? customTitle;

  /// date since the user is a member of the community
  String? memberSince;

  /// route of the user
  String? route;

  /// state of the user
  int? state;

  /// community id of the community to which the user belongs
  int? communityId;

  /// createdAt is the timestamp when the user is created
  int? createdAt;

  /// customIntroText is the custom intro text of the user
  String? customIntroText;

  /// memberSinceEpoch is the epoch time since the user is a member of the community
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
    this.roles,
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
    List<LMChatUserRole>? roles,
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
      roles: roles ?? this.roles,
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
  List<LMChatUserRole>? _roles;

  /// Sets the id of the user
  void id(int? id) {
    _id = id;
  }

  /// Sets the name of the user
  void name(String? name) {
    _name = name;
  }

  /// Sets the image URL of the user
  void imageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
  }

  /// Sets whether the user is a guest
  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  /// Sets whether the user is deleted
  void isDeleted(bool? isDeleted) {
    _isDeleted = isDeleted;
  }

  /// Sets the UUID of the user
  void uuid(String? uuid) {
    _uuid = uuid;
  }

  /// Sets the organisation name of the user
  void organisationName(String? organisationName) {
    _organisationName = organisationName;
  }

  /// Sets the SDK client info of the user
  void sdkClientInfo(LMChatSDKClientInfoViewData? sdkClientInfo) {
    _sdkClientInfo = sdkClientInfo;
  }

  /// Sets the updated timestamp of the user
  void updatedAt(int? updatedAt) {
    _updatedAt = updatedAt;
  }

  /// Sets whether the user is the owner
  void isOwner(bool? isOwner) {
    _isOwner = isOwner;
  }

  /// Sets the custom title of the user
  void customTitle(String? customTitle) {
    _customTitle = customTitle;
  }

  /// Sets the member since date of the user
  void memberSince(String? memberSince) {
    _memberSince = memberSince;
  }

  /// Sets the route of the user
  void route(String? route) {
    _route = route;
  }

  /// Sets the state of the user
  void state(int? state) {
    _state = state;
  }

  /// Sets the community ID of the user
  void communityId(int? communityId) {
    _communityId = communityId;
  }

  /// Sets the created timestamp of the user
  void createdAt(int? createdAt) {
    _createdAt = createdAt;
  }

  /// Sets the widget data of the user
  void widget(LMChatWidgetViewData? widget) {
    _widget = widget;
  }

  /// Sets the roles of the user
  void roles(List<LMChatUserRole>? roles) {
    _roles = roles;
  }

  /// Builds and returns an instance of [LMChatUserViewData]
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
      roles: _roles,
    );
  }
}
