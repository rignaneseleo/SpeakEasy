import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';

part 'device_provider.g.dart';

@Riverpod(keepAlive: true)
class DeviceInfo extends _$DeviceInfo {
  @override
  ({bool hasVibration, bool isSmallScreen, PackageInfo? packageInfo}) build() {
    return (hasVibration: false, isSmallScreen: false, packageInfo: null);
  }

  Future<void> initialize() async {
    bool vibration;
    if (kIsWeb) {
      vibration = false;
    } else {
      vibration = await Vibration.hasVibrator() == true;
    }
    final info = await PackageInfo.fromPlatform();
    state = (
      hasVibration: vibration,
      isSmallScreen: state.isSmallScreen,
      packageInfo: info
    );
  }

  void setSmallScreen(bool value) {
    state = (
      hasVibration: state.hasVibration,
      isSmallScreen: value,
      packageInfo: state.packageInfo
    );
  }
}
