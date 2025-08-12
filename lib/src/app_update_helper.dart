import 'dart:io';

import 'package:app_update_helper/src/update.dart';
import 'package:app_update_helper/src/utils.dart';
import 'package:app_update_helper/src/version.dart';
import 'package:flutter/widgets.dart';

import 'app_update_helper_platform_interface.dart';

/// A helper class to manage app updates.
class AppUpdateHelper {
  AppUpdateHelper._();

  /// Check for updates and return the current/update version if any.
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

  /// On android use the in-app update API. fallbacks to opening the play store page.
  ///
  /// On iOS open the app store page : you must provide the `iosAppId`.
  static void update({String? iosAppId, bool useInAppUpdate = true}) async {
    if (Platform.isIOS) {
      if (iosAppId == null) {
        throw ArgumentError("iosAppId must be provided for iOS updates.");
      }
      openIosPage(iosAppId);
    } else if (Platform.isAndroid) {
      if (!useInAppUpdate) return openAndroidPage();
      // try in app, fallback store page
      try {
        if (await AppUpdateHelperPlatform.instance.canUpdate()) {
          AppUpdateHelperPlatform.instance.update();
        } else {
          openAndroidPage();
        }
      } catch (e) {
        openAndroidPage();
      }
    } else {
      throw UnsupportedError("This method is only supported on iOS and Android platforms.");
    }
  }
}
