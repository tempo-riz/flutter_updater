import 'package:app_update_helper/src/version.dart';

/// Represents the type of update.
enum UpdateType { none, major, minor, patch }

/// Represents an update between two versions.
class Update {
  /// The old version.
  final Version oldVersion;

  /// The new version.
  final Version newVersion;

  /// Creates a new [Update] instance.
  Update(this.oldVersion, this.newVersion);

  @override
  String toString() {
    return 'Update from $oldVersion to $newVersion (${type.name})';
  }

  /// Gets the type of update.
  UpdateType get type {
    if (newVersion.major > oldVersion.major) {
      return UpdateType.major;
    } else if (newVersion.minor > oldVersion.minor) {
      return UpdateType.minor;
    } else if (newVersion.patch > oldVersion.patch) {
      return UpdateType.patch;
    }
    return UpdateType.none;
  }

  /// Checks if the update is a major update.
  bool get isMajor => type == UpdateType.major;

  /// Checks if the update is a minor update.
  bool get isMinor => type == UpdateType.minor;

  /// Checks if the update is a patch update.
  bool get isPatch => type == UpdateType.patch;

  /// Creates a [Update] instance representing no update available.
  factory Update.none(String version) {
    final v = Version.parse(version);
    return Update(v, v);
  }
}
