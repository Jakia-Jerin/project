import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/a/models/cart_total.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

// class CartController extends GetConnect implements GetxService {
//   var products = <CartModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var cartId = ''.obs;

//   var totals = Totals(subtotal: 0, vat: 0, deliveryCharge: 0, total: 0).obs;

//   double vat = 50.0;
//   double deliveryCharge = 120.0;

//   @override
//   final String baseUrl = "https://app2.apidoxy.com";
//   final AuthController authController = Get.put(AuthController());
//   final vendorId = dotenv.env['SHOP_ID'] ?? "";
//   final selectedVariantIds = <String>[].obs;

//   Future<void> addProductToServer(CartModel product,
//       {String? option, String? shop}) async {
//     isLoading.value = true;
//     try {
//       final url = Uri.parse('$baseUrl/api/v1/cart/item');
//       final box = GetStorage();

//       final accessToken = box.read("accessToken");

//       final requestBody = {
//         "productId": product.productId,
//         if (product.variantId != null) "variantId": product.variantId,
//         "quantity": product.quantity,
//         if (option != null) "option": option,
//         "shop": vendorId,
//       };
//       print("..........................");
//       print(product.variantId);
//       print("Sending Request to: $requestBody");

//       final response = await http.post(
//         url,
//         headers: {
//           "Authorization": "Bearer $accessToken",
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(requestBody),
//       );

//       print("➡️ Request URL: $url");
//       print("➡️ Request Body: $requestBody");
//       print("⬅️ Response (${response.statusCode}): ${response.body}");

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.snackbar("Success", data['message'] ?? "Item added to cart");

//         await getUserCart();
//       } else {
//         Get.snackbar("Error",
//             data['error'] ?? data['message'] ?? "Something went wrong");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to add product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void handleAddToCart(CartModel product,
//       {String? option, String? shop}) async {
//     final showcaseController = Get.find<ShowcaseController>();

//     // combine options string (UI/debug er jonno)
//     final selectedOption = showcaseController.selectedOptions.entries
//         .map((e) => e.value.value)
//         .where((val) => val.isNotEmpty)
//         .join(' > ');

//     print("👉 Selected options string: $selectedOption");

//     // selected variant IDs collect

//     for (var v in showcaseController.product.value?.variants ?? []) {
//       for (var selected in showcaseController.selectedOptions.values) {
//         if (selected.value.isNotEmpty && v.options.contains(selected.value)) {
//           selectedVariantIds.add(v.id);
//           print("✅ Match found: ${selected.value} in variant ${v.id}");
//         }
//       }
//     }

//     print("🎯 Final Selected Variant IDs: $selectedVariantIds");

//     if (selectedVariantIds.isEmpty) {
//       print("⚠️ No matching variants found for $selectedOption");
//       return;
//     }

//     // Call existing logic
//     if (!authController.isLoggedIn.value) {
//       final result = await Get.toNamed('/settings/profile');
//       if (authController.isLoggedIn.value) {
//         await addProductAfterLogin(product, option: selectedOption, shop: shop);
//       }
//     } else {
//       await addProductAfterLogin(product, option: selectedOption, shop: shop);
//     }
//   }

//   // void handleAddToCart(CartModel product,
//   //     {String? option, String? shop}) async {
//   //   if (!authController.isLoggedIn.value) {
//   //     final result = await Get.toNamed('/settings/profile');

//   //     if (authController.isLoggedIn.value) {
//   //       await addProductAfterLogin(product, option: option, shop: shop);
//   //     }
//   //   } else {
//   //     await addProductAfterLogin(product, option: option, shop: shop);
//   //   }
//   // }

//   Future<void> addProductAfterLogin(CartModel product,
//       {String? option, String? shop}) async {
//     await addProductToServer(product, option: option, shop: shop);

//     Get.toNamed('/cart');
//   }

//   /// Get user cart from server

//   Future<void> getUserCart() async {
//     final token = GetStorage().read("accessToken");

