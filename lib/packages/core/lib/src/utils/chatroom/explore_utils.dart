import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// Utility function to map a LMChatSpace to int
int mapLMChatSpacesToInt(LMChatSpace space) {
  switch (space) {
    case LMChatSpace.newest:
      return 0;
    case LMChatSpace.active:
      return 1;
    case LMChatSpace.mostMessages:
      return 2;
    case LMChatSpace.mostParticipants:
      return 3;
  }
}

/// Utility function to get a String representation of a LMChatSpace
String getStateSpace(LMChatSpace space) {
  switch (space) {
    case LMChatSpace.newest:
      return "Newest";
    case LMChatSpace.active:
      return "Recently Active";
    case LMChatSpace.mostParticipants:
      return "Most Participants";
    case LMChatSpace.mostMessages:
      return "Most Messages";
  }
}
