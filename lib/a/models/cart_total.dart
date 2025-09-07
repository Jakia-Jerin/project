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
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      vat: (json['tax'] ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
      total: (json['grandTotal'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'tax': vat,
      'deliveryCharge': deliveryCharge,
      'grandTotal': total,
    };
  }
}
