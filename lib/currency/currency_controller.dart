import 'package:get/get.dart';
import 'package:theme_desiree/currency/currency_model.dart';

class CurrencyController extends GetConnect implements GetxService {
  final RxList<CurrencyModel> currencies = <CurrencyModel>[].obs;
  final Rx<CurrencyModel?> selectedCurrency = Rx<CurrencyModel?>(null);
  @override
  void onInit() {
    super.onInit();
    loadCurrency();
  }

  final String apiUrl = "https://api.npoint.io/35db23252bd4643b2f36";

  Future<void> loadCurrency() async {
    try {
      final response = await get(apiUrl);
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data['currencies'] is List) {
          List<CurrencyModel> respCurrency = (data['currencies'] as List)
              .map((item) => CurrencyModel(
                    code: item['code'] ?? '',
                    symbol: item['symbol'] ?? '',
                    name: item['name'] ?? '',
                    rate: (item['exchange_rate_to_usd'] as num?)?.toDouble() ??
                        1.0,
                    isPayable: item['is_payable'] ?? false,
                  ))
              .toList();
          currencies.assignAll(respCurrency);
          selectedCurrency.value ??= currencies.first;
        } else {
          print("Invalid currencies data format");
        }
      } else {
        print("Failed to fetch rates: ${response.statusText}");
      }
    } catch (e) {
      print("Error fetching rates: $e");
    }
  }

  void selectCurrency(CurrencyModel newCurrency) {
    selectedCurrency.value = newCurrency;
  }

  String formatCurrency(double amount) {
    final selected = selectedCurrency.value;
    if (selected == null) {
      return amount % 1 == 0
          ? amount.toInt().toString()
          : amount.toStringAsFixed(2).toString();
    } else {
      double convertedAmount = amount * selected.rate;
      return convertedAmount % 1 == 0
          ? "${selected.symbol} ${convertedAmount.toInt()}"
          : "${selected.symbol} ${convertedAmount.toStringAsFixed(2)}";
    }
  }
}
