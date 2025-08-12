
import 'app_update_helper_platform_interface.dart';

class AppUpdateHelper {
  Future<String?> getPlatformVersion() {
    return AppUpdateHelperPlatform.instance.getPlatformVersion();
  }
}
