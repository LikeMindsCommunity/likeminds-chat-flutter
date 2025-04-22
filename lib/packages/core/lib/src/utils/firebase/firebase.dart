import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/firebase/firebase_credentials.dart';

initFirebase() async {
  try {
    // final clientFirebase = Firebase.app();
    final ourFirebase = await Firebase.initializeApp(
      name: 'likeminds_chat',
      options: !isDebug
          ?
          kIsWeb?
          //Prod Firebase options
          FirebaseOptions(
            apiKey: FbCredsProd.fbApiKey,
            appId: FbCredsProd.fbAppIdAN,
            messagingSenderId: FbCredsProd.fbMessagingSenderId,
            projectId: FbCredsProd.fbProjectId,
            databaseURL: FbCredsProd.fbDatabaseUrl,
          ):
          //Prod Firebase options
          Platform.isIOS
              ? FirebaseOptions(
                  apiKey: FbCredsProd.fbApiKey,
                  appId: FbCredsProd.fbAppIdIOS,
                  messagingSenderId: FbCredsProd.fbMessagingSenderId,
                  projectId: FbCredsProd.fbProjectId,
                  databaseURL: FbCredsProd.fbDatabaseUrl,
                )
              : FirebaseOptions(
                  apiKey: FbCredsProd.fbApiKey,
                  appId: FbCredsProd.fbAppIdAN,
                  messagingSenderId: FbCredsProd.fbMessagingSenderId,
                  projectId: FbCredsProd.fbProjectId,
                  databaseURL: FbCredsProd.fbDatabaseUrl,
                )
          //Beta Firebase options
          :
          kIsWeb?
          //Beta Firebase options
          FirebaseOptions(
            apiKey: FbCredsDev.fbApiKey,
            appId: FbCredsDev.fbAppIdAN,
            messagingSenderId: FbCredsDev.fbMessagingSenderId,
            projectId: FbCredsDev.fbProjectId,
            databaseURL: FbCredsDev.fbDatabaseUrl,
          ):
          //Beta Firebase options
           Platform.isIOS
              ? FirebaseOptions(
                  apiKey: FbCredsDev.fbApiKey,
                  appId: FbCredsDev.fbAppIdIOS,
                  messagingSenderId: FbCredsDev.fbMessagingSenderId,
                  projectId: FbCredsDev.fbProjectId,
                  databaseURL: FbCredsDev.fbDatabaseUrl,
                )
              : FirebaseOptions(
                  apiKey: FbCredsDev.fbApiKey,
                  appId: FbCredsDev.fbAppIdAN,
                  messagingSenderId: FbCredsDev.fbMessagingSenderId,
                  projectId: FbCredsDev.fbProjectId,
                  databaseURL: FbCredsDev.fbDatabaseUrl,
                ),
    );
    // debugPrint("Client Firebase - ${clientFirebase.options.appId}");
    debugPrint("Our Firebase - ${ourFirebase.options.appId}");
  } on FirebaseException catch (e) {
    debugPrint("Make sure you have initialized firebase, ${e.toString()}");
  }
}
