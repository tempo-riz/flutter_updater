<!-- 
dart format .
flutter pub publish --dry-run
-->

## Getting Started


Simply call the `checkForUpdates` function to check for updates and handle them accordingly.

```dart
final update = await AppUpdateHelper.checkForUpdates();
```

Then you can use the `update` function to update the app. (Or ideally let your user choose)

```dart
// if you only care about major updates
if (update.isMajor) AppUpdateHelper.update();

// you can also use a switch on the update type
enum UpdateType { none, major, minor, patch }

// if patch and multiple of 3 (who am I to judge?)
if (update.isPatch && update.newVersion.patch % 3 == 0) AppUpdateHelper.update();
```

For ios you must provide the iosAppId when calling the `update` function:

```dart
AppUpdateHelper.update(iosAppId: "YOUR_IOS_APP_ID");
```

you can find your iOS app id in the App Store URL of your app, for example: `https://apps.apple.com/app/idYOUR_IOS_APP_ID`.