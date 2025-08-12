import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_update_helper_method_channel.dart';

abstract class AppUpdateHelperPlatform extends PlatformInterface {
  /// Constructs a AppUpdateHelperPlatform.
  AppUpdateHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppUpdateHelperPlatform _instance = MethodChannelAppUpdateHelper();

  /// The default instance of [AppUpdateHelperPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppUpdateHelper].
  static AppUpdateHelperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppUpdateHelperPlatform] when
  /// they register themselves.
  static set instance(AppUpdateHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
