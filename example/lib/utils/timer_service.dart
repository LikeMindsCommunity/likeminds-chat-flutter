import 'dart:async';

import 'package:flutter/material.dart';

Timer? timer; // Change to nullable Timer
final ValueNotifier<int> rebuildTimer = ValueNotifier(5);
final ValueNotifier<bool> rebuilChatBar = ValueNotifier(false);

void startTimer() {
  const oneSec = Duration(seconds: 1);
  timer = Timer.periodic(
    oneSec,
    (Timer timer) {
      if (rebuildTimer.value == 0) {
        timer.cancel();
        _rebuild();
      } else {
        rebuildTimer.value--;
      }
    },
  );
}

void _rebuild() {
  rebuilChatBar.value = !rebuilChatBar.value;
}
