import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/address/address_controller.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';
import 'package:theme_desiree/profile/profile_controller.dart';

class CheckoutController extends GetConnect implements GetxService {
  final addressController = Get.put(AddressController());

  final profileController = Get.put(ProfileController());
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
    required num total,
    // required List<Product> products,
    // required String shippingMethod, // e.g. "standard"
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

    final body = {
      "shippingAddress": {
        "street": addr.line1,
        "city": addr.district,
        "state": addr.region,
        "postalCode": addr.postcode,
        "country": addr.country.isNotEmpty ? addr.country : " ",
        "name": profileController.profile.value?.name ?? "",
        "phone": addr.phone,
      },
      "deliveryOptionId": deliveryId, //
      "paymentMethod": paymentMethod,
      "total": total,

      // "products": products.map((p) => p.toJson()).toList(),
    };

    print(" Request Body: ${jsonEncode(body)}");

    try {
      final box = GetStorage();
      final accessToken = box.read("accessToken");
      print("Token from storage: $accessToken");

      final url = "$baseUrl/api/v1/order";
      print(" API URL: $url");

      final headers = {
        "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
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
        print("✅ Order placed successfully!");
        Get.snackbar('Success', 'Order placed successfully');
        // Optionally: cart clear or navigate to orders screen
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
