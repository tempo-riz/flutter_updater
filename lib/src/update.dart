// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  /// Checks if there is any update available.
  bool get isAvailable => type != UpdateType.none;

  /// Checks if the update is either a major or minor update.
  ///
  /// This is the recommanded way to check for significant updates.
  ///
  /// It Means either the app has breaking changes or new features.
  bool get isMajorOrMinor => isMajor || isMinor;

  /// Creates a [Update] instance representing no update available.
  ///
  /// Either with current version or '0.0.0' if version is null or invalid.
  factory Update.none(String? version) {
    final v = Version.parse(version ?? '0.0.0');
    return Update(v, v);
  }

  @override
  bool operator ==(covariant Update other) {
    if (identical(this, other)) return true;

    return other.oldVersion == oldVersion && other.newVersion == newVersion;
  }

  @override
  int get hashCode => oldVersion.hashCode ^ newVersion.hashCode;
}
