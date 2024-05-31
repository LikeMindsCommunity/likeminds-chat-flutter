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

  LMChatRoomMemberViewData({
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
}
