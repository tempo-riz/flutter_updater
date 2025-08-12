/// Represents a semantic version.
class Version {
  /// The major version number.
  final int major;

  /// The minor version number.
  final int minor;

  /// The patch version number.
  final int patch;

  /// Creates a new [Version] instance.
  Version(this.major, this.minor, this.patch);

  /// Parses a version string in the format "major.minor.patch".
  factory Version.parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid version format');
    }
    final major = int.tryParse(parts[0]) ?? 0;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = int.tryParse(parts[2]) ?? 0;
    return Version(major, minor, patch);
  }

  @override
  String toString() {
    return '$major.$minor.$patch';
  }
}
