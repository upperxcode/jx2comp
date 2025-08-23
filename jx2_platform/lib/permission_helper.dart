import 'package:permission_handler/permission_handler.dart';

class Jx2PermissionHelper {
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkPermissionStatus(Permission permission) async {
    var status = await permission.status;
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestMultiplePermissions(List<Permission> permissions) async {
    var statuses = await permissions.request();
    return statuses.values.every((status) => status == PermissionStatus.granted);
  }
}