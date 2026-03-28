// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deviceInfoHash() => r'5978f958d8b8639bc01606b57ccd29eb28ab4f6b';

/// See also [DeviceInfo].
@ProviderFor(DeviceInfo)
final deviceInfoProvider = NotifierProvider<
    DeviceInfo,
    ({
      bool hasVibration,
      bool isSmallScreen,
      PackageInfo? packageInfo
    })>.internal(
  DeviceInfo.new,
  name: r'deviceInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deviceInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeviceInfo = Notifier<
    ({bool hasVibration, bool isSmallScreen, PackageInfo? packageInfo})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
