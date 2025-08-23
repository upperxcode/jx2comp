import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'enums/platform_type.dart';

class Jx2PlatformHelper {
  static Jx2PlatformType getCurrentPlatform() {
    if (kIsWeb) return Jx2PlatformType.web;
    
    if (Platform.isAndroid) return Jx2PlatformType.android;
    if (Platform.isIOS) return Jx2PlatformType.ios;
    if (Platform.isLinux) return Jx2PlatformType.linux;
    if (Platform.isWindows) return Jx2PlatformType.windows;
    if (Platform.isMacOS) return Jx2PlatformType.macOS;
    if (Platform.isFuchsia) return Jx2PlatformType.fuchsia;
    
    throw UnsupportedError('Plataforma não suportada');
  }

  static bool get isMobile => 
    [Jx2PlatformType.android, Jx2PlatformType.ios]
      .contains(getCurrentPlatform());
  
  static bool get isDesktop => 
    [
      Jx2PlatformType.linux, 
      Jx2PlatformType.windows, 
      Jx2PlatformType.macOS
    ].contains(getCurrentPlatform());

  static bool get isWeb => getCurrentPlatform() == Jx2PlatformType.web;

  static String getPlatformName() {
    return getCurrentPlatform().toString().split('.').last;
  }
}