import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_update_helper_platform_interface.dart';

/// An implementation of [AppUpdateHelperPlatform] that uses method channels.
class MethodChannelAppUpdateHelper extends AppUpdateHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_update_helper');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