//     if (token == null) {
//       Get.toNamed('/settings/profile'); // redirect to login
//       return;
//     }

//     isLoading.value = true;

//     final url = Uri.parse('$baseUrl/api/v1/cart');

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       final data = jsonDecode(response.body);
//       print("Get Cart Response: $data");

//       if (response.statusCode == 200 && data['success'] == true) {
//         final cartData = data['data'];
//         cartId.value = cartData['cartId'] ?? '';

//         // Map items to CartItem
//         final items = (cartData['items'] as List<dynamic>)
//             .map((item) => CartModel.fromJson(item))
//             .toList();

//         for (var item in products) {
//           print(
//               "ProductId: ${item.productId}, VariantId: ${item.variantId}, Name: ${item.variant}, Quantity: ${item.quantity}");
//         }

//         products.value = items;

//         // Extract totals safely
//         final totalsData = cartData['totals'] as Map<String, dynamic>? ?? {};
//         totals.value = Totals(
//           subtotal: (totalsData['subtotal'] ?? 0).toInt(),
//           vat: (totalsData['tax'] ?? 0).toInt(),
//           deliveryCharge: (totalsData['deliveryCharge'] ?? 0).toInt(),
//           total: (totalsData['grandTotal'] ?? 0).toInt(),
//         );

//         products.refresh();
//         print("Cart items: ${products.value}");
//         print("Cart totals: ${totals.value.subtotal}");
//       } else {
//         Fluttertoast.showToast(
//           msg: data['message'] ?? "Failed to fetch cart",
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Error fetching cart: $e",
//         backgroundColor: Colors.red,
//       );
//       print("Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Update cart item quantity on server
//   //

//   Future<void> updateCartItem({
//     required String cartItemId,
//     required String productId,
//     String? variantId,
//     required String action, // "inc" / "dec" / "checked" / "unchecked"
//     int? quantity, // required for "inc"/"dec"
//   }) async {
//     final token = GetStorage().read("accessToken");
//     if (token == null) {
//       Get.toNamed('/settings/profile'); // Login page
//       return;
//     }

//     final url =
//         Uri.parse("https://app2.apidoxy.com/api/v1/cart/item/$productId");

//     try {
//       final body = {
//         "cartItemId": cartItemId,
//         "action": action,
//         if (action == "inc" || action == "dec") "quantity": quantity,
//         if (variantId != null) "variantId": variantId,
//       };

//       final response = await http.patch(
//         url,
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(body),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         print("✅ Cart updated: $data");

//         // Safely map items
//         if (data['data'] != null && data['data']['items'] != null) {
//           final items = (data['data']['items'] as List)
//               .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
//               .toList();

//           // Update your local cart state
//           products.value = items;
//         }

//         Fluttertoast.showToast(
//           msg: data['message'] ?? "Cart updated",
//           backgroundColor: Colors.green,
//         );
//       } else {
//         print("❌ Failed to update cart: $data");
//         Fluttertoast.showToast(
//           msg: data['error'] ?? data['message'] ?? "Failed to update cart",
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       print("❌ Error updating cart: $e");
//       Fluttertoast.showToast(
//         msg: "Error: $e",
//         backgroundColor: Colors.red,
//       );
//     }
//   }
// class CartController extends GetConnect implements GetxService {
//   var products = <CartModel>[].obs;
//   var isLoading = false.obs;
//   var cartId = ''.obs;
//   var totals = Totals(subtotal: 0, vat: 0, deliveryCharge: 0, total: 0).obs;

//   double vat = 50.0;
//   double deliveryCharge = 120.0;
//   @override
//   final String baseUrl = "https://app2.apidoxy.com";

//   final AuthController authController = Get.put(AuthController());
//   final ShowcaseController showcaseController = Get.put(ShowcaseController());
//   final vendorId = dotenv.env['SHOP_ID'] ?? "";
//   final selectedVariantIds = <String>[].obs; // make it observable

