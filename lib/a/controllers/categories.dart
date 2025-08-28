import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:theme_desiree/a/models/caregories.dart';

class CategoriesController extends GetConnect implements GetxService {
  var categories = <CategoryModel>[].obs;
  var subCategories = <String?>[].obs;
  var selectedCategoryItems = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var isGrid = false.obs;
  var screenWidth = Get.width.obs;
  var currentPage = 1;
  var totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      fetchCategories();
    });
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await http.get(
        Uri.parse("https://app2.apidoxy.com/api/v1/categories"),
        headers: {
          "x-vendor-identifier": dotenv.env['SHOP_ID'] ?? "",
          'Content-Type': 'application/json',
        },
      );

      print("Status code: ${response.statusCode}");
      print("Full response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] is List) {
          final List<CategoryModel> respCategories = (data['data'] as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList();

          categories.assignAll(respCategories);
          print("Categories fetched: ${categories.length}");
          print("Categories data: ${data['data']}");

          // Pagination info (null-safe)
          if (data['pagination'] != null && data['pagination'] is Map) {
            currentPage = data['pagination']['currentPage'] ?? 1;
            totalPages = data['pagination']['totalPages'] ?? 1;
          }

          print("Fetched ${categories.length} categories.");
        } else {
          hasError.value = true;
          print("Error: 'data' is null or not a List");
        }
      } else {
        hasError.value = true;
        print("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      hasError.value = true;
      print("Exception fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> fetchCategories(String? handle) async {
  //   isLoading.value = true;
  //   try {
  //     final response = await get("${Constants.host}db4b90596a406d6a2c2f");
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if (data is Map && data['collections'] is List) {
  //         final List<CategoryModel> respCategories =
  //             (data['collections'] as List)
  //                 .map((item) => CategoryModel.fromJson(item))
  //                 .toList();
  //         categories.assignAll(respCategories);
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     selectCategoryItems(handle);
  //     isLoading.value = false;
  //   }
  // }

  bool selectCategoryItems(String? handle) {
    if (handle == null) {
      selectedCategoryItems
          .assignAll(categories.where((item) => item.parent == null).toList());
      if (selectedCategoryItems.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      final selectedItems =
          categories.where((item) => item.handle == handle).toList();
      if (selectedItems.isNotEmpty) {
        final CategoryModel result = selectedItems.first;
        final tempList =
            categories.where((item) => item.parent == result.id).toList();
        if (tempList.isNotEmpty) {
          selectedCategoryItems.assignAll(tempList);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  void changeOrientation() {
    isGrid.value = isGrid.value ? false : true;
  }
}
