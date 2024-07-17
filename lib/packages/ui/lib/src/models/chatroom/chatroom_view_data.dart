import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

/// `LMChatRoomViewData` is a model class that holds the data for the chat room view.
/// This class is used to display the chat room information in the chat screen.
class LMChatRoomViewData {
  /// [bool] access is used to check if the user has access to the chat room.
  final bool? access;

  /// [String] answerText is used to store the answer text.
  final String? answerText;

  /// [int] answersCount is used to store the count of answers.
  final int? answersCount;

  /// [int] attachmentCount is used to store the count of attachments.
  final int? attachmentCount;

  /// [List<LMChatAttachmentViewData>] attachments is used to store the attachments.
  final List<LMChatAttachmentViewData> attachments;

  /// [bool] attachmentsUploaded is used to check if the attachments are uploaded.
  final bool? attachmentsUploaded;

  /// [int] attendingCount is used to store the count of attendees.
  final int? attendingCount;

  /// [bool] attendingStatus is used to check if the user is attending the event.
  final bool? attendingStatus;

  /// The number of audio files in the chatroom.
  final int? audioCount;

  /// The list of audio files in the chatroom.
  final List<dynamic>? audios;

  /// Indicates if the auto follow action has been completed.
  final bool? autoFollowDone;

  /// The creation time of the chatroom card.
  final String? cardCreationTime;

  /// The ID of the community associated with the chatroom.
  final int? communityId;

  /// The name of the community associated with the chatroom.
  final String? communityName;

  /// The timestamp when the chatroom was created.
  final dynamic createdAt;

  /// The ID of the last conversation in the chatroom.
  final int? lastConversationId;

  /// The date of the chatroom.
  final String? date;

  /// The URL of the chatroom image.
  final String? chatroomImageUrl;

  /// The number of unseen messages in the chatroom.
  final int? unseenCount;

  /// The epoch time of the date.
  final int? dateEpoch;

  /// The timestamp of the date.
  final int? dateTime;

  /// The duration of the chatroom.
  final int? duration;

  /// Indicates the follow status of the chatroom.
  final bool? followStatus;

  /// Indicates if the chatroom has event recordings.
  final bool? hasEventRecording;

  /// The header of the chatroom.
  final String header;

  /// The ID of the chatroom.
  final int id;

  /// The number of image files in the chatroom.
  final int? imageCount;

  /// The list of image files in the chatroom.
  final List<dynamic>? images;

  /// Indicates if members will be included later in the chatroom.
  final bool? includeMembersLater;

  /// Indicates if the chatroom has been edited.
  final bool? isEdited;

  /// Indicates if the user is a guest in the chatroom.
  bool? isGuest;

  /// Indicates if the chatroom is paid.
  final bool? isPaid;

  /// Indicates if the chatroom is pending.
  final bool? isPending;

  /// Indicates if the chatroom is private.
  final bool? isPrivate;

  /// Indicates if the user is a private member of the chatroom.
  final bool? isPrivateMember;

  /// Indicates if the chatroom is secret.
  final bool? isSecret;

  /// Indicates if the chatroom is tagged.
  final bool? isTagged;

  /// Indicates if the chatroom is pinned.
  final bool? isPinned;

  /// The member associated with the chatroom.
  final LMChatUserViewData? member;

  /// The topic of the chatroom.
  final LMChatConversationViewData? topic;

  /// Indicates the mute status of the chatroom.
  final bool? muteStatus;

  /// The number of seconds before the online link is enabled.
  final int? onlineLinkEnableBefore;

  /// The type of online link.
  final dynamic onlineLinkType;

  /// The list of PDF files in the chatroom.
  final List<dynamic>? pdf;

  /// The number of PDF files in the chatroom.
  final int? pdfCount;

  /// The number of polls in the chatroom.
  final int? pollsCount;

  /// The list of reactions in the chatroom.
  final List<dynamic>? reactions;

  /// Indicates if the user has left the secret chatroom.
  final bool? secretChatroomLeft;

  /// The share link of the chatroom.
  final String? shareLink;

  /// The state of the chatroom.
  final int? state;

  /// The title of the chatroom.
  final String title;

  /// The type of the chatroom.
  final int? type;

  /// The number of video files in the chatroom.
  final int? videoCount;

  /// The list of video files in the chatroom.
  final List<dynamic>? videos;

  /// The number of participants in the chatroom.
  final int? participantCount;

  /// The total count of responses in the chatroom.
  final int? totalResponseCount;

