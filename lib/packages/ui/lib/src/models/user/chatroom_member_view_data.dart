/// `LMChatRoomMemberViewData` is a model class that contains the data for the chat room member view.
/// This class is used to display the chat room member information in the chat screen.
class LMChatRoomMemberViewData {
  final String? customIntroText;
  final String? customTitle;
  final int id;
  final String? imageUrl;
  final bool? isGuest;
  final bool? isOwner;
  final String? memberSince;
  final int? memberSinceEpoch;
  final String name;
  final String? organisationName;
  final String? route;
  final int state;
  final int? updatedAt;
  final String? userUniqueId;

  LMChatRoomMemberViewData._({
    required this.customIntroText,
    required this.customTitle,
    required this.id,
    required this.imageUrl,
    required this.isGuest,
    required this.isOwner,
    required this.memberSince,
    required this.memberSinceEpoch,
    required this.name,
    required this.organisationName,
    required this.route,
    required this.state,
    required this.updatedAt,
    required this.userUniqueId,
  });

  /// copyWith method is used to create a new instance of `LMChatRoomMemberViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatRoomMemberViewData copyWith({
    String? customIntroText,
    String? customTitle,
    int? id,
    String? imageUrl,
    bool? isGuest,
    bool? isOwner,
    String? memberSince,
    int? memberSinceEpoch,
    String? name,
    String? organisationName,
    String? route,
    int? state,
    int? updatedAt,
    String? userUniqueId,
  }) {
    return LMChatRoomMemberViewData._(
      customIntroText: customIntroText ?? this.customIntroText,
      customTitle: customTitle ?? this.customTitle,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      isGuest: isGuest ?? this.isGuest,
      isOwner: isOwner ?? this.isOwner,
      memberSince: memberSince ?? this.memberSince,
      memberSinceEpoch: memberSinceEpoch ?? this.memberSinceEpoch,
      name: name ?? this.name,
      organisationName: organisationName ?? this.organisationName,
      route: route ?? this.route,
      state: state ?? this.state,
      updatedAt: updatedAt ?? this.updatedAt,
      userUniqueId: userUniqueId ?? this.userUniqueId,
    );
  }
}

/// `LMChatRoomMemberViewDataBuilder` is a builder class used to create an instance of `LMChatRoomMemberViewData`.
/// This class is used to create an instance of `LMChatRoomMemberViewData` with the provided values.
class LMChatRoomMemberViewDataBuilder {
  String? _customIntroText;
  String? _customTitle;
  int? _id;
  String? _imageUrl;
  bool? _isGuest;
  bool? _isOwner;
  String? _memberSince;
  int? _memberSinceEpoch;
  String? _name;
  String? _organisationName;
  String? _route;
  int? _state;
  int? _updatedAt;
  String? _userUniqueId;

  void customIntroText(String? customIntroText) {
    _customIntroText = customIntroText;
  }

  void customTitle(String? customTitle) {
    _customTitle = customTitle;
  }

  void id(int? id) {
    _id = id;
  }

  void imageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
  }

  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  void isOwner(bool? isOwner) {
    _isOwner = isOwner;
  }

  void memberSince(String? memberSince) {
    _memberSince = memberSince;
  }

  void memberSinceEpoch(int? memberSinceEpoch) {
    _memberSinceEpoch = memberSinceEpoch;
  }

  void name(String? name) {
    _name = name;
  }

  void organisationName(String? organisationName) {
    _organisationName = organisationName;
  }

  void route(String? route) {
    _route = route;
  }

  void state(int? state) {
    _state = state;
  }

  void updatedAt(int? updatedAt) {
    _updatedAt = updatedAt;
  }

  void userUniqueId(String? userUniqueId) {
    _userUniqueId = userUniqueId;
  }

/// `build` method is used to create an instance of `LMChatRoomMemberViewData`.
/// This method is used to create an instance of `LMChatRoomMemberViewData` with the provided values.
  LMChatRoomMemberViewData build() {
    return LMChatRoomMemberViewData._(
      customIntroText: _customIntroText,
      customTitle: _customTitle,
      id: _id!,
      imageUrl: _imageUrl,
      isGuest: _isGuest,
      isOwner: _isOwner,
      memberSince: _memberSince,
      memberSinceEpoch: _memberSinceEpoch,
      name: _name!,
      organisationName: _organisationName,
      route: _route,
      state: _state!,
      updatedAt: _updatedAt,
      userUniqueId: _userUniqueId,
    );
  }
}
