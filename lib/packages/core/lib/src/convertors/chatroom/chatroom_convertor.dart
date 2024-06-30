import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

extension ChatRoomViewDataConvertor on ChatRoom {
  LMChatRoomViewData toChatRoomViewData() {
    final LMChatRoomViewDataBuilder chatRoomBuilder =
        LMChatRoomViewDataBuilder()
          ..access(access)
          ..answerText(answerText)
          ..answersCount(answersCount)
          // ..attachment(attachments)
          ..attachmentCount(attachmentCount)
          ..attachmentsUploaded(attachmentsUploaded)
          ..attendingCount(attendingCount)
          ..attendingStatus(attendingStatus)
          ..audioCount(audioCount)
          // ..audios(audios)
          ..autoFollowDone(autoFollowDone)
          ..cardCreationTime(cardCreationTime)
          ..communityId(communityId)
          ..communityName(communityName)
          ..createdAt(createdAt)
          ..date(date)
          ..dateEpoch(dateEpoch)
          ..dateTime(dateTime)
          ..duration(duration)
          ..lastConversationId(lastConversationId)
          ..followStatus(followStatus)
          ..hasEventRecording(hasEventRecording)
          ..unseenCount(unseenCount)
          ..chatroomImageUrl(chatroomImageUrl)
          ..header(header)
          ..id(id)
          ..imageCount(imageCount)
          // ..images(images)
          ..includeMembersLater(includeMembersLater)
          ..isEdited(isEdited)
          ..isGuest(isGuest)
          ..isPaid(isPaid)
          ..isPending(isPending)
          ..isPrivate(isPrivate)
          ..isPrivateMember(isPrivateMember)
          ..isSecret(isSecret)
          ..isTagged(isTagged)
          // ..member(member)
          // ..topic(topic)
          ..muteStatus(muteStatus)
          ..onlineLinkEnableBefore(onlineLinkEnableBefore)
          ..onlineLinkType(onlineLinkType)
          // ..pdf(pdf)
          ..pdfCount(pdfCount)
          ..pollsCount(pollsCount)
          // ..reactions(reactions)
          ..secretChatroomLeft(secretChatroomLeft)
          ..shareLink(shareLink)
          ..state(state)
          ..title(title)
          ..type(type)
          ..videoCount(videoCount)
          // ..videos(videos)
          ..participantCount(participantCount)
          ..totalResponseCount(totalResponseCount)
          ..isPinned(isPinned)
          ..externalSeen(externalSeen)
          ..chatRequestState(chatRequestState)
          // ..chatRequestedBy(chatRequestedBy)
          ..chatRequestedById(chatRequestedById)
          // ..chatroomWithUser(chatroomWithUser)
          ..chatroomWithUserId(chatroomWithUserId)
          ..userId(userId)
          // ..lastResponseMembers(lastResponseMembers)
          ..memberCanMessage(memberCanMessage);

    return chatRoomBuilder.build();
  }
}

extension ChatRoomConvertor on LMChatRoomViewData {
  ChatRoom toChatRoom() {
   
    return ChatRoom(
      access: access,
      answerText: answerText,
      answersCount: answersCount,
      attachmentCount: attachmentCount,
      attachments: attachments,
      attachmentsUploaded: attachmentsUploaded,
      attendingCount: attendingCount,
      attendingStatus: attendingStatus,
      audioCount: audioCount,
      audios: audios,
      autoFollowDone: autoFollowDone,
      cardCreationTime: cardCreationTime,
      communityId: communityId,
      communityName: communityName,
      createdAt: createdAt,
      date: date,
      dateEpoch: dateEpoch,
      dateTime: dateTime,
      duration: duration,
      lastConversationId: lastConversationId,
      followStatus: followStatus,
      hasEventRecording: hasEventRecording,
      unseenCount: unseenCount,
      chatroomImageUrl: chatroomImageUrl,
      header: header,
      id: id,
      imageCount: imageCount,
      images: images,
      includeMembersLater: includeMembersLater,
      isEdited: isEdited,
      isGuest: isGuest,
      isPaid: isPaid,
      isPending: isPending,
      isPrivate: isPrivate,
      isPrivateMember: isPrivateMember,
      isSecret: isSecret,
      isTagged: isTagged,
      // member: member, //TODO: implement this
      // topic: topic, //TODO: implement this
      muteStatus: muteStatus,
      onlineLinkEnableBefore: onlineLinkEnableBefore,
      onlineLinkType: onlineLinkType,
      pdf: pdf,
      pdfCount: pdfCount,
      pollsCount: pollsCount,
      reactions: reactions,
      secretChatroomLeft: secretChatroomLeft,
      shareLink: shareLink,
      state: state,
      title: title,
      type: type,
      videoCount: videoCount,
      videos: videos,
      participantCount: participantCount,
      totalResponseCount: totalResponseCount,
      isPinned: isPinned,
      externalSeen: externalSeen,
      chatRequestState: chatRequestState,
      // chatRequestedBy: chatRequestedBy,//TODO: implement this
      chatRequestedById: chatRequestedById,
      // chatroomWithUser: chatroomWithUser,//TODO: implement this
      chatroomWithUserId: chatroomWithUserId,
      userId: userId,
      // lastResponseMembers: lastResponseMembers,//TODO: implement this
      memberCanMessage: memberCanMessage,
    );
  }
}