  /// Indicates if the external user has seen the chatroom.
  final bool? externalSeen;

  /// Indicates if a member can send messages in the chatroom.
  final bool? memberCanMessage;

  /// The state of the chat request.
  final int? chatRequestState;

  /// The user who requested the chat.
  final LMChatUserViewData? chatRequestedBy;

  /// The ID of the user who requested the chat.
  final int? chatRequestedById;

  /// The user with whom the chatroom is created.
  final LMChatUserViewData? chatroomWithUser;

  /// The ID of the user with whom the chatroom is created.
  final int? chatroomWithUserId;

  /// The ID of the user.
  final int? userId;

  /// The list of members who responded last in the chatroom.
  final List<LMChatUserViewData>? lastResponseMembers;

  final LMChatConversationViewData? lastConversation;

  LMChatRoomViewData._({
    required this.access,
    required this.answerText,
    required this.answersCount,
    required this.attachmentCount,
    required this.attachments,
    required this.attachmentsUploaded,
    required this.attendingCount,
    required this.attendingStatus,
    required this.audioCount,
    required this.audios,
    required this.autoFollowDone,
    required this.cardCreationTime,
    required this.communityId,
    required this.communityName,
    required this.createdAt,
    required this.lastConversationId,
    required this.date,
    required this.chatroomImageUrl,
    required this.unseenCount,
    required this.dateEpoch,
    required this.dateTime,
    required this.duration,
    required this.hasEventRecording,
    required this.header,
    required this.id,
    required this.imageCount,
    required this.images,
    required this.includeMembersLater,
    required this.isEdited,
    required this.isPaid,
    required this.isPending,
    required this.isPrivate,
    required this.isPrivateMember,
    required this.isSecret,
    required this.isTagged,
    required this.isPinned,
    required this.member,
    required this.topic,
    required this.muteStatus,
    required this.onlineLinkEnableBefore,
    required this.onlineLinkType,
    required this.pdf,
    required this.pdfCount,
    required this.pollsCount,
    required this.reactions,
    required this.secretChatroomLeft,
    required this.shareLink,
    required this.state,
    required this.title,
    required this.type,
    required this.videoCount,
    required this.videos,
    required this.participantCount,
    required this.totalResponseCount,
    required this.memberCanMessage,
    required this.chatRequestState,
    required this.chatRequestedBy,
    required this.chatRequestedById,
    required this.chatroomWithUser,
    required this.chatroomWithUserId,
    required this.userId,
    required this.lastResponseMembers,
    required this.externalSeen,
    required this.isGuest,
    required this.followStatus,
    required this.lastConversation,
  });

