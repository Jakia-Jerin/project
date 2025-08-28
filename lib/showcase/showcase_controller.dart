import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/showcase/product_model.dart';

import 'dart:convert';

class ShowcaseController extends GetxController {
//  var product = Rxn<ProductModel>();
  var isLoading = false.obs;
  var hasError = false.obs;
  var selectedVariant = Rxn<VariantModel>();
  final Rx<ProductModel?> product = Rx<ProductModel?>(null);

  Future<void> fetchProductByID(String productId) async {
    if (productId.isEmpty) {
      hasError.value = true;
      print("Error: productId is empty");
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await http.get(
        Uri.parse("https://app2.apidoxy.com/api/v1/products/$productId"),
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Content-Type": "application/json",
        },
      );
      print("Response body: ${response.body}"); // debug

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // এখন data একটি Map
        if (body['success'] == true &&
            body['data'] != null &&
            body['data'] is Map) {
          final productData = body['data'];
          product.value = ProductModel.fromJson(productData);
          for (var v in product.value!.variants) {
            print("Variant id: ${v.id}, options: ${v.options}");
          }
          if (product.value != null && product.value!.variants.isNotEmpty) {
            selectedVariant.value = product.value!.variants.first;
          }
        } else {
          hasError.value = true;
          print("Error: API returned no product data");
        }
      } else {
        hasError.value = true;
        print("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      hasError.value = true;
      print("Error fetching product: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final productId = Get.parameters['productId'] ?? '';
    if (productId.isNotEmpty) fetchProductByID(productId);
  }

  // Future<void> fetchProductbyID(String productId) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await get(
  //       "https://app2.apidoxy.com/api/v1/products/details/{productId}",
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         //   "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final body = response.body;

  //       if (body is Map<String, dynamic> &&
  //           body['success'] == true &&
  //           body['data'] != null &&
  //           body['data'] is List &&
  //           (body['data'] as List).isNotEmpty) {
  //         final firstProduct = body['data'][0]; // first element of list
  //         product.value = ProductModel.fromJson(firstProduct);
  //         //   body['success'] == true &&
  //         //   body['data'] != null) {
  //         // product.value = ProductModel.fromJson(body['data']);

  //         // প্রথম variant auto select করবে
  //         if (product.value != null && product.value!.variants.isNotEmpty) {
  //           selectedVariant.value = product.value!.variants.first;
  //         }
  //         print("status code: ${response.statusCode}");
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching product: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // // Removed initState() as it's not applicable for GetxService/GetConnect.
  // // To fetch product on controller initialization, use onInit() instead:

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProductbyID(Get.parameters['productID'] ?? "");
  // }

  // Future<void> fetchProduct(String? id) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final response = await get("https://api.npoint.io/bd71758417920fd0a243");

  //     if (response.statusCode == 200) {
  //       final data = response.body;

  //       if (data is Map<String, dynamic>) {
  //         product.value = ProductModel.fromJson(data);
  //         if (product.value != null && product.value!.variants.isNotEmpty) {
  //           selectedVariant.value = product.value!.variants.first;
  //         }
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching product: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
