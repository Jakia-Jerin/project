import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/caregories.dart';

class CategoriesController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var selectedCategoryItems = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var isGrid = false.obs;
  final String? selectedHandle;
  final baseUrl = dotenv.env['BASE_URL'];

  CategoriesController({this.selectedHandle});

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/categories"),
        //   Uri.parse("https://app2.apidoxy.com/api/v1/categories"),
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] is List) {
          final List<CategoryModel> respCategories = (data['data'] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList();
          print("///////////////////////////////////////////////////");

          print("Category Response Body: ${response.body}");
          categories.assignAll(respCategories);

          // Select initial categories
          selectCategoryItems(selectedHandle);
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      print("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool selectCategoryItems(String? handle) {
    List<CategoryModel> items = [];

    if (handle == null) {
      items = categories
          .where((c) => c.parent == null || c.parent!.isEmpty)
          .toList();
    } else {
      final selected = categories.firstWhereOrNull((c) => c.handle == handle);
      if (selected != null) {
        if (selected.children.isNotEmpty) {
          items = categories
              .where((c) => selected.children.contains(c.id))
              .toList();
        } else {
          // No children → redirect to search page
          Get.toNamed("/search", parameters: {"category": selected.handle});

          items = categories
              .where((c) => c.parent == null || c.parent!.isEmpty)
              .toList();
        }
      } else {
        items = categories
            .where((c) => c.parent == null || c.parent!.isEmpty)
            .toList();
      }
    }

    selectedCategoryItems.assignAll(items);
    return selectedCategoryItems.isNotEmpty;
  }

  void changeOrientation() {
    isGrid.value = !isGrid.value;
  }

  /// Recursively get parent + all children IDs
  List<String> getAllCategoryIds(String parentId) {
    List<String> ids = [parentId];

    final parentCategory = categories.firstWhereOrNull((c) => c.id == parentId);
    if (parentCategory != null && parentCategory.children.isNotEmpty) {
      for (var childId in parentCategory.children) {
        ids.addAll(getAllCategoryIds(childId));
      }
    }

    return ids;
  }
}


// class CategoriesController extends GetxController {
//   var categories = <CategoryModel>[].obs;
//   var selectedCategoryItems = <CategoryModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var isGrid = false.obs;
//   final String? selectedHandle;

//   CategoriesController({this.selectedHandle});

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/categories"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['success'] == true && data['data'] is List) {
//           final List<CategoryModel> respCategories = (data['data'] as List)
//               .map((e) => CategoryModel.fromJson(e))
//               .toList();

//           print(".............................................");
//           print("Category REsponse Body: ${response.body}");
//           categories.assignAll(respCategories);

//           // Select initial categories
//           selectCategoryItems(selectedHandle);
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching categories: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   bool selectCategoryItems(String? handle) {
//     List<CategoryModel> items = [];

//     if (handle == null) {
//       // Top-level categories (parent null or empty)
//       items = categories
//           .where((c) => c.parent == null || c.parent!.isEmpty)
//           .toList();
//     } else {
//       // Find the category by handle
//       final selected = categories.firstWhereOrNull((c) => c.handle == handle);

//       if (selected != null) {
//         if (selected.children.isNotEmpty) {
//           // Show children categories
//           items = categories
//               .where((c) => selected.children.contains(c.id))
//               .toList();
//         } else {
//           // No children → redirect to search page

//           Get.toNamed("/search", parameters: {"category": selected.handle});

//           // fallback to top-level
//           items = categories
//               .where((c) => c.parent == null || c.parent!.isEmpty)
//               .toList();
//         }
//       } else {
//         // handle not found → show top-level
//         items = categories
//             .where((c) => c.parent == null || c.parent!.isEmpty)
//             .toList();
//       }
//     }

//     selectedCategoryItems.assignAll(items);

//     print("*************************************************");
//     print("Selected categories count: ${selectedCategoryItems.length}");
//     print(
//         "Selected category titles: ${selectedCategoryItems.map((c) => c.title).toList()}");

//     return selectedCategoryItems.isNotEmpty;
//   }

//   void changeOrientation() {
//     isGrid.value = !isGrid.value;
//   }
// }


// class CategoriesController extends GetxController {
//   var categories = <CategoryModel>[].obs;
//   var products = <ProductModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//     fetchAllProducts();
//   }

//   /// fetch categories
//   Future<void> fetchCategories() async {
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/categories"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         if (jsonBody['success'] == true && jsonBody['data'] is List) {
//           categories.assignAll(
//             (jsonBody['data'] as List)
//                 .map((e) => CategoryModel.fromJson(e))
//                 .toList(),
//           );
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching categories: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// fetch all products for the shop
//   Future<void> fetchAllProducts() async {
//     isLoading.value = true;
//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         if (jsonBody['success'] == true && jsonBody['data'] is List) {
//           products.assignAll(
//             (jsonBody['data'] as List)
//                 .map((e) => ProductModel.fromJson(e))
//                 .toList(),
//           );
//         } else {
//           hasError.value = true;
//         }
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

//   /// filter products by category handle
//   List<ProductModel> filterProductsByCategory(String handle) {
//     return products.where((p) => p.category?.handle == handle).toList();
//   }

//   /// fetch products by category directly from API (optional)
//   Future<void> fetchProductsByCategory(String handle) async {
//     isLoading.value = true;
//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/products?category=$handle"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonBody = jsonDecode(response.body);
//         if (jsonBody['success'] == true && jsonBody['data'] is List) {
//           products.assignAll(
//             (jsonBody['data'] as List)
//                 .map((e) => ProductModel.fromJson(e))
//                 .toList(),
//           );
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Error fetching products by category: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// class CategoriesController extends GetConnect implements GetxService {
//   CategoriesController({this.selectedHandle});
//   var categories = <CategoryModel>[].obs;
//   var subCategories = <String?>[].obs;
//   var selectedCategoryItems = <CategoryModel>[].obs;
//   var isLoading = false.obs;
//   var hasError = false.obs;
//   var isGrid = false.obs;
//   var screenWidth = Get.width.obs;
//   var currentPage = 1;
//   var totalPages = 1;
//   final String? selectedHandle;

//   Future<void> fetchCategories() async {
//     isLoading.value = true;
//     hasError.value = false;

//     try {
//       final response = await http.get(
//         Uri.parse("https://app2.apidoxy.com/api/v1/categories"),
//         headers: {
//           "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
//           'Content-Type': 'application/json',
//         },
//       );

//       print("Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonDecode(response.body);

//         if (data['success'] == true && data['data'] is List) {
//           final List<CategoryModel> respCategories = (data['data'] as List)
//               .map((item) => CategoryModel.fromJson(item))
//               .toList();

//           categories.assignAll(respCategories);
//           print("Categories fetched: ${categories.length}");

//           // select top-level items or based on handle
//           selectCategoryItems(selectedHandle);
//         } else {
//           hasError.value = true;
//         }
//       } else {
//         hasError.value = true;
//       }
//     } catch (e) {
//       hasError.value = true;
//       print("Exception fetching categories: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   bool selectCategoryItems(String? handle) {
//     List<CategoryModel> items = [];

//     if (handle == null) {
//       // Top-level categories (parent == null)
//       items = categories.where((c) => c.parent == null).toList();
//     } else {
//       // Find selected handle
//       final selected = categories.firstWhereOrNull((c) => c.handle == handle);

//       if (selected != null) {
//         final children =
//             categories.where((c) => c.parent == selected.id).toList();
//         if (children.isNotEmpty) {
//           items = children;
//         } else {
//           // No children, fallback to top-level
//           items = categories.where((c) => c.parent == null).toList();
//         }
//       } else {
//         // handle not found, fallback to top-level
//         items = categories.where((c) => c.parent == null).toList();
//       }
//     }

//     selectedCategoryItems.assignAll(items);
//     print(
//         "Selected category items: ${selectedCategoryItems.length}, handle=$handle");

//     return selectedCategoryItems.isNotEmpty;
//   }

//   void changeOrientation() {
//     isGrid.value = !isGrid.value;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCategories();
//   }
// }


// // Future<void> fetchCategories(String? handle) async {
//   //   isLoading.value = true;
//   //   try {
//   //     final response = await get("${Constants.host}db4b90596a406d6a2c2f");
//   //     if (response.statusCode == 200) {
//   //       final data = response.body;
//   //       if (data is Map && data['collections'] is List) {
//   //         final List<CategoryModel> respCategories =
//   //             (data['collections'] as List)
//   //                 .map((item) => CategoryModel.fromJson(item))
//   //                 .toList();
//   //         categories.assignAll(respCategories);
//   //       } else {
//   //         hasError.value = true;
//   //       }
//   //     } else {
//   //       hasError.value = true;
//   //     }
//   //   } catch (e) {
//   //     hasError.value = true;
//   //   } finally {
//   //     selectCategoryItems(handle);
//   //     isLoading.value = false;
//   //   }
//   // }


