class VersionDTO {
  final String currentVersion;

  VersionDTO({required this.currentVersion});

  // Convert JSON to Version object
  factory VersionDTO.fromJson(Map<String, dynamic> json) {
    return VersionDTO(
      currentVersion: json['current_version'] ?? '',
    );
  }

  // Convert Version object to JSON
  Map<String, dynamic> toJson() {
    return {
      'current_version': currentVersion,
    };
  }
}