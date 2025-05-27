class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final bool isPayable;
  final double rate;

  CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.isPayable,
    required this.rate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyModel &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          symbol == other.symbol &&
          name == other.name &&
          rate == other.rate &&
          isPayable == other.isPayable;

  @override
  int get hashCode =>
      code.hashCode ^
      symbol.hashCode ^
      name.hashCode ^
      rate.hashCode ^
      isPayable.hashCode;
}
