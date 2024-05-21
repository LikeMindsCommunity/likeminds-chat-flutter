import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/app.dart';
import 'package:likeminds_chat_flutter_sample/environment/env.dart';
import 'package:likeminds_chat_flutter_sample/storybook/storybook.dart';

/// Flutter flavour/environment manager v0.0.1
const isDebug = bool.fromEnvironment('DEBUG');

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LMChatCore.instance.initialize(
    apiKey: "b3a5e07d-85c4-4d8d-9ec0-ca07e841b35b",
  );
  runApp(const LMChatSampleApp());
}
