<!-- 
dart format .
flutter pub publish --dry-run
-->

## Getting Started


Simply call the `checkForUpdates` function to check for updates and handle them accordingly.

Then you can use the `update` function to update the app. (Or ideally let your user choose)

```dart
final info = await AppUpdateHelper.checkForUpdates();
if (info == null) return; // No update available

// let's say you want to update only if major/minor
switch (info.updateType) {
  case UpdateType.major:
  case UpdateType.minor:
    AppUpdateHelper.update();
    break;
  case UpdateType.patch:
    debugPrint("Patch Update Available: ${info.newVersion}");
}

// if you only care about major updates
if (info.isMajorUpdate) AppUpdateHelper.update();

// if patch and multiple of 3 (who am I to judge?)
if (info.isPatchUpdate && info.newVersion.patch % 3 == 0) AppUpdateHelper.update();
```

For ios you must provide the iosAppId when calling the `update` function:

```dart
AppUpdateHelper.update(iosAppId: "YOUR_IOS_APP_ID");
```

you can find your iOS app id in the App Store URL of your app, for example: `https://apps.apple.com/app/idYOUR_IOS_APP_ID`.