import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/caregories.dart';

class CategoriesController extends GetConnect implements GetxService {
  CategoriesController({this.selectedHandle});
  var categories = <CategoryModel>[].obs;
  var subCategories = <String?>[].obs;
  var selectedCategoryItems = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var isGrid = false.obs;
  var screenWidth = Get.width.obs;
  var currentPage = 1;
  var totalPages = 1;
  final String? selectedHandle;

  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await http.get(
        Uri.parse(
            "https://app2.apidoxy.com/api/v1/categories"), // ✅ তোমার API endpoint
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          "Content-Type": "application/json",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody["success"] == true && jsonBody["data"] is List) {
          final List<CategoryModel> fetched = (jsonBody["data"] as List)
              .map((e) => CategoryModel.fromJson(e))
              .toList();

          categories.assignAll(fetched);

          print("✅ Categories fetched: ${categories.length}");
          for (var c in categories) {
            print("id=${c.id}, title=${c.title}, handle=${c.handle}");
          }
        } else {
          print("⚠️ JSON structure unexpected: $jsonBody");
          hasError.value = true;
        }
      } else {
        print("⚠️ Server error: ${response.statusCode}");
        hasError.value = true;
      }
    } catch (e) {
      print("❌ Exception: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}
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


