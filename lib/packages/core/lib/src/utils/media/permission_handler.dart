import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> handlePermissions(int mediaType) async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      return await _handleAndroidPermissions(mediaType);
    } else {
      return await _handleStoragePermission();
    }
  } else if (Platform.isIOS) {
    return await _handleIOSPermissions(mediaType);
  } else {
    return true;
  }
}

Future<bool> _handleAndroidPermissions(int mediaType) async {
  Permission permission =
      mediaType == 1 ? Permission.photos : Permission.videos;
  return await _requestPermission(permission);
}

Future<bool> _handleStoragePermission() async {
  return await _requestPermission(Permission.storage);
}

Future<bool> _handleIOSPermissions(int mediaType) async {
  Permission permission = mediaType == 1
      ? Permission.photos
      : mediaType == 2
          ? Permission.microphone
          : Permission.videos;
  return await _requestPermission(permission);
}

Future<bool> _requestPermission(Permission permission) async {
  PermissionStatus permissionStatus = await permission.status;
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  } else if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await permission.request();
    return _handlePermissionResponse(permissionStatus);
  }
  return false;
}

bool _handlePermissionResponse(PermissionStatus status) {
  if (status == PermissionStatus.permanentlyDenied) {
    toast(
      'Permissions denied, change app settings',
      duration: Toast.LENGTH_LONG,
    );
    openAppSettings();
    return false;
  }
  return status == PermissionStatus.granted;
}
