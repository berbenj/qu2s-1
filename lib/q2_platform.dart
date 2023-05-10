import 'package:flutter/foundation.dart';

class Q2Platform {
  bool _isWeb = false;
  bool _isAndroid = false;
  bool _isIOs = false;
  bool _isWindows = false;
  bool _isMacOs = false;
  bool _isLinux = false;

  /// [forcePlatform] can be one of "web", "android", "ios", "windows", "macos", "linux",
  /// and it will be converted to lowercase
  Q2Platform({String? forcePlatform}) {
    if (forcePlatform == null) {
      _isWeb = kIsWeb;
      _isAndroid = defaultTargetPlatform == TargetPlatform.android;
      _isIOs = defaultTargetPlatform == TargetPlatform.iOS;
      _isWindows = defaultTargetPlatform == TargetPlatform.windows;
      _isMacOs = defaultTargetPlatform == TargetPlatform.macOS;
      _isLinux = defaultTargetPlatform == TargetPlatform.linux;
    } else {
      switch (forcePlatform.toLowerCase()) {
        case "web":
          _isWeb = true;
          break;
        case "android":
          _isAndroid = true;
          break;
        case "ios":
          _isIOs = true;
          break;
        case "windows":
          _isWindows = true;
          break;
        case "macos":
          _isMacOs = true;
          break;
        case "linux":
          _isLinux = true;
          break;
        default:
          break;
      }
    }
  }

  bool get isWeb => _isWeb;
  bool get isAndroid => _isAndroid;
  bool get isIOs => _isIOs;
  bool get isWindows => _isWindows;
  bool get isMacOs => _isMacOs;
  bool get isLinux => _isLinux;
}
