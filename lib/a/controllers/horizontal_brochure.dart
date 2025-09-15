import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/caregories.dart';
import 'package:theme_desiree/a/models/horizontal_brochure.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';

class HorizontalBrochureController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var brochures = <HorizontalBrochureModel>[].obs;

  Future<void> fetchCategoryWiseBrochures() async {
    try {
      print("Fetching categories...");
      isLoading.value = true;
      hasError.value = false;

      // 1. Fetch categories
      final catUri = Uri.https("app2.apidoxy.com", "/api/v1/categories");
      final catResponse = await http.get(
        catUri,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Content-Type": "application/json",
        },
      );

      print("Category Response code: ${catResponse.statusCode}");
      print("Category Response body: ${catResponse.body}");

      if (catResponse.statusCode != 200) {
        print("Failed to fetch categories.");
        hasError.value = true;
        return;
      }

      final catBody = jsonDecode(catResponse.body);
      if (!(catBody['success'] == true && catBody['data'] is List)) {
        print("Categories API response invalid.");
        hasError.value = true;
        return;
      }

      final categories = (catBody['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .where((c) => c.id.isNotEmpty) // empty ID filter
          .toList();

      print("Fetched ${categories.length} categories.");

      brochures.clear();

      // 2. Fetch products per category
      for (final category in categories) {
        print(
            "Fetching products for category: ${category.title} (${category.id})");

        final prodUri = Uri.https(
          "app2.apidoxy.com",
          "/api/v1/products",
          {"category": category.id}, // category filter
        );

        final prodResponse = await http.get(
          prodUri,
          headers: {
            "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
            "Content-Type": "application/json",
          },
        );

        print("Product Response code: ${prodResponse.statusCode}");
        print("Product Response body: ${prodResponse.body}");

        if (prodResponse.statusCode != 200) {
          print("Failed to fetch products for category ${category.title}");
          continue;
        }

        final prodBody = jsonDecode(prodResponse.body);
        if (!(prodBody['success'] == true && prodBody['data'] is List)) {
          print("Products API response invalid for category ${category.title}");
          continue;
        }

        final products = (prodBody['data'] as List)
            .map((item) => ProductMiniCardModel.fromJson(item))
            .where((p) => p.category != null && p.category!.id == category.id)
            .toList();

        print(
            "Fetched ${products.length} products for category ${category.title}");

        brochures.add(
          HorizontalBrochureModel(
            title: category.title,
            subtitle: category.description,
            image: category.imageUrl != null
                ? "https://app2.apidoxy.com/api/v1/image/${dotenv.env['SHOP_ID']}/${category.imageUrl!.imageName}"
                : null,
            //   image: category.imageUrl?.imageName,
            handle: "/category/${category.id}",
            products: products,
          ),
        );
      }

      print("Total brochures: ${brochures.length}");
    } catch (e, stackTrace) {
      print("Error fetching brochures: $e");
      print(stackTrace);
      hasError.value = true;
    } finally {
      isLoading.value = false;
      print("Fetching brochures completed.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategoryWiseBrochures();
  }
}

  // Future<void> fetchCategoryWiseBrochures() async {
  //   try {
  //     print("Fetching categories...");
  //     isLoading.value = true;
  //     hasError.value = false;

  //     // 1. Fetch categories
  //     final catUri = Uri.https("app2.apidoxy.com", "/api/v1/categories");
  //     final catResponse = await http.get(
  //       catUri,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     print("Category Response code: ${catResponse.statusCode}");
  //     print("Category Response body: ${catResponse.body}");

  //     if (catResponse.statusCode != 200) {
  //       print("Failed to fetch categories.");
  //       hasError.value = true;
  //       return;
  //     }

  //     final catBody = jsonDecode(catResponse.body);
  //     if (!(catBody['success'] == true && catBody['data'] is List)) {
  //       print("Categories API response invalid.");
  //       hasError.value = true;
  //       return;
  //     }

  //     final categories = (catBody['data'] as List)
  //         .map((json) => CategoryModel.fromJson(json))
  //         .toList();

  //     print("Fetched ${categories.length} categories.");

  //     brochures.clear();

  //     // 2. Fetch products per category
  //     for (final category in categories) {
  //       print(
  //           "Fetching products for category: ${category.title} (${category.id})");

  //       final prodUri = Uri.https(
  //         "app2.apidoxy.com",
  //         "/api/v1/products",
  //         {"category": category.id},
  //       );

  //       final prodResponse = await http.get(
  //         prodUri,
  //         headers: {
  //           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //           "Content-Type": "application/json",
  //         },
  //       );

  //       print("Product Response code: ${prodResponse.statusCode}");
  //       print("Product Response body: ${prodResponse.body}");

  //       if (prodResponse.statusCode != 200) {
  //         print("Failed to fetch products for category ${category.title}");
  //         continue;
  //       }

  //       final prodBody = jsonDecode(prodResponse.body);
  //       if (!(prodBody['success'] == true && prodBody['data'] is List)) {
  //         print("Products API response invalid for category ${category.title}");
  //         continue;
  //       }

  //       final products = (prodBody['data'] as List)
  //           .map((item) => ProductMiniCardModel.fromJson(item))
  //           .where((p) => p.category != null && p.category!.id.isNotEmpty)
  //           .where((p) =>
  //               p.category!.id ==
  //               category.id) // category.id অবশ্যই non-empty হতে হবে
  //           .toList();

  //       for (var p in products) {
  //         print(
  //             "Product: ${p.title}, CategoryID: ${p.category?.id}, ExpectedID: ${category.id}");
  //         print("Product Category ID: ${p.category?.id}");
  //       }
  //       print("Category ID: ${category.id}");

  //       // final products = (prodBody['data'] as List)
  //       //     .map((item) => ProductMiniCardModel.fromJson(item))
  //       //     .toList();

  //       print(
  //           "Fetched ${products.length} products for category ${category.title}");
  //       //   print("Product ${products.}, category id: ${products.category?.id}");

  //       brochures.add(
  //         HorizontalBrochureModel(
  //           title: category.title,
  //           subtitle: category.description,
  //           image: category.imageUrl,
  //           handle: "/category/${category.id}",
  //           products: products,
  //         ),
  //       );
  //     }

  //     print("Total brochures: ${brochures.length}");
  //   } catch (e, stackTrace) {
  //     print("Error fetching brochures: $e");
  //     print(stackTrace);
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //     print("Fetching brochures completed.");
  //   }
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchCategoryWiseBrochures();
  // }






// class HorizontalBrochureController extends GetxController {
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var brochure = Rx<HorizontalBrochureModel?>(null);
//   var products = <ProductMiniCardModel>[].obs;

//   Future<void> fetchBrochure() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;

//       final uri = Uri.https(
//         "app2.apidoxy.com",
//         "/api/v1/products", // API path
//       );

//       final response = await http.get(
//         uri,
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );
//       print("x-vendor-identifier: ${dotenv.env['SHOP_ID']}");

//       print("Response body: ${response.body}"); // debug

//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);

//         if (body['success'] == true && body['data'] is List) {
//           final products = (body['data'] as List)
//               .map((item) => ProductMiniCardModel.fromJson(item))
//               .toList();

//           brochure.value = HorizontalBrochureModel(
//             title: "Eid Sharee Collection",
//             subtitle: "Zamdani, Katan, Suti with blouse pieces",
//             image: null,
//             handle: "/products",
//             products: products,
//           );
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching brochure: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBrochure();
//   }

  // Future<void> fetchProducts({
  //   String q = "",
  //   int page = 1,
  //   int limit = 20,
  //   String sortBy = "createdAt",
  //   String sortOrder = "desc",
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     hasError.value = false;

  //     final uri = Uri.https(
  //       "app2.apidoxy.com", // host
  //       "/api/v1/products", // path
  //     );

  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     print("Response body: ${response.body}"); // debug

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       if (body['success'] == true && body['data'] is List) {
  //         final tempProducts = (body['data'] as List)
  //             .map((e) => ProductMiniCardModel.fromJson(e))
  //             .toList();
  //         products.assignAll(tempProducts);
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("status code: ${e.toString()}");
  //     print("Error fetching products: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProducts();
  // }

  // Future<void> fromJson(Map<String, dynamic> json) async {
  //   try {
  //     isLoading.value = true;
  //     hasError.value = false;

  //     if (json['error'] == false && json['data'] != null) {
  //       brochure.value = HorizontalBrochureModel.fromJson(json['data']);
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

