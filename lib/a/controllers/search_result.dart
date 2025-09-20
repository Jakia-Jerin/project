import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/controllers/categories.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';

class SearchResultController extends GetxController {
  var results = <ProductMiniCardModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  final baseUrl = dotenv.env['BASE_URL'];
  final shopId = dotenv.env['SHOP_ID'];

  /// Fetch products based on query or category
  Future<void> fetchResult({
    String? query,
    String? categoryId,
    CategoriesController? catController,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      results.clear();

      // 1️⃣ Prepare category IDs (parent + child)
      // 1️⃣ Prepare category IDs
      List<String> categoryIds = [];
      if (categoryId != null && catController != null) {
        categoryIds = catController.getAllCategoryIds(categoryId);
      }

// 2️⃣ Build query parameters
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['q'] = query;
      if (categoryIds.isNotEmpty)
        queryParams['category'] = categoryIds.join(',');

// 3️⃣ Build URI properly
      final uri = Uri.https(
        'app2.apidoxy.com', // Domain only, no https://
        '/api/v1/products', // Path
        queryParams, // Query parameters
      );

      print("*********************************************************");

      print('Fetching products from URL: $uri');
      print('Category IDs: $categoryIds');
      print('Query: $query');

// 4️⃣ Make HTTP GET request
      final response = await http.get(
        uri,
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
        },
      );

      // 4️⃣ Handle response
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          results.assignAll((body['data'] as List)
              .map((e) => ProductMiniCardModel.fromJson(e))
              .toList());

          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
          print(response.body);
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("Search error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}


// class SearchResultController extends GetxController {
//   var results = <ProductMiniCardModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;

//   /// Fetch products based on query or category
//   Future<void> fetchResult({
//     String? query,
//     String? categoryId,
//     CategoriesController? catController,
//   }) async {
//     isLoading.value = true;
//     hasError.value = false;

//     // Clear previous results
//     results.clear();
//     results.refresh();

//     try {
//       // 1️⃣ Prepare category IDs (parent + child)
//       List<String> categoryIds = [];
//       if (categoryId != null && catController != null) {
//         categoryIds = catController.getAllCategoryIds(categoryId);
//       }

//       // 2️⃣ Build URL with both category and search query
//       String url = "https://app2.apidoxy.com/api/v1/products?";
//       if (categoryIds.isNotEmpty) {
//         url += "category=${categoryIds.join(",")}&";
//       }
//       if (query != null && query.isNotEmpty) {
//         url += "q=$query";
//       }
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');

//       print("Fetching products from URL: $url");

//       // 3️⃣ Make HTTP GET request
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       // 4️⃣ Handle response
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         results.assignAll((data['data'] as List)
//             .map((e) => ProductMiniCardModel.fromJson(e))
//             .toList());
//       } else {
//         hasError.value = true;
//         print("Failed to fetch products: ${response.statusCode}");
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching products: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

  
// }
//   Future<void> fetchResult({
//     String? query,
//     String? categoryId,
//     CategoriesController? catController,
//   }) async {
//     isLoading.value = true;
//     hasError.value = false;

//     // Clear previous results
//     results.clear();

//     try {
//       List<String> categoryIds = [];

//       if (categoryId != null && catController != null) {
//         // Get parent + all children category IDs
//         categoryIds = catController.getAllCategoryIds(categoryId);
//       }

//       String url = "https://app2.apidoxy.com/api/v1/products?";
//       if (categoryIds.isNotEmpty && (query == null || query.isEmpty)) {
//         url += "category=${categoryIds.join(",")}";
//       }
//       if (query != null && query.isNotEmpty) {
//         url += "search=$query";
//       }
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
//       print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');

//       print("Fetching products from URL: $url");

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         results.assignAll((data['data'] as List)
//             .map((e) => ProductMiniCardModel.fromJson(e))
//             .toList());
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching products: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
  // Future<void> fetchResult({
  //   String? query,
  //   String? categoryId,
  //   CategoriesController? catController,
  // }) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   // Clear previous results
  //   results.clear();

  //   try {
  //     List<String> categoryIds = [];

  //     if (categoryId != null && catController != null) {
  //       // Get parent + all children category IDs
  //       categoryIds = catController.getAllCategoryIds(categoryId);
  //     }

  //     String url = "https://app2.apidoxy.com/api/v1/products?";
  //     if (categoryIds.isNotEmpty && (query == null || query.isEmpty)) {
  //       url += "category=${categoryIds.join(",")}";
  //     }
  //     if (query != null && query.isNotEmpty) {
  //       url += "search=$query";
  //     }
  //     print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
  //     print("Fetching products from URL: $url");

  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //         "Content-Type": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       results.assignAll((data['data'] as List)
  //           .map((e) => ProductMiniCardModel.fromJson(e))
  //           .toList());

  //       print("Fetched products: ${results.length}");
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching products: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }




// class SearchResultController extends GetxController {
//   var results = <ProductMiniCardModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;

//   /// Fetch products based on query or category
//   Future<void> fetchResult({String? query, String? category}) async {
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       // Category filter apply only if query empty
//       String url = "https://app2.apidoxy.com/api/v1/products?";
//       if (category != null && (query == null || query.isEmpty)) {
//         url += "category=$category";
//       }
//       if (query != null && query.isNotEmpty) {
//         url += "search=$query";
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         results.assignAll((data['data'] as List)
//             .map((e) => ProductMiniCardModel.fromJson(e))
//             .toList());
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching products: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

  // Future<void> fetchResult({String? query, String? category}) async {
  //   isLoading.value = true;
  //   hasError.value = false;

  //   try {
  //     final uri = Uri.parse("https://app2.apidoxy.com/api/v1/products")
  //         .replace(queryParameters: {
  //       if (query != null && query.isNotEmpty) "query": query,
  //       if (category != null && category.isNotEmpty) "category": category,
  //     });

  //     final response = await http.get(uri, headers: {
  //       "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
  //       "Content-Type": "application/json",
  //     });

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       results.assignAll((data['data'] as List)
  //           .map((e) => ProductMiniCardModel.fromJson(e))
  //           .toList());
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     print("Error fetching search results: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


// class SearchResultController extends GetConnect implements GetxService {
//   var results = <ProductMiniCardModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;

//   Future<void> fetchResult(String query) async {
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await get("https://api.npoint.io/d7ab967e02751b8db364");

//       if (response.statusCode == 200) {
//         final data = response.body;
//         if (data is Map && data['results'] is List) {
//           List<ProductMiniCardModel> dataResults = (data['results'] as List)
//               .map((item) => ProductMiniCardModel.fromJson(item))
//               .toList();
//           results.assignAll(dataResults);
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
