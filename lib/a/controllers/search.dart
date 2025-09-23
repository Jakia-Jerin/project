import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/categories.dart';
import 'package:theme_desiree/a/controllers/product_collage.dart';

class SearchSuggestionController extends GetConnect implements GetxService {
  var hasError = false.obs;
  var isLoading = false.obs;
  var suggestions = <String>[].obs;
  var textController = TextEditingController();

//  var textController = TextEditingController();
//  var suggestions = <String>[].obs;

  // All available names (categories + products)
  var allNames = <String>[].obs;

  final CategoriesController categoriesController;
  final ProductCollageController productsController;
  // sob category + product names
  var filteredSuggestions = <String>[].obs;

  SearchSuggestionController({
    required this.categoriesController,
    required this.productsController,
  });

  void getSuggestions(String query) {
    suggestions.clear();

    if (query.isEmpty) return;

    // Category suggestions
    suggestions.addAll(categoriesController.categories
        .where((c) => c.title.toLowerCase().contains(query.toLowerCase()))
        .map((c) => c.title));

    // Product suggestions
    suggestions.addAll(productsController.products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .map((p) => p.title));
  }
}





  // SearchSuggestionController({
  //   required this.categoriesController,
  //   required this.productsController,
  // });

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadAllNames();
  // }

  // void loadAllNames() {
  //   allNames.clear();
  //   allNames.addAll(categoriesController.categories.map((c) => c.title));
  //   allNames.addAll(productsController.products.map((p) => p.title));
  // }

  // void filterSuggestions(String query) {
  //   if (query.isEmpty) {
  //     filteredSuggestions.clear();
  //   } else {
  //     filteredSuggestions.assignAll(
  //       allNames.where(
  //         (name) => name.toLowerCase().contains(query.toLowerCase()),
  //       ),
  //     );
  //   }
  // }

  // void clear() {
  //   filteredSuggestions.clear();
  //   textController.clear();
  // }


  // Future<void> fetchSuggestions() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await get("${Constants.host}bd6aabc96e2ff39531c4");
  //     if (response.statusCode == 200) {
  //       final data = response.body;
  //       if ((data is Map) && (data['suggestions'] is List)) {
  //         suggestions.assignAll(List<String>.from(data['suggestions']));
  //       } else {
  //         hasError.value = true;
  //       }
  //     } else {
  //       hasError.value = true;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   Future.delayed(Duration.zero, () {
  //     fetchSuggestions();
  //   });
  // }

