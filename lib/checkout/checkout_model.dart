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

class DeliveryChargeModel {
  final String id;
  final bool isDefault;
  final int charge;
  final String name; // Display name

  DeliveryChargeModel({
    required this.id,
    required this.isDefault,
    required this.charge,
    required this.name,
  });

  factory DeliveryChargeModel.fromJson(Map<String, dynamic> json) {
    // Name = regionName / Default Delivery
    String displayName = json['regionName'] ??
        (json['isDefault'] == true ? 'Default Delivery' : ' ');

    return DeliveryChargeModel(
      id: json['_id'],
      isDefault: json['isDefault'] ?? false,
      charge: json['charge'] ?? 0,
      name: displayName,
    );
  }
}

// class DeliveryChargeModel {
//    final String id;
//   final bool isDefault;
//   final int charge;
//   final String name;

//   DeliveryChargeModel({
//      required this.id,
//     required this.isDefault,
//     required this.charge,
//     required this.name,
   
//   });

//    factory DeliveryChargeModel.fromJson(Map<String, dynamic> json) {
//     // Name = chargeBasedOn / regi removed text
//     String displayName = json['regi'] ?? (json['isDefault'] == true ? 'Default' : 'Unnamed');
//     return DeliveryChargeModel(
//       id: json['_id'],
//       isDefault: json['isDefault'] ?? false,
//       charge: json['charge'] ?? 0,
//       name: displayName,
//     );
//   }
// }


