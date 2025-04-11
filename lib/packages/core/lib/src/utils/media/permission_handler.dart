import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

/// Media types:
/// 1 - Photos
/// 2 - Videos
/// 3 - Microphone/Audio
Future<bool> handlePermissions(int mediaType) async {
  if (kIsWeb) {
    return true;
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      return await _handleAndroidPermissions(mediaType);
    } else {
      return await _handleStoragePermission(mediaType);
    }
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return await _handleIOSPermissions(mediaType);
  } else {
    return true;
  }
}

Future<bool> _handleAndroidPermissions(int mediaType) async {
  Permission permission;
  switch (mediaType) {
    case 1:
      permission = Permission.photos;
      break;
    case 2:
      permission = Permission.videos;
      break;
    case 3:
      permission = Permission.microphone;
      break;
    default:
      permission = Permission.storage;
  }
  return await _requestPermission(permission);
}

Future<bool> _handleStoragePermission(int mediaType) async {
  if (mediaType == 3) {
    return await _requestPermission(Permission.microphone);
  }
  return await _requestPermission(Permission.storage);
}

Future<bool> _handleIOSPermissions(int mediaType) async {
  Permission permission;
  switch (mediaType) {
    case 1:
      permission = Permission.photos;
      break;
    case 2:
      permission = Permission.videos;
      break;
    case 3:
      permission = Permission.microphone;
      break;
    default:
      permission = Permission.storage;
  }
  return await _requestPermission(permission);
}

Future<bool> _requestPermission(Permission permission) async {
  if (kIsWeb) return true; // Skip permission_handler on web

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
