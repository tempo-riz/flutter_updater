import 'dart:io';

import 'package:app_update_helper/update.dart';
import 'package:app_update_helper/utils.dart';
import 'package:app_update_helper/version.dart';
import 'package:flutter/widgets.dart';

import 'app_update_helper_platform_interface.dart';

export 'package:app_update_helper/update.dart';

class AppUpdateHelper {
  AppUpdateHelper._();

  /// Check for updates and return the update information.
  static Future<Update?> checkForUpdate() async {
    try {
      final info = await getPackageInfo();

      final Version currentVersion = Version.parse(info.version);
      Version? newVersion = await fetchStoreVersion(info.packageName);

      if (newVersion == null) {
        debugPrint("Could not fetch the latest version.");
        return null;
      }

      if (currentVersion == newVersion) return null; // No update available

      return Update(currentVersion, newVersion);
    } catch (e) {
      debugPrint("Error checking for updates: $e");
      return null;
    }
  }

  /// Open the play store/app store to the app page.
  ///
  /// you must provide the `iosAppId` for iOS updates.
  static void update({String? iosAppId}) async {
    if (Platform.isIOS) {
      if (iosAppId == null) {
        throw ArgumentError("iosAppId must be provided for iOS updates.");
      }
      openIosPage(iosAppId);
    } else if (Platform.isAndroid) {
      if (await AppUpdateHelperPlatform.instance.canUpdate()) {
        try {
          AppUpdateHelperPlatform.instance.update();
        } catch (e) {
          openAndroidPage();
        }
      } else {
        openAndroidPage();
      }
    } else {
      throw UnsupportedError(
        "This method is only supported on iOS and Android platforms.",
      );
    }
  }
}
