class Totals {
  final num subtotal;
  final num vat;
  final num deliveryCharge;
  final num total;
  Totals({
    required this.subtotal,
    required this.vat,
    required this.deliveryCharge,
    required this.total,
  });
  factory Totals.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return Totals(subtotal: 0, vat: 0, deliveryCharge: 0, total: 0);
    }

    num parseNum(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value;
      if (value is String) return num.tryParse(value) ?? 0;
      return 0;
    }

    return Totals(
      subtotal: parseNum(json['subtotal']),
      vat: parseNum(json['tax']),
      deliveryCharge: parseNum(json['deliveryCharge']),
      total: parseNum(json['grandTotal']),
    );
  }
}
