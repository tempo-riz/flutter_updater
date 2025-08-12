import 'package:app_update_helper/version.dart';

enum UpdateType { major, minor, patch }

class Update {
  final Version oldVersion;
  final Version newVersion;

  Update(this.oldVersion, this.newVersion);

  @override
  String toString() {
    return 'Update from $oldVersion to $newVersion (${type.name})';
  }

  UpdateType get type {
    if (newVersion.major > oldVersion.major) {
      return UpdateType.major;
    } else if (newVersion.minor > oldVersion.minor) {
      return UpdateType.minor;
    } else if (newVersion.patch > oldVersion.patch) {
      return UpdateType.patch;
    }
    throw ArgumentError(
      'No update type found between $oldVersion and $newVersion',
    );
  }

  bool get isMajor => type == UpdateType.major;

  bool get isMinor => type == UpdateType.minor;

  bool get isPatch => type == UpdateType.patch;
}