  /// copyWith method is used to create a new instance of `LMChatRoomViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatRoomViewData copyWith({
    bool? access,
    String? answerText,
    int? answersCount,
    int? attachmentCount,
    List<LMChatAttachmentViewData>? attachments,
    bool? attachmentsUploaded,
    int? attendingCount,
    bool? attendingStatus,
    int? audioCount,
    List<dynamic>? audios,
    bool? autoFollowDone,
    String? cardCreationTime,
    int? communityId,
    String? communityName,
    dynamic createdAt,
    int? lastConversationId,
    String? date,
    String? chatroomImageUrl,
    int? unseenCount,
    int? dateEpoch,
    int? dateTime,
    int? duration,
    bool? followStatus,
    bool? hasEventRecording,
    String? header,
    int? id,
    int? imageCount,
    List<dynamic>? images,
    bool? includeMembersLater,
    bool? isEdited,
    bool? isGuest,
    bool? isPaid,
    bool? isPending,
    bool? isPrivate,
    bool? isPrivateMember,
    bool? isSecret,
    bool? isTagged,
    bool? isPinned,
    LMChatUserViewData? member,
    LMChatConversationViewData? topic,
    bool? muteStatus,
    int? onlineLinkEnableBefore,
    dynamic onlineLinkType,
    List<dynamic>? pdf,
    int? pdfCount,
    int? pollsCount,
    List<dynamic>? reactions,
    bool? secretChatroomLeft,
    String? shareLink,
    int? state,
    String? title,
    int? type,
    int? videoCount,
    List<dynamic>? videos,
    int? participantCount,
    int? totalResponseCount,
    bool? externalSeen,
    bool? memberCanMessage,
    int? chatRequestState,
    LMChatUserViewData? chatRequestedBy,
    int? chatRequestedById,
    LMChatUserViewData? chatroomWithUser,
    int? chatroomWithUserId,
    int? userId,
    List<LMChatUserViewData>? lastResponseMembers,
    LMChatConversationViewData? lastConversation,
  }) {
    return LMChatRoomViewData._(
      followStatus: followStatus ?? this.followStatus,
      access: access ?? this.access,
      answerText: answerText ?? this.answerText,
      answersCount: answersCount ?? this.answersCount,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      attachments: attachments ?? this.attachments,
      attachmentsUploaded: attachmentsUploaded ?? this.attachmentsUploaded,
      attendingCount: attendingCount ?? this.attendingCount,
      attendingStatus: attendingStatus ?? this.attendingStatus,
      audioCount: audioCount ?? this.audioCount,
      audios: audios ?? this.audios,
      autoFollowDone: autoFollowDone ?? this.autoFollowDone,
      cardCreationTime: cardCreationTime ?? this.cardCreationTime,
      communityId: communityId ?? this.communityId,
      communityName: communityName ?? this.communityName,
      createdAt: createdAt ?? this.createdAt,
      lastConversationId: lastConversationId ?? this.lastConversationId,
      date: date ?? this.date,
      chatroomImageUrl: chatroomImageUrl ?? this.chatroomImageUrl,
      unseenCount: unseenCount ?? this.unseenCount,
      dateEpoch: dateEpoch ?? this.dateEpoch,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      hasEventRecording: hasEventRecording ?? this.hasEventRecording,
      header: header ?? this.header,
      id: id ?? this.id,
      imageCount: imageCount ?? this.imageCount,
      images: images ?? this.images,
      includeMembersLater: includeMembersLater ?? this.includeMembersLater,
      isEdited: isEdited ?? this.isEdited,
      isGuest: isGuest ?? this.isGuest,
      isPaid: isPaid ?? this.isPaid,
      isPending: isPending ?? this.isPending,
      isPrivate: isPrivate ?? this.isPrivate,
      isPrivateMember: isPrivateMember ?? this.isPrivateMember,
      isSecret: isSecret ?? this.isSecret,
      isTagged: isTagged ?? this.isTagged,
      isPinned: isPinned ?? this.isPinned,
      member: member ?? this.member,
      topic: topic ?? this.topic,
      muteStatus: muteStatus ?? this.muteStatus,
      onlineLinkEnableBefore:
          onlineLinkEnableBefore ?? this.onlineLinkEnableBefore,
      onlineLinkType: onlineLinkType ?? this.onlineLinkType,
      pdf: pdf ?? this.pdf,
      pdfCount: pdfCount ?? this.pdfCount,
      pollsCount: pollsCount ?? this.pollsCount,
      reactions: reactions ?? this.reactions,
      secretChatroomLeft: secretChatroomLeft ?? this.secretChatroomLeft,
      shareLink: shareLink ?? this.shareLink,
      state: state ?? this.state,
      title: title ?? this.title,
      type: type ?? this.type,
      videoCount: videoCount ?? this.videoCount,
      videos: videos ?? this.videos,
      participantCount: participantCount ?? this.participantCount,
      totalResponseCount: totalResponseCount ?? this.totalResponseCount,
      externalSeen: externalSeen ?? this.externalSeen,
      memberCanMessage: memberCanMessage ?? this.memberCanMessage,
      chatRequestState: chatRequestState ?? this.chatRequestState,
      chatRequestedBy: chatRequestedBy ?? this.chatRequestedBy,
      chatRequestedById: chatRequestedById ?? this.chatRequestedById,
      chatroomWithUser: chatroomWithUser ?? this.chatroomWithUser,
      chatroomWithUserId: chatroomWithUserId ?? this.chatroomWithUserId,
      userId: userId ?? this.userId,
      lastResponseMembers: lastResponseMembers ?? this.lastResponseMembers,
      lastConversation: lastConversation ?? this.lastConversation,
    );
  }
}

