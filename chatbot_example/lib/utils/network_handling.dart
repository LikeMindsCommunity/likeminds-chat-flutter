import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chatbot_flutter_sample/main.dart';

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();

  void initialise() async {
    _networkConnectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        rootScaffoldMessengerKey.currentState?.clearSnackBars();
      } else {
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          confirmationToast(
            content: "No internet\nCheck your connection and try again",
            backgroundColor: const Color.fromARGB(255, 108, 108, 108),
          ),
        );
      }
    });
  }

  void disposeStream() => _controller.close();
}

SnackBar confirmationToast(
    {required String content, required Color backgroundColor}) {
  return SnackBar(
    showCloseIcon: true,
    duration: const Duration(days: 1),
    backgroundColor: backgroundColor,
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    content: Align(
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.left,
      ),
    ),
  );
}
