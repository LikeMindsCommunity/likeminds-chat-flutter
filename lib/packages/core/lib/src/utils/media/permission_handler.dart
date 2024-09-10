import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> handlePermissions(int mediaType) async {
  if (Platform.isAndroid) {
    PermissionStatus permissionStatus;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      if (mediaType == 1) {
        permissionStatus = await Permission.photos.status;
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          permissionStatus = await Permission.photos.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            toast(
              'Permissions denied, change app settings',
              duration: Toast.LENGTH_LONG,
            );
            openAppSettings();
            return false;
          } else if (permissionStatus == PermissionStatus.granted) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        permissionStatus = await Permission.videos.status;
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          permissionStatus = await Permission.videos.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            toast(
              'Permissions denied, change app settings',
              duration: Toast.LENGTH_LONG,
            );
            openAppSettings();
            return false;
          } else if (permissionStatus == PermissionStatus.granted) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      permissionStatus = await Permission.storage.status;
      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else {
        permissionStatus = await Permission.storage.request();
        if (permissionStatus == PermissionStatus.granted) {
          return true;
        } else if (permissionStatus == PermissionStatus.denied) {
          return false;
        } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
          toast(
            'Permissions denied, change app settings',
            duration: Toast.LENGTH_LONG,
          );
          openAppSettings();
          return false;
        }
      }
    }
  } else {
    return true;
  }
  return true;
}