/// `LMChatRoomViewDataBuilder` is a builder class that is used to create an instance of `LMChatRoomViewData`.
/// This class is used to create an instance of `LMChatRoomViewData` with the provided values.
class LMChatRoomViewDataBuilder {
  bool? _access;
  String? _answerText;
  int? _answersCount;
  int? _attachmentCount;
  List<LMChatAttachmentViewData> _attachments = [];
  bool? _attachmentsUploaded;
  int? _attendingCount;
  bool? _attendingStatus;
  int? _audioCount;
  List<dynamic>? _audios;
  bool? _autoFollowDone;
  String? _cardCreationTime;
  int? _communityId;
  String? _communityName;
  dynamic _createdAt;
  int? _lastConversationId;
  String? _date;
  String? _chatroomImageUrl;
  int? _unseenCount;
  int? _dateEpoch;
  int? _dateTime;
  int? _duration;
  bool? _followStatus;
  bool? _hasEventRecording;
  String _header = '';
  int _id = 0;
  int? _imageCount;
  List<dynamic>? _images;
  bool? _includeMembersLater;
  bool? _isEdited;
  bool? _isGuest;
  bool? _isPaid;
  bool? _isPending;
  bool? _isPrivate;
  bool? _isPrivateMember;
  bool? _isSecret;
  bool? _isTagged;
  bool? _isPinned;
  LMChatUserViewData? _member;
  LMChatConversationViewData? _topic;
  bool? _muteStatus;
  int? _onlineLinkEnableBefore;
  dynamic _onlineLinkType;
  List<dynamic>? _pdf;
  int? _pdfCount;
  int? _pollsCount;
  List<dynamic>? _reactions;
  bool? _secretChatroomLeft;
  String? _shareLink;
  int? _state;
  String _title = '';
  int? _type;
  int? _videoCount;
  List<dynamic>? _videos;
  int? _participantCount;
  int? _totalResponseCount;
  bool? _externalSeen;
  bool? _memberCanMessage;
  int? _chatRequestState;
  LMChatUserViewData? _chatRequestedBy;
  int? _chatRequestedById;
  LMChatUserViewData? _chatroomWithUser;
  int? _chatroomWithUserId;
  int? _userId;
  List<LMChatUserViewData>? _lastResponseMembers;
  LMChatConversationViewData? _lastConversation;

  /// Sets the access status of the chatroom.
  void access(bool? access) {
    _access = access;
  }

  /// Sets the answer text of the chatroom.
  void answerText(String? answerText) {
    _answerText = answerText;
  }

  /// Sets the count of answers in the chatroom.
  void answersCount(int? answersCount) {
    _answersCount = answersCount;
  }

  /// Sets the count of attachments in the chatroom.
  void attachmentCount(int? attachmentCount) {
    _attachmentCount = attachmentCount;
  }

  /// Sets the attachments of the chatroom.
  void attachment(List<LMChatAttachmentViewData> attachment) {
    _attachments = attachment;
  }

  /// Sets the status of attachments uploaded in the chatroom.
  void attachmentsUploaded(bool? attachmentsUploaded) {
    _attachmentsUploaded = attachmentsUploaded;
  }

  /// Sets the count of attendees in the chatroom.
  void attendingCount(int? attendingCount) {
    _attendingCount = attendingCount;
  }

  /// Sets the attending status of the chatroom.
  void attendingStatus(bool? attendingStatus) {
    _attendingStatus = attendingStatus;
  }

  /// Sets the count of audio files in the chatroom.
  void audioCount(int? audioCount) {
    _audioCount = audioCount;
  }

  /// Sets the audio files of the chatroom.
  void audio(List<dynamic>? audio) {
    _audios = audio;
  }

  /// Sets the status of auto follow done in the chatroom.
  void autoFollowDone(bool? autoFollowDone) {
    _autoFollowDone = autoFollowDone;
  }

  /// Sets the creation time of the chatroom card.
  void cardCreationTime(String? cardCreationTime) {
    _cardCreationTime = cardCreationTime;
  }

  /// Sets the ID of the community associated with the chatroom.
  void communityId(int? communityId) {
    _communityId = communityId;
  }

  /// Sets the name of the community associated with the chatroom.
  void communityName(String? communityName) {
    _communityName = communityName;
  }

  /// Sets the creation date of the chatroom.
  void createdAt(dynamic createdAt) {
    _createdAt = createdAt;
  }

  /// Sets the ID of the last conversation in the chatroom.
  void lastConversationId(int? lastConversationId) {
    _lastConversationId = lastConversationId;
  }

  /// Sets the date of the chatroom.
  void date(String? date) {
    _date = date;
  }

  /// Sets the image URL of the chatroom.
  void chatroomImageUrl(String? chatroomImageUrl) {
    _chatroomImageUrl = chatroomImageUrl;
  }

  /// Sets the count of unseen messages in the chatroom.
  void unseenCount(int? unseenCount) {
    _unseenCount = unseenCount;
  }

