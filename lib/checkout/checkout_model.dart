class PaymentModel {
  final String method;
  final String name;
  final String logo;
  final bool active;
  final String url;

  PaymentModel({
    required this.method,
    required this.name,
    required this.logo,
    required this.active,
    required this.url,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      method: json['method'],
      name: json['name'],
      logo: json['logo'],
      active: json['active'],
      url: json['url'],
    );
  }
}


