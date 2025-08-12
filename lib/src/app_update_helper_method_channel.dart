import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_update_helper_platform_interface.dart';

/// An implementation of [AppUpdateHelperPlatform] that uses method channels.
class MethodChannelAppUpdateHelper extends AppUpdateHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_update_helper');

  // we call this only if store version is newer, so should be successful
  @override
  Future<bool> canUpdate() async {
    return await methodChannel.invokeMethod<bool?>('canUpdate') ?? false;
  }

  @override
  void update() {
    methodChannel.invokeMethod('update');
  }
}
