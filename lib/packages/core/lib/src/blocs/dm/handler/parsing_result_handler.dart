part of '../dm_bloc.dart';

/// Function to parse the response object into List<LMChatRoomViewData>
List<LMChatRoomViewData> parseDMResponse(GetHomeFeedResponse response) {
  return parseDMHomeFeedToChatrooms(response);
}

/// Function to parse response, and update child models
List<LMChatRoomViewData> parseDMHomeFeedToChatrooms(
  GetHomeFeedResponse response,
) {
  final List<LMChatRoomViewData> chatrooms = response.chatroomsData!.map(
    //Convert chatroom model to LMChatRoomViewData
    (chatroom) {
      LMChatRoomViewData chatroomViewData = chatroom.toChatRoomViewData();
      chatroomViewData = parseDMLastConversation(response, chatroomViewData);
      chatroomViewData = parseDMChatroomUsers(response, chatroomViewData);
      chatroomViewData = parseDMAttachments(response, chatroomViewData);
      return chatroomViewData;
    },
  ).toList();
  //Returns a list of LMChatRoomViewData with all models
  return chatrooms;
}

/// Fucntion to parse chatroom users from response user meta
LMChatRoomViewData parseDMChatroomUsers(
  GetHomeFeedResponse response,
  LMChatRoomViewData chatroom,
) {
  //Convert user model to LMChatUserViewData
  final Map<int, LMChatUserViewData> users = response.userMeta!.map(
    (key, value) => MapEntry(key, value.toUserViewData()),
  );
  //Extract users from users list using IDs
  LMChatUserViewData chatroomUser = users[chatroom.userId]!;
  LMChatUserViewData chatroomWithUser = users[chatroom.chatroomWithUserId]!;
  //Return a copy of passed chatroom with chatroom users updated
  return chatroom.copyWith(
    chatroomWithUser: chatroomWithUser,
    member: chatroomUser,
  );
}

/// Function to parse the last conversation for this chatroom from conversationMeta
LMChatRoomViewData parseDMLastConversation(
  GetHomeFeedResponse response,
  LMChatRoomViewData chatroom,
) {
  //Convert last conversation from response to viewData
  LMChatConversationViewData? lastConversation = response
      .conversationMeta![chatroom.lastConversationId.toString()]!
      .toConversationViewData();
  //Create a new instance with member object copied
  LMChatConversationViewData updated = lastConversation.copyWith(
      member: response.userMeta != null &&
              response.userMeta![lastConversation.memberId] != null
          ? response.userMeta![lastConversation.memberId]!.toUserViewData()
          : null);
  //Return a copy of passed chatroom with lastConversation updated
  return chatroom.copyWith(lastConversation: updated);
}

/// Function to parse attachments from the response object
LMChatRoomViewData parseDMAttachments(
    GetHomeFeedResponse response, LMChatRoomViewData chatroom) {
  // Assuming response.conversationAttachmentsMeta is a map of attachment data
  final Map<String, List<Attachment>>? attachmentData =
      response.conversationAttachmentsMeta;

  // Check if the attachment data exists
  if (attachmentData != null) {
    // Retrieve the last conversation ID from the chatroom
    String lastConversationId = chatroom.lastConversationId.toString();

    // Check if there are attachments for the last conversation ID
    if (attachmentData.containsKey(lastConversationId)) {
      // Create a list to hold the parsed attachments
      List<LMChatAttachmentViewData> attachments = [];

      // Iterate through each entry in the attachment data for the specific conversation
      for (Attachment item in attachmentData[lastConversationId]!) {
        // Convert each attachment entry to LMChatAttachmentViewData
        LMChatAttachmentViewData attachment = item.toAttachmentViewData();
        attachments.add(attachment);
      }

      // Return a copy of the chatroom with the attachments updated
      return chatroom.copyWith(attachments: attachments);
    }
  }

  // If no attachments are found, return the chatroom unchanged
  return chatroom;
}
