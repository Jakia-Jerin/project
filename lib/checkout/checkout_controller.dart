import 'package:get/get.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';

class CheckoutController extends GetConnect implements GetxService {
  var paymentMethods = <PaymentModel>[].obs;
  var selectedMethod = Rxn<PaymentModel>();
  var hasError = false.obs;
  var isLoading = false.obs;

  Future<void> getPaymentMethods() async {
    try {
      isLoading.value = true;
      final response = await get("https://api.npoint.io/2350945f767f77258132");
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data['methods'] is List) {
          List<PaymentModel> methods = (data['methods'] as List<dynamic>)
              .map(
                  (item) => PaymentModel.fromJson(item as Map<String, dynamic>))
              .toList();
          paymentMethods.assignAll(methods);
          selectedMethod.value = paymentMethods.first;
        } else {
          selectedMethod.value = null;
          hasError.value = true;
        }
      } else {
        selectedMethod.value = null;
        hasError.value = true;
      }
    } catch (e) {
      selectedMethod.value = null;
      print("Error fetching payment methods: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
      print("Loaded payment methods: ${paymentMethods.length}");
    }
  }
}
