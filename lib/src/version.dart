// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  bool operator ==(covariant Version other) {
    if (identical(this, other)) return true;

    return other.major == major && other.minor == minor && other.patch == patch;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;
}