  /// Sets the epoch date of the chatroom.
  void dateEpoch(int? dateEpoch) {
    _dateEpoch = dateEpoch;
  }

  /// Sets the date and time of the chatroom.
  void dateTime(int? dateTime) {
    _dateTime = dateTime;
  }

  /// Sets the duration of the chatroom.
  void duration(int? duration) {
    _duration = duration;
  }

  /// Sets the follow status of the chatroom.
  void followStatus(bool? followStatus) {
    _followStatus = followStatus;
  }

  /// Sets the status of event recording in the chatroom.
  void hasEventRecording(bool? hasEventRecording) {
    _hasEventRecording = hasEventRecording;
  }

  /// Sets the header of the chatroom.
  void header(String header) {
    _header = header;
  }

  /// Sets the ID of the chatroom.
  void id(int id) {
    _id = id;
  }

  /// Sets the count of images in the chatroom.
  void imageCount(int? imageCount) {
    _imageCount = imageCount;
  }

  /// Sets the images of the chatroom.
  void image(List<dynamic>? images) {
    _images = images;
  }

  /// Sets the status of including members later in the chatroom.
  void includeMembersLater(bool? includeMembersLater) {
    _includeMembersLater = includeMembersLater;
  }

  /// Sets the edited status of the chatroom.
  void isEdited(bool? isEdited) {
    _isEdited = isEdited;
  }

  /// Sets the guest status of the chatroom.
  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  /// Sets the paid status of the chatroom.
  void isPaid(bool? isPaid) {
    _isPaid = isPaid;
  }

  /// Sets the pending status of the chatroom.
  void isPending(bool? isPending) {
    _isPending = isPending;
  }

  /// Sets the private status of the chatroom.
  void isPrivate(bool? isPrivate) {
    _isPrivate = isPrivate;
  }

  /// Sets the private member status of the chatroom.
  void isPrivateMember(bool? isPrivateMember) {
    _isPrivateMember = isPrivateMember;
  }

  /// Sets the secret status of the chatroom.
  void isSecret(bool? isSecret) {
    _isSecret = isSecret;
  }

  /// Sets the tagged status of the chatroom.
  void isTagged(bool? isTagged) {
    _isTagged = isTagged;
  }

  /// Sets the pinned status of the chatroom.
  void isPinned(bool? isPinned) {
    _isPinned = isPinned;
  }

  /// Sets the member of the chatroom.
  void member(LMChatUserViewData? member) {
    _member = member;
  }

  /// Sets the topic of the chatroom.
  void topic(LMChatConversationViewData? topic) {
    _topic = topic;
  }

  /// Sets the mute status of the chatroom.
  void muteStatus(bool? muteStatus) {
    _muteStatus = muteStatus;
  }

  /// Sets the time before online link enable in the chatroom.
  void onlineLinkEnableBefore(int? onlineLinkEnableBefore) {
    _onlineLinkEnableBefore = onlineLinkEnableBefore;
  }

  /// Sets the type of online link in the chatroom.
  void onlineLinkType(dynamic onlineLinkType) {
    _onlineLinkType = onlineLinkType;
  }

  /// Sets the PDF files of the chatroom.
  void pdf(List<dynamic> pdf) {
    _pdf = pdf;
  }

  /// Sets the count of PDF files in the chatroom.
  void pdfCount(int? pdfCount) {
    _pdfCount = pdfCount;
  }

  /// Sets the count of polls in the chatroom.
  void pollsCount(int? pollsCount) {
    _pollsCount = pollsCount;
  }

  /// Sets the reactions in the chatroom.
  void veaction(List<dynamic>? reactions) {
    _reactions = reactions;
  }

  /// Sets the status of leaving a secret chatroom.
  void secretChatroomLeft(bool? secretChatroomLeft) {
    _secretChatroomLeft = secretChatroomLeft;
  }

  /// Sets the share link of the chatroom.
  void shareLink(String? shareLink) {
    _shareLink = shareLink;
  }

  /// Sets the state of the chatroom.
  void state(int? state) {
    _state = state;
  }

  /// Sets the title of the chatroom.
  void title(String title) {
    _title = title;
  }

  /// Sets the type of the chatroom.
  void type(int? type) {
    _type = type;
  }

  /// Sets the count of videos in the chatroom.
  void videoCount(int? videoCount) {
    _videoCount = videoCount;
  }

  /// Sets the videos of the chatroom.
  void video(List<dynamic>? videos) {
    _videos = videos;
  }

