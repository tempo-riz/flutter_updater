import 'dart:convert';
import 'dart:io';

import 'package:app_update_helper/src/version.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Version?> getPlayStoreVersion(String packageName) async {
  final uri = Uri.https("play.google.com", "/store/apps/details", {
    "id": packageName,
  });

  try {
    final response = await http.get(uri);

    final String? newVersion = RegExp(
      r',\[\[\["([0-9,\.]*)"]],',
    ).firstMatch(response.body)!.group(1);
    return Version.parse(newVersion!);
  } catch (e) {
    debugPrint("Error fetching version from Play Store: $e");
    return null;
  }
}

Future<Version?> getAppleStoreVersion(String packageName) async {
  var uri = Uri.https("itunes.apple.com", "/lookup", {"bundleId": packageName});
  try {
    final response = await http.get(uri);

    final jsonObj = jsonDecode(response.body);
    final List results = jsonObj['results'];
    if (results.isEmpty) {
      return null;
    }
    return Version.parse(jsonObj['results'][0]['version']);
  } catch (e) {
    debugPrint("Error fetching version from Apple Store: $e");
    return null;
  }
}

Future<Version?> fetchStoreVersion(String packageName) async {
  if (Platform.isAndroid) {
    return getPlayStoreVersion(packageName);
  } else if (Platform.isIOS) {
    return getAppleStoreVersion(packageName);
  }
  throw UnsupportedError(
    "This method is only supported on iOS and Android platforms.",
  );
}

Future<PackageInfo> getPackageInfo() async {
  WidgetsFlutterBinding.ensureInitialized(); // so we dont need to wait runApp

  return await PackageInfo.fromPlatform();
}

void openIosPage(String iosAppId) {
  launchUrl(Uri.parse("https://apps.apple.com/app/id$iosAppId"));
}

void openAndroidPage() async {
  final info = await getPackageInfo();
  final packageName = info.packageName;

  launchUrl(
    Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
  );
}
