import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';

class LMChatRealtime {
  static LMChatRealtime? _instance;
  static LMChatRealtime get instance =>
      _instance ??= LMChatRealtime._internal();

  late final FirebaseDatabase database;
  final int _communityId = LMChatLocalPreference.instance.getCommunityData()!.id;
  int? _chatroomId;

  LMChatRealtime._internal() {
    debugPrint('LMRealtime initialized');
    FirebaseApp app = Firebase.app('likeminds_chat');
    database = FirebaseDatabase.instanceFor(app: app);
    debugPrint("Database is $database");
  }

  set chatroomId(int chatroomId) {
    _chatroomId = chatroomId;
  }

  DatabaseReference homeFeed() {
    return database.ref().child("community").child(_communityId.toString()).ref;
  }

  DatabaseReference chatroom() {
    return database.ref().child("collabcards").child("$_chatroomId").ref;
  }
}