  /// Sets the count of participants in the chatroom.
  void participantCount(int? participantCount) {
    _participantCount = participantCount;
  }

  /// Sets the total count of responses in the chatroom.
  void totalResponseCount(int? totalResponseCount) {
    _totalResponseCount = totalResponseCount;
  }

  /// Sets the external seen status of the chatroom.
  void externalSeen(bool? externalSeen) {
    _externalSeen = externalSeen;
  }

  /// Sets the member can message status of the chatroom.
  void memberCanMessage(bool? memberCanMessage) {
    _memberCanMessage = memberCanMessage;
  }

  /// Sets the state of the chat request in the chatroom.
  void chatRequestState(int? chatRequestState) {
    _chatRequestState = chatRequestState;
  }

  /// Sets the user who requested the chat in the chatroom.
  void chatRequestedBy(LMChatUserViewData? chatRequestedBy) {
    _chatRequestedBy = chatRequestedBy;
  }

  /// Sets the ID of the user who requested the chat in the chatroom.
  void chatRequestedById(int? chatRequestedById) {
    _chatRequestedById = chatRequestedById;
  }

  /// Sets the user with whom the chatroom is associated.
  void chatroomWithUser(LMChatUserViewData? chatroomWithUser) {
    _chatroomWithUser = chatroomWithUser;
  }

  /// Sets the ID of the user with whom the chatroom is associated.
  void chatroomWithUserId(int? chatroomWithUserId) {
    _chatroomWithUserId = chatroomWithUserId;
  }

  /// Sets the ID of the user in the chatroom.
  void userId(int? userId) {
    _userId = userId;
  }

  /// Sets the last response members in the chatroom.
  void lastResponseMember(List<LMChatUserViewData>? members) {
    _lastResponseMembers = members;
  }

  /// Sets the last conversation in the chatroom.
  void lastConversation(LMChatConversationViewData? lastConversation) {
    _lastConversation = lastConversation;
  }

  LMChatRoomViewData build() {
    return LMChatRoomViewData._(
      access: _access,
      answerText: _answerText,
      answersCount: _answersCount,
      attachmentCount: _attachmentCount,
      attachments: _attachments,
      attachmentsUploaded: _attachmentsUploaded,
      attendingCount: _attendingCount,
      attendingStatus: _attendingStatus,
      audioCount: _audioCount,
      audios: _audios,
      autoFollowDone: _autoFollowDone,
      cardCreationTime: _cardCreationTime,
      communityId: _communityId,
      communityName: _communityName,
      createdAt: _createdAt,
      lastConversationId: _lastConversationId,
      date: _date,
      chatroomImageUrl: _chatroomImageUrl,
      unseenCount: _unseenCount,
      dateEpoch: _dateEpoch,
      dateTime: _dateTime,
      duration: _duration,
      hasEventRecording: _hasEventRecording,
      header: _header,
      id: _id,
      imageCount: _imageCount,
      images: _images,
      includeMembersLater: _includeMembersLater,
      isEdited: _isEdited,
      isPaid: _isPaid,
      isPending: _isPending,
      isPrivate: _isPrivate,
      isPrivateMember: _isPrivateMember,
      isSecret: _isSecret,
      isTagged: _isTagged,
      isPinned: _isPinned,
      member: _member,
      topic: _topic,
      muteStatus: _muteStatus,
      onlineLinkEnableBefore: _onlineLinkEnableBefore,
      onlineLinkType: _onlineLinkType,
      pdf: _pdf,
      pdfCount: _pdfCount,
      pollsCount: _pollsCount,
      reactions: _reactions,
      secretChatroomLeft: _secretChatroomLeft,
      shareLink: _shareLink,
      state: _state,
      title: _title,
      type: _type,
      videoCount: _videoCount,
      videos: _videos,
      participantCount: _participantCount,
      totalResponseCount: _totalResponseCount,
      memberCanMessage: _memberCanMessage,
      chatRequestState: _chatRequestState,
      chatRequestedBy: _chatRequestedBy,
      chatRequestedById: _chatRequestedById,
      chatroomWithUser: _chatroomWithUser,
      chatroomWithUserId: _chatroomWithUserId,
      userId: _userId,
      lastResponseMembers: _lastResponseMembers,
      externalSeen: _externalSeen,
      isGuest: _isGuest,
      followStatus: _followStatus,
      lastConversation: _lastConversation,
    );
  }
}
