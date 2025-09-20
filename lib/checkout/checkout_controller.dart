import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/address/address_controller.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/orders/orders_controller.dart';
import 'package:theme_desiree/profile/profile_controller.dart';

class CheckoutController extends GetConnect implements GetxService {
  final addressController = Get.put(AddressController());

  final profileController = Get.put(ProfileController());
  final cartController = Get.put(CartController());
  final currencyController = Get.put(CurrencyController());
  final orderController = Get.put(OrdersController());
  var deliveryCharges = <DeliveryChargeModel>[].obs;
  var selectedDeliveryId = ''.obs;

  var paymentMethods = <PaymentModel>[].obs;
  var selectedMethod = Rxn<PaymentModel>();
  var hasError = false.obs;
  var isLoading = false.obs;
  @override
  final String baseUrl = "https://app2.apidoxy.com";

  Future<void> getDeliveryCharges() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/settings/delivery-charge"),
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final chargesJson = data['deliveryCharges'] as List;
          deliveryCharges.assignAll(
            chargesJson.map((e) => DeliveryChargeModel.fromJson(e)).toList(),
          );

          // Default select
          final defaultCharge = deliveryCharges.firstWhere(
            (c) => c.isDefault,
            orElse: () => deliveryCharges.first,
          );
          selectedDeliveryId.value = defaultCharge.id;

          print("Delivery Charges Loaded: $chargesJson");
        } else {
          Get.snackbar('Error', 'Failed to load delivery charges');
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectDelivery(String id) {
    selectedDeliveryId.value = id;
  }

  DeliveryChargeModel? get selectedCharge {
    return deliveryCharges
        .firstWhereOrNull((e) => e.id == selectedDeliveryId.value);
  }

  @override
  void onInit() {
    super.onInit();
    getDeliveryCharges();
  }

  Future<void> placeOrder({
    required String paymentMethod,
  }) async {
    final addr = addressController.selectedAddress.value;

    if (addr == null) {
      Get.snackbar('Error', 'Please select a shipping address');
      return;
    }

    final deliveryId = selectedDeliveryId.value;

    if (deliveryId.isEmpty) {
      Get.snackbar('Error', 'Please select a delivery option');
      return;
    }

    final user = await profileController.fetchUserProfile();
    final vendorId = dotenv.env['SHOP_ID'] ?? "";

    // Backend expects a List<String> but with only the first variant
    /// Convert product variants to correct request format

    // Prepare items list
    final itemsList = cartController.products
        .map((item) => {
              "cartItemId": item.cartItemId,
              "productId": item.productId,
              "variants": item.Variantsbody(),
              //       "variantId": item.variantId,
              //     "variantId": item.variantId ?? "",
              "quantity": item.quantity,
              "price": {
                "basePrice": item.price ?? 0,
                "currency": "BDT", // per-item price
              },
              "total": item.subtotal,
              // "subtotal": item.subtotal,
              "title": item.title,

              "option": item.options,
              //  "isAvailable": item.isAvailable,
            })
        .toList();

    // Prepare totals object
    final totalsObj = {
      "subtotal": cartController.totals.value.subtotal,
      // "discount": cartController.totals.value.total,
      "tax": cartController.totals.value.vat,
      "deliveryCharge": cartController.totals.value.deliveryCharge,
      "grandTotal": cartController.totals.value.total,
    };

    // Prepare request body
    final body = {
      "shop": vendorId,
      "cartId": cartController.cartId.value,
      "items": itemsList,
      "shippingAddress": {
        "street": addr.line1,
        "city": addr.district,
        "state": addr.region,
        "postalCode": addr.postcode,
        "country": addr.country.isNotEmpty ? addr.country : " ",
        "name": profileController.profile.value?.name ?? "",
        "phone": addr.phone,
      },
      "deliveryOptionId": deliveryId,
      "paymentMethod": paymentMethod,
      "totals": totalsObj,
    };

    print("Request Body: ${jsonEncode(body)}");

    try {
      final box = GetStorage();
      final accessToken = box.read("accessToken");
      print("Token from storage: $accessToken");

      final url = "https://app2.apidoxy.com/api/v1/order";
      print("API URL: $url");

      final headers = {
        "x-vendor-identifier": vendorId,
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      };

      print("📌 Headers: $headers");

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📩 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final cartData = jsonDecode(response.body);
        print("🛒 Current Cart: $cartData");
        print("✅ Order placed successfully!");
        Fluttertoast.showToast(
          msg: "Successfully Ordered ",
          backgroundColor: Colors.green,
        );
        //   Get.snackbar('Success', 'Order placed successfully');

        await cartController.getUserCart();

        // 3 second delay before fetching orders
        await Future.delayed(Duration(seconds: 3));

        await orderController.fetchOrders();
        Get.toNamed('settings/orders');
        // Optionally clear cart or navigate to orders screen
      } else {
        print("❌ Failed: ${response.body}");
        Get.snackbar('Error', 'Failed: ${response.body}');
      }
    } catch (e, stackTrace) {
      print("❌ Exception: $e");
      print("🛠️ Stacktrace: $stackTrace");
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getPaymentMethods();
//     });
//   }

//   Future<void> getPaymentMethods() async {
//     try {
//       isLoading.value = true;
//       final response = await get("https://api.npoint.io/7176158aa029d9bb272a");
//       if (response.statusCode == 200) {
//         final data = response.body;
//         if (data is Map && data['methods'] is List) {
//           List<PaymentModel> methods = (data['methods'] as List<dynamic>)
//               .map(
//                   (item) => PaymentModel.fromJson(item as Map<String, dynamic>))
//               .toList();

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             paymentMethods.assignAll(methods);
//             selectedMethod.value =
//                 paymentMethods.isNotEmpty ? paymentMethods.first : null;
//           });
//         } else {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             selectedMethod.value = null;
//             hasError.value = true;
//           });
//         }
//       } else {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           selectedMethod.value = null;
//           hasError.value = true;
//         });
//       }
//     } catch (e) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         selectedMethod.value = null;
//         hasError.value = true;
//       });
//       print("Error fetching payment methods: $e");
//     } finally {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         isLoading.value = false;

//         print("Loaded payment methods: ${paymentMethods.length}");
//       });
//     }
//   }
// }

//https://api.npoint.io/2350945f767f77258132
