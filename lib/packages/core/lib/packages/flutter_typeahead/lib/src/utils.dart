import 'package:flutter/foundation.dart';

final supportedPlatform = (kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS);
