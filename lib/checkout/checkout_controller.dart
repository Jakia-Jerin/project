import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';

class CheckoutController extends GetConnect implements GetxService {
  var paymentMethods = <PaymentModel>[].obs;
  var selectedMethod = Rxn<PaymentModel>();
  var hasError = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPaymentMethods();
    });
  }

  Future<void> getPaymentMethods() async {
    try {
      isLoading.value = true;
      final response = await get("https://api.npoint.io/7176158aa029d9bb272a");
      if (response.statusCode == 200) {
        final data = response.body;
        if (data is Map && data['methods'] is List) {
          List<PaymentModel> methods = (data['methods'] as List<dynamic>)
              .map(
                  (item) => PaymentModel.fromJson(item as Map<String, dynamic>))
              .toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            paymentMethods.assignAll(methods);
            selectedMethod.value =
                paymentMethods.isNotEmpty ? paymentMethods.first : null;
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            selectedMethod.value = null;
            hasError.value = true;
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          selectedMethod.value = null;
          hasError.value = true;
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedMethod.value = null;
        hasError.value = true;
      });
      print("Error fetching payment methods: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;

        print("Loaded payment methods: ${paymentMethods.length}");
      });
    }
  }
}

//https://api.npoint.io/2350945f767f77258132
