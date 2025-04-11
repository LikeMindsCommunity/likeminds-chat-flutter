import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/firebase/firebase_credentials.dart';

/// Initializes Firebase with appropriate configuration based on platform and environment
initFirebase() async {
  try {
    // final clientFirebase = Firebase.app();
    final ourFirebase = await Firebase.initializeApp(
      name: 'likeminds_chat',
      options: !isDebug
          ? kIsWeb
              ? FirebaseOptions(
                  apiKey: FbCredsProd.fbApiKeyWeb,
                  appId: FbCredsProd.fbAppIdWeb,
                  messagingSenderId: FbCredsProd.fbMessagingSenderId,
                  projectId: FbCredsProd.fbProjectId,
                  databaseURL: FbCredsProd.fbDatabaseUrl,
                )
              : defaultTargetPlatform == TargetPlatform.iOS
                  ? FirebaseOptions(
                      apiKey: FbCredsProd.fbApiKeyIOS,
                      appId: FbCredsProd.fbAppIdIOS,
                      messagingSenderId: FbCredsProd.fbMessagingSenderId,
                      projectId: FbCredsProd.fbProjectId,
                      databaseURL: FbCredsProd.fbDatabaseUrl,
                    )
                  : FirebaseOptions(
                      apiKey: FbCredsProd.fbApiKeyAndroid,
                      appId: FbCredsProd.fbAppIdAN,
                      messagingSenderId: FbCredsProd.fbMessagingSenderId,
                      projectId: FbCredsProd.fbProjectId,
                      databaseURL: FbCredsProd.fbDatabaseUrl,
                    )
          : kIsWeb
              ? FirebaseOptions(
                  apiKey: FbCredsDev.fbApiKeyWeb,
                  appId: FbCredsDev.fbAppIdWeb,
                  messagingSenderId: FbCredsDev.fbMessagingSenderId,
                  projectId: FbCredsDev.fbProjectId,
                  databaseURL: FbCredsDev.fbDatabaseUrl,
                )
              : defaultTargetPlatform == TargetPlatform.iOS
                  ? FirebaseOptions(
                      apiKey: FbCredsDev.fbApiKeyIOS,
                      appId: FbCredsDev.fbAppIdIOS,
                      messagingSenderId: FbCredsDev.fbMessagingSenderId,
                      projectId: FbCredsDev.fbProjectId,
                      databaseURL: FbCredsDev.fbDatabaseUrl,
                    )
                  : FirebaseOptions(
                      apiKey: FbCredsDev.fbApiKeyAndroid,
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
