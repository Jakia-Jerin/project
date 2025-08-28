import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/product_mini_card.dart';

class ProductCollageController extends GetConnect implements GetxService {
  var products = <ProductMiniCardModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  Future<void> fetchProducts({
    String q = "",
    int page = 1,
    int limit = 20,
    String sortBy = "createdAt",
    String sortOrder = "desc",
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final uri = Uri.https(
        "app2.apidoxy.com", // host
        "/api/v1/products", // path
      );

      final response = await http.get(
        uri,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          //     "x-vendor-identifier": "cmeiegymh0000m8vh8me2bkzw",
          "Content-Type": "application/json",
        },
      );
      print("headers: ${response.headers}");

      print("Response body: ${response.body}"); // debug

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final tempProducts = (body['data'] as List)
              .map((e) => ProductMiniCardModel.fromJson(e))
              .toList();
          products.assignAll(tempProducts);
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("status code: ${e.toString()}");
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  // Future<void> fromJson(Map<String, dynamic> json) async {
  //   try {
  //     isLoading.value = true;
  //     if (json['error'] == false && (json['data'] is List)) {
  //       final tempProducts = (json['data'] as List)
  //           .map(
  //             (item) => ProductMiniCardModel.fromJson(item),
  //           )
  //           .toList();
  //       products.assignAll(tempProducts);
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
