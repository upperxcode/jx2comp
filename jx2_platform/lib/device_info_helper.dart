import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'enums/platform_type.dart';

class Jx2DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceDetails() async {
    try {
      final platform = _getPlatformType();
      
      switch (platform) {
        case Jx2PlatformType.web:
          return _getWebDeviceInfo(await _deviceInfo.webBrowserInfo);
        case Jx2PlatformType.android:
          return _getAndroidDeviceInfo(await _deviceInfo.androidInfo);
        case Jx2PlatformType.ios:
          return _getIosDeviceInfo(await _deviceInfo.iosInfo);
        case Jx2PlatformType.linux:
          return _getLinuxDeviceInfo(await _deviceInfo.linuxInfo);
        case Jx2PlatformType.windows:
          return _getWindowsDeviceInfo(await _deviceInfo.windowsInfo);
        case Jx2PlatformType.macOS:
          return _getMacOsDeviceInfo(await _deviceInfo.macOsInfo);
        case Jx2PlatformType.fuchsia:
          return {'platform': 'fuchsia'};
      }
    } catch (e) {
      return {
        'error': 'Falha ao obter informações do dispositivo',
        'exception': e.toString()
      };
    }
  }

  static Jx2PlatformType _getPlatformType() {
    if (kIsWeb) return Jx2PlatformType.web;
    
    if (Platform.isAndroid) return Jx2PlatformType.android;
    if (Platform.isIOS) return Jx2PlatformType.ios;
    if (Platform.isLinux) return Jx2PlatformType.linux;
    if (Platform.isWindows) return Jx2PlatformType.windows;
    if (Platform.isMacOS) return Jx2PlatformType.macOS;
    if (Platform.isFuchsia) return Jx2PlatformType.fuchsia;
    
    throw UnsupportedError('Plataforma não suportada');
  }

  static Map<String, dynamic> _getWebDeviceInfo(WebBrowserInfo info) {
    return {
      'platform': 'web',
      'browserName': info.browserName.name,
      'userAgent': info.userAgent,
      'language': info.language,
    };
  }

  static Map<String, dynamic> _getAndroidDeviceInfo(AndroidDeviceInfo info) {
    return {
      'platform': 'android',
      'model': info.model,
      'brand': info.brand,
      'version': info.version.release,
      'sdkVersion': info.version.sdkInt,
      'isPhysicalDevice': info.isPhysicalDevice,
    };
  }

  static Map<String, dynamic> _getIosDeviceInfo(IosDeviceInfo info) {
    return {
      'platform': 'ios',
      'model': info.model,
      'name': info.name,
      'systemVersion': info.systemVersion,
      'isPhysicalDevice': info.isPhysicalDevice,
    };
  }

  static Map<String, dynamic> _getLinuxDeviceInfo(LinuxDeviceInfo info) {
    return {
      'platform': 'linux',
      'name': info.name,
      'version': info.version,
    };
  }

  static Map<String, dynamic> _getWindowsDeviceInfo(WindowsDeviceInfo info) {
    return {
      'platform': 'windows',
      'computerName': info.computerName,
      'osVersion': info.displayVersion,
    };
  }

  static Map<String, dynamic> _getMacOsDeviceInfo(MacOsDeviceInfo info) {
    return {
      'platform': 'macos',
      'computerName': info.computerName,
      'osVersion': info.kernelVersion,
    };
  }
}