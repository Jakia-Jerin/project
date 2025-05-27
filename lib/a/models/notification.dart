class NotificationSettings {
  final String key;
  final String label;
  final bool agree;

  NotificationSettings({
    required this.key,
    required this.label,
    required this.agree,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      key: json['key'],
      label: json['label'],
      agree: json['agree'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'agree': agree,
    };
  }
}
