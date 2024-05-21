import 'package:likeminds_chat_flutter_core/src/utils/constants/enums.dart';

List<int> getChatroomTypes(LMChatroomType type) {
  List<int> chatrooms = [];
  if (type == LMChatroomType.dm) chatrooms.add(10);
  if (type == LMChatroomType.group) chatrooms.addAll([0, 7]);
  return chatrooms;
}