//   Future<void> addProductToServer(CartModel product,
//       {String? option, String? shop}) async {
//     isLoading.value = true;
//     try {
//       final url = Uri.parse('$baseUrl/api/v1/cart/item');
//       final box = GetStorage();
//       final accessToken = box.read("accessToken");

//       final variantsBody = <Map<String, dynamic>>[];
//       final showcaseController = Get.find<ShowcaseController>();

//       final currentProductVariants =
//           showcaseController.product.value?.variants ?? [];

//       for (int i = 0; i < currentProductVariants.length; i++) {
//         final v = currentProductVariants[i];
//         final selectedOption = showcaseController.selectedOptions[i]?.value;

//         if (selectedOption != null && selectedOption.isNotEmpty) {
//           variantsBody.add({
//             "id": v.id,
//             "option": selectedOption,
//           });
//         }
//       }
//       print("..........................");
//       final requestBody = {
//         "productId": product.productId,
//         if (variantsBody.isNotEmpty) "variants": variantsBody,
//         "quantity": product.quantity,
//         if (option != null) "option": option,
//         "shop": vendorId,
//       };

//       final response = await http.post(
//         url,
//         headers: {
//           "Authorization": "Bearer $accessToken",
//           "x-vendor-identifier": vendorId,
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(requestBody),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Get.snackbar("Success", data['message'] ?? "Item added to cart");
//         print("data: $data");
//         await getUserCart();
//       } else {
//         print("Failed to add product: $data");
//         Get.snackbar("Error",
//             data['error'] ?? data['message'] ?? "Something went wrong");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to add product: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void handleAddToCart(CartModel product,
//       {String? option, String? shop}) async {
//     final showcaseController = Get.find<ShowcaseController>();

//     // Combine selected options string
//     final selectedOption = showcaseController.selectedOptions.entries
//         .map((e) => e.value.value)
//         .where((val) => val.isNotEmpty)
//         .join(' > ');

//     // Collect selected variant IDs
//     selectedVariantIds.clear();
//     for (var v in showcaseController.product.value?.variants ?? []) {
//       for (var selected in showcaseController.selectedOptions.values) {
//         if (selected.value.isNotEmpty && v.options.contains(selected.value)) {
//           selectedVariantIds.add(v.id);
//         }
//       }
//     }

//     if (selectedVariantIds.isEmpty) return;

//     // Update CartModel
//     final cartItem = product.copy();
//     cartItem.variantId.clear();
//     cartItem.variantId.addAll(selectedVariantIds);

//     // Add actual VariantModel objects for API
//     cartItem.variant.clear();
//     for (var v in showcaseController.product.value!.variants) {
//       if (selectedVariantIds.contains(v.id)) {
//         cartItem.variant.add(v);
//       }
//     }

//     // Call server
//     if (!authController.isLoggedIn.value) {
//       await Get.toNamed('/settings/profile');
//       if (!authController.isLoggedIn.value) return;
//     }

//     await addProductToServer(cartItem, option: selectedOption, shop: shop);
//   }

class CartController extends GetxController {
  var isLoading = false.obs;
  var products = <CartModel>[].obs;
  var cartId = ''.obs;
  //var totals = Totals().obs;
  var totals = Totals(subtotal: 0, vat: 0, deliveryCharge: 0, total: 0).obs;
  double vat = 50.0;
  double deliveryCharge = 120.0;

  @override
  final vendorId = dotenv.env['SHOP_ID'] ?? "";
  //final String baseUrl = "https://app2.apidoxy.com";
  final baseUrl = dotenv.env['BASE_URL'];
  final AuthController authController = Get.put(AuthController());

