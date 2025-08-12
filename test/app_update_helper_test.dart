import 'package:flutter_test/flutter_test.dart';
import 'package:app_update_helper/app_update_helper.dart';
import 'package:app_update_helper/app_update_helper_platform_interface.dart';
import 'package:app_update_helper/app_update_helper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppUpdateHelperPlatform
    with MockPlatformInterfaceMixin
    implements AppUpdateHelperPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppUpdateHelperPlatform initialPlatform = AppUpdateHelperPlatform.instance;

  test('$MethodChannelAppUpdateHelper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppUpdateHelper>());
  });

  test('getPlatformVersion', () async {
    AppUpdateHelper appUpdateHelperPlugin = AppUpdateHelper();
    MockAppUpdateHelperPlatform fakePlatform = MockAppUpdateHelperPlatform();
    AppUpdateHelperPlatform.instance = fakePlatform;

    expect(await appUpdateHelperPlugin.getPlatformVersion(), '42');
  });
}
