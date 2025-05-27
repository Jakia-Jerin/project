class Specification {
  final String key;
  final String value;
  final String type;

  Specification({required this.key, required this.value, required this.type});

  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(
      key: json['key'],
      value: json['value'],
      type: json['type'],
    );
  }
}