  Future<void> addProductToServer(CartModel product,
      {String? option, String? shop}) async {
    isLoading.value = true;
    try {
      final url = Uri.parse('$baseUrl/cart/item');
      final box = GetStorage();
      final accessToken = box.read("accessToken");

      final showcaseController = Get.find<ShowcaseController>();
      final currentProductVariants =
          showcaseController.product.value?.variants ?? [];

      print("🛒 Adding to cart: productId=${product.productId}");
      print("🛒 Selected Options Map: ${showcaseController.selectedOptions}");

      final variantsBody = <Map<String, dynamic>>[];
      for (int i = 0; i < currentProductVariants.length; i++) {
        final v = currentProductVariants[i];
        final selectedOption = showcaseController.selectedOptions[i]?.value;
        print(
            "➡️ Checking variant[${v.title}] id=${v.id} selected=$selectedOption");

        if (selectedOption != null && selectedOption.isNotEmpty) {
          variantsBody.add({
            "variantId": v.id,
            "name": v.title,
            "option": selectedOption,
          });
        }
      }

      print("📝 Final variantsBody: $variantsBody");

      final requestBody = {
        "productId": product.productId,
        "variants": variantsBody,
        "quantity": product.quantity,
        if (option != null) "option": option,
        "shop": vendorId,
      };

      print("📤 Request Body: $requestBody");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "x-vendor-identifier": vendorId,
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      final data = jsonDecode(response.body);
      print("📥 API Response: $data");

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar("Success", data['message'] ?? "Item added to cart");
        await getUserCart();
      } else {
        Get.snackbar("Error",
            data['error'] ?? data['message'] ?? "Something went wrong");
      }
    } catch (e) {
      print("❌ Exception in addProductToServer: $e");
      Get.snackbar("Error", "Failed to add product: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void handleAddToCart(CartModel product,
      {String? option, String? shop}) async {
    final showcaseController = Get.find<ShowcaseController>();

    // build option string
    final selectedOption = showcaseController.selectedOptions.entries
        .map((e) => e.value.value)
        .where((val) => val.isNotEmpty)
        .join(' > ');

    print("🛒 handleAddToCart => selectedOptionString=$selectedOption");
    //  Call server
    if (!authController.isLoggedIn.value) {
      await Get.toNamed('/settings/profile');
      if (authController.isLoggedIn.value) return;
    }

    await addProductToServer(product, option: selectedOption, shop: shop);
    Get.toNamed('/cart');
  }

  Future<void> addProductAfterLogin(CartModel product,
      {String? option, String? shop}) async {
    await addProductToServer(product, option: option, shop: shop);

    Get.toNamed('/cart');
  }

  Future<void> getUserCart() async {
    final token = GetStorage().read("accessToken");
    if (token == null) {
      Get.toNamed('/settings/profile'); // redirect to login if not logged in
      return;
    }

    isLoading.value = true;
    final url = Uri.parse('$baseUrl/cart');

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
        final cartData = data['data'];
        cartId.value = cartData['cartId'] ?? '';

        // Map items to CartModel including variantIds
        final items = (cartData['items'] as List<dynamic>).map((item) {
          // Handle variantIds as List<String>
          final variantIds = (item['variantId'] is List)
              ? List<String>.from(item['variantId'])
              : (item['variantId'] != null
                  ? [item['variantId'].toString()]
                  : []);
          print("items: $item");
          print("variantIds: $variantIds");

          return CartModel.fromJson({
            ...item,
            'variantId': variantIds,
          });
        }).toList();

        products.value = items;

        // Extract totals safely
        final totalsData = cartData['totals'] as Map<String, dynamic>? ?? {};
        totals.value = Totals(
          subtotal: (totalsData['subtotal'] ?? 0).toInt(),
          vat: (totalsData['tax'] ?? 0).toInt(),
          deliveryCharge: (totalsData['deliveryCharge'] ?? 0).toInt(),
          total: (totalsData['grandTotal'] ?? 0).toInt(),
        );

        products.refresh();
        print("Cart items: ${products.value}");
        print("Cart totals: ${totals.value.total}");
      } else {
        Fluttertoast.showToast(
          msg: data['message'] ?? "Failed to fetch cart",
          backgroundColor: Colors.red,
        );
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

  // Toggle checkbox
  Future<void> toggleProductSelection(CartModel product, bool val) async {
    //  product.isSelected.value = val; // immediate UI update

    await updateCartItem(
      cartItemId: product.cartItemId,
      productId: product.productId,
      action: val ? "checked" : "unchecked",
    );
    product.isSelected.value = val;

    // products.refresh();
  }

  Future<void> updateCartItem({
    required String cartItemId,
    required String productId,
    List<String>? variantIds,
    required String action, // "inc" / "dec" /"checked" / "unchecked"
    int? quantity,
  }) async {
    final token = GetStorage().read("accessToken");
    if (token == null) {
      Get.toNamed('/settings/profile'); // Login page
      return;
    }

    final url = Uri.parse("$baseUrl/cart/item/$productId");

    final body = {
      "cartItemId": cartItemId,
      "action": action,
      if (action == "inc" || action == "dec") "quantity": quantity,
      if (variantIds != null && variantIds.isNotEmpty) "variantId": variantIds,
    };

    final response = await http.patch(
      url,
      headers: {
        "x-vendor-identifier": vendorId,
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      final items = (data['data']['items'] as List)
          .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
          .toList();
      products.value = items;
      products.refresh();
      print("✅ Cart updated: $data");

      Fluttertoast.showToast(
        msg: data['message'] ?? "Cart updated",
        backgroundColor: Colors.green,
      );
      await getUserCart();
    } else {
      Fluttertoast.showToast(
        msg: data['error'] ?? data['message'] ?? "Failed to update cart",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> removeCartItem(String cartItemId, String productId) async {
    isLoading.value = true;
    try {
      final box = GetStorage();
      final accessToken = box.read("accessToken");

      if (accessToken == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final url = Uri.parse('$baseUrl/cart/item/$productId');

      final body = {
        "cartItemId": cartItemId,
      };

      print("➡️ DELETE Request to: $url");
      print("➡️ Body: $body");

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "x-vendor-identifier": vendorId,
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print(data);
      print("⬅️ Response (${response.statusCode}): $data");

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar("Success", data['message'] ?? "Item removed from cart");
        // Refresh user cart
        await getUserCart();
      } else {
        Get.snackbar(
          "Error",
          data['error'] ?? data['message'] ?? "Failed to remove cart item",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateDeliveryCharge(int charge) {
    totals.value = Totals(
      subtotal: totals.value.subtotal,
      vat: totals.value.vat,
      deliveryCharge: charge,
      total: totals.value.subtotal + totals.value.vat + charge, // total recalc
    );
  }

  @override
  void onInit() {
    super.onInit();
    getUserCart();
  }
}

  // Future<void> updateCartItem({
  //   required String cartItemId,
  //   required String productId,
  //   String? variantId,
  //   required int quantity,
  //   required String action, // "inc" / "dec"
  // }) async {
  //   final token = GetStorage().read("accessToken");

  //   if (token == null) {
  //     Get.toNamed('/settings/profile'); // Login page
  //     return;
  //   }

  //   final url =
  //       Uri.parse("https://app2.apidoxy.com/api/v1/cart/item/$productId");

  //   try {
  //     final response = await http.patch(
  //       url,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({

  //         if (variantId != null) "variantId": variantId,
  //         "quantity": quantity,
  //         "action": action,
  //         "shop": vendorId,
  //       }),
  //     );

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       print("Status code: ${response.statusCode}");

  //       print("Response: $data");
  //       // Optional: update local list or refresh UI
  //       products.refresh();
  //     } else {
  //       print("Status code: ${response.statusCode}");

  //       print("Response: $data");
  //       Fluttertoast.showToast(
  //         msg: data['message'] ?? "Failed to update cart",
  //         backgroundColor: Colors.red,
  //       );
  //     }
  //   } catch (e) {
  //     print("Response: $e");
  //     Fluttertoast.showToast(
  //       msg: "Error: $e",
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }

  ///delete item

  // Future<void> getUserCart() async {
  //   final token = GetStorage().read("accessToken");

  //   if (token == null) {
  //     Get.toNamed('/settings/profile'); // redirect to login
  //     return;
  //   }

  //   isLoading.value = true;

  //   final url = Uri.parse('$baseUrl/api/v1/cart');

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     final data = jsonDecode(response.body);
  //     print("Get Cart Response: $data");

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       // Extract items
  //       final items = data['data']['items'] as List<dynamic>;

  //       // Map items to CartModel
  //       products.value = items.map((e) => CartModel.fromJson(e)).toList();
  //       // Extract subtotal, tax, deliveryCharge, grandTotal
  //       final totalsData = data['data']['totals'] as Map<String, dynamic>;
  //       totals.value = Totals(
  //         subtotal: (totalsData['subtotal'] ?? 0).toInt(),
  //         vat: (totalsData['tax'] ?? 0).toInt(),
  //         deliveryCharge: (totalsData['deliveryCharge'] ?? 0).toInt(),
  //         total: (totalsData['grandTotal'] ?? 0).toInt(),

  //         // subtotal: (totalsData['subtotal'] ?? 0).toDouble(),
  //         // vat: (totalsData['tax'] ?? 0).toDouble(),
  //         // deliveryCharge: (totalsData['deliveryCharge'] ?? 0).toDouble(),
  //         // total: (totalsData['grandTotal'] ?? 0).toDouble(),
  //       );

  //       print(items);
  //       print("${products.value}");
  //       print(totalsData);
  //       print("Totals from API: ${totalsData['subtotal']}");
  //       print("Totals.value.subtotal: ${totals.value.subtotal}");
  //       products.refresh();
  //     } else {
  //       // Fluttertoast.showToast(
  //       //   msg: data['message'] ?? "Failed to fetch cart",
  //       //   backgroundColor: Colors.red,
  //       // );
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "Error fetching cart: $e",
  //       backgroundColor: Colors.red,
  //     );
  //     print("Error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

//   void updateDeliveryCharge(int charge) {
//     totals.value = Totals(
//       subtotal: totals.value.subtotal,
//       vat: totals.value.vat,
//       deliveryCharge: charge,
//       total: totals.value.subtotal + totals.value.vat + charge, // total recalc
//     );
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     getUserCart();
//   }
// }


  // Future<void> removeCartItem({
  //   required String productId,
  //   String? variantId,
  // }) async {
  //   final token = GetStorage().read("accessToken");

  //   if (token == null) {
  //     Get.toNamed('/settings/profile'); // Login page
  //     return;
  //   }

  //   // Check if item exists in local list before calling API
  //   final existingItem = products.firstWhereOrNull(
  //     (p) => p.productId == productId && p.variantId == variantId,
  //   );

  //   if (existingItem == null) {
  //     Fluttertoast.showToast(
  //       msg: "Item not found in cart",
  //       backgroundColor: Colors.orange,
  //     );
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
  //     } else if (response.statusCode == 404) {
  //       // Safe handling of 404
  //       products.removeWhere(
  //           (p) => p.productId == productId && p.variantId == variantId);
  //       products.refresh();
  //       Fluttertoast.showToast(
  //         msg: "Item was not in server cart, removed locally",
  //         backgroundColor: Colors.orange,
  //       );
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

  // double calculateTotal() {
  //   double total =
  //       products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
  //   return total + vat + deliveryCharge;
  // }

  // //Recipt

  // double subtotal() {
  //   double productotal =
  //       products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
  //   return productotal;
  // }

  // double recipttotal() {
  //   double productotal =
  //       products.fold(0, (sum, item) => sum + (item.price! * item.quantity));
  //   return productotal + vat + deliveryCharge;
  // }

