class ContactInfo {
  final String data;
  final bool isVerified;

  ContactInfo({
    required this.data,
    required this.isVerified,
  });

  /// CopyWith method to create a modified copy of ContactInfo
  ContactInfo copyWith({
    String? data,
    bool? isVerified,
  }) {
    return ContactInfo(
      data: data ?? this.data,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  /// Create a ContactInfo object from a Map
  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      data: map['data'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }

  /// Convert ContactInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'isVerified': isVerified,
    };
  }
}
