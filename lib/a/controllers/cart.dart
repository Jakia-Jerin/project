import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/a/models/cart_total.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class CartController extends GetConnect implements GetxService {
  var products = <CartModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var totals = Totals(subtotal: 0, vat: 0, deliveryCharge: 0, total: 0).obs;

  double vat = 50.0;
  double deliveryCharge = 120.0;

  @override
  final String baseUrl = "https://app2.apidoxy.com";
  final AuthController authController = Get.put(AuthController());

  /// Add product to server + local list
  Future<void> addProductToServer(CartModel product, {String? coupon}) async {
    // if (!authController.isLoggedIn.value) {
    //   Get.toNamed('/settings/profile'); // login page
    //   return;
    // }

    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/api/v1/cart/item');
      final box = GetStorage();
      print("Sending Request to: $url");

      // token read
      final accessToken = box.read("accessToken");
      print(" Token from storage: $accessToken");
      final refreshToken = box.read("refreshToken");
      print('$accessToken');
      final response = await http.post(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "productId": product.productId,
          "variantId": product.variantId,
          "quantity": product.quantity,
          if (coupon != null) "coupon": coupon,
        }),
      );
      print("$response");
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        products.add(product);
        //  Get.snackbar("Success", data['message'] ?? "Item added to cart");
        print("Status code: ${response.statusCode}");

        print("Response: $data");
      } else {
        Get.snackbar("Error", data['message'] ?? "Something went wrong");
        print("Response: $data");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add product: $e");
      print("Response: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void handleAddToCart(CartModel product) async {
    if (!authController.isLoggedIn.value) {
      // User not logged in → redirect to login page
      final result = await Get.toNamed('/settings/profile');

      if (authController.isLoggedIn.value) {
        await addProductAfterLogin(product);
      }
    } else {
      await addProductAfterLogin(product);
    }
  }

  Future<void> addProductAfterLogin(CartModel product) async {
    await addProductToServer(product);

    Get.toNamed('/cart'); // বা Get.toNamed('/cart')
  }

  /// Update cart item quantity on server
  Future<void> updateCartItem({
    required String productId,
    String? variantId,
    required int quantity,
    required String action, // "inc" / "dec"
  }) async {
    final token = GetStorage().read("accessToken");

    if (token == null) {
      Get.toNamed('/settings/profile'); // Login page
      return;
    }

    final url =
        Uri.parse("https://app2.apidoxy.com/api/v1/cart/item/$productId");

    try {
      final response = await http.patch(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          if (variantId != null) "variantId": variantId,
          "quantity": quantity,
          "action": action,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print("Status code: ${response.statusCode}");

        print("Response: $data");
        // Optional: update local list or refresh UI
        products.refresh();
      } else {
        print("Status code: ${response.statusCode}");

        print("Response: $data");
        Fluttertoast.showToast(
          msg: data['message'] ?? "Failed to update cart",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Response: $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  ///delete item
  ///
  Future<void> removeCartItem({
    required String productId,
    String? variantId,
  }) async {
    final token = GetStorage().read("accessToken");

    if (token == null) {
      Get.toNamed('/settings/profile'); // Login page
      return;
    }

    // Check if item exists in local list before calling API
    final existingItem = products.firstWhereOrNull(
      (p) => p.productId == productId && p.variantId == variantId,
    );

    if (existingItem == null) {
      Fluttertoast.showToast(
        msg: "Item not found in cart",
        backgroundColor: Colors.orange,
      );
      return;
    }

    final url =
        Uri.parse("https://app2.apidoxy.com/api/v1/cart/item/$productId");

    try {
      final response = await http.delete(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          if (variantId != null) "variantId": variantId,
        }),
      );

      final data = jsonDecode(response.body);
      print("Remove Response: $data");

      if (response.statusCode == 200 && data['success'] == true) {
        // Remove from local list
        products.removeWhere(
            (p) => p.productId == productId && p.variantId == variantId);
        products.refresh();
      } else if (response.statusCode == 404) {
        // Safe handling of 404
        products.removeWhere(
            (p) => p.productId == productId && p.variantId == variantId);
        products.refresh();
        Fluttertoast.showToast(
          msg: "Item was not in server cart, removed locally",
          backgroundColor: Colors.orange,
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Failed to remove item",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
      );
      print("Error removing cart item: $e");
    }
  }

  // Future<void> removeCartItem({
  //   required String productId,
  //   String? variantId,
  // }) async {
  //   final token = GetStorage().read("accessToken");

  //   if (token == null) {
  //     Get.toNamed('/settings/profile'); // Login page
  //     return;
  //   }

  //   final url =
  //       Uri.parse("https://app2.apidoxy.com/api/v1/cart/item/$productId");

  //   try {
  //     final response = await http.delete(
  //       url,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         if (variantId != null) "variantId": variantId,
  //       }),
  //     );

  //     final data = jsonDecode(response.body);
  //     print("Remove Response: $data");

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       // Remove from local list
  //       products.removeWhere(
  //           (p) => p.productId == productId && p.variantId == variantId);
  //       products.refresh();
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: data['message'] ?? "Failed to remove item",
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "Error: $e",
  //       backgroundColor: Colors.red,
  //     );
  //     print("Error removing cart item: $e");
  //   }
  // }

  /// Get user cart from server
  Future<void> getUserCart() async {
    final token = GetStorage().read("accessToken");

    if (token == null) {
      Get.toNamed('/settings/profile'); // redirect to login
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('$baseUrl/api/v1/cart');

    try {
      final response = await http.get(
        url,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final data = jsonDecode(response.body);
      print("Get Cart Response: $data");

      if (response.statusCode == 200 && data['success'] == true) {
        // Extract items
        final items = data['data']['items'] as List<dynamic>;

        // Map items to CartModel
        products.value = items.map((e) => CartModel.fromJson(e)).toList();
        products.refresh();
      } else {
        // Fluttertoast.showToast(
        //   msg: data['message'] ?? "Failed to fetch cart",
        //   backgroundColor: Colors.red,
        // );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching cart: $e",
        backgroundColor: Colors.red,
      );
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // void addProduct({
  //   productId,
  //   variantId,
  //   title,
  //   variant,
  //   image,
  //   quantity = 1,
  //   stock,
  //   price,
  //   isAvailable,
  // }) {
  //   products.add(CartModel(
  //     productId: productId,
  //     variantId: variantId,
  //     title: title,
  //     variant: variant,
  //     image: image,
  //     quantity: quantity,
  //     stock: stock,
  //     price: price,
  //     isAvailable: isAvailable,
  //   ));
  // }

  // Future<void> fetchCartAvailability() async {
  //   isLoading.value = false;
  //   hasError.value = false;

  //   try {
  //     final response = await get("https://api.npoint.io/2bafabe8fcfc20b31aee");
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if (data is Map && data['products'] is List) {
  //         List<CartModel> dataResults = (data['products'] as List)
  //             .map((item) => CartModel.fromJson(item))
  //             .toList();
  //         products.assignAll(dataResults);
  //       }
  //       else {
  //         hasError.value = true;
  //       }
  //     }
  //
  //       else {
  //       hasError.value = true;
  //     }
  //   }
  //
  //
  //    catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  double calculateTotal() {
    double total =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return total + vat + deliveryCharge;
  }

  //Recipt

  double subtotal() {
    double productotal =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return productotal;
  }

  double recipttotal() {
    double productotal =
        products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
    return productotal + vat + deliveryCharge;
  }

  @override
  void onInit() {
    super.onInit();
    getUserCart();
  }
}
