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
  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      subtotal: json['subtotal'] ?? 0,
      vat: json['tax'] ?? 0,
      deliveryCharge: json['deliveryCharge'] ?? 0,
      total: json['grandTotal'] ?? 0,
    );
  }
}
