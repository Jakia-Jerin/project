import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/categories.dart';
import 'package:theme_desiree/a/controllers/product_collage.dart';
import 'package:theme_desiree/a/controllers/search.dart';
import 'package:theme_desiree/a/controllers/search_result.dart';
import 'package:theme_desiree/a/views/search_result.dart';

class Search extends StatelessWidget {
  Search({super.key});

  final searchResultController = Get.put(SearchResultController());
  final categoriesController = Get.put(CategoriesController());
  final productsController = Get.put(ProductCollageController());

  // Initialize directly
  final SearchSuggestionController searchSuggestionController =
      Get.put(SearchSuggestionController(
    categoriesController: Get.find<CategoriesController>(),
    productsController: Get.find<ProductCollageController>(),
  ));

  // When user taps a category
  void onCategorySelected(String categoryId) {
    searchResultController.fetchResult(
      categoryId: categoryId,
      catController: categoriesController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final category = Get.parameters['category'];

    // Update textController safely
    // if (category != null &&
    //     searchSuggestionController.textController.text.isEmpty) {
    //   searchSuggestionController.textController.text = category;
    //   onCategorySelected(category);
    // }
    if (category != null &&
        searchSuggestionController.textController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchSuggestionController.textController.text = category;
        onCategorySelected(category);
      });
    }
    return Container(
      color: contextTheme.colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Search'.tr.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FTextField(
              hint: 'Search for products or categories'.tr,
              controller: searchSuggestionController.textController,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              onSubmit: (value) {
                final matchedCategory =
                    categoriesController.categories.firstWhereOrNull(
                  (c) => c.title.toLowerCase() == value.toLowerCase(),
                );

                if (matchedCategory != null) {
                  onCategorySelected(matchedCategory.id);
                } else {
                  searchResultController.fetchResult(query: value);
                }

                searchSuggestionController.textController.clear();
              },
              //   searchResultController.results.clear();
              //   //   searchSuggestionController.suggestions.clear();
              //   final matchedCategory =
              //       categoriesController.categories.firstWhereOrNull(
              //     (c) => c.title.toLowerCase() == value.toLowerCase(),
              //   );

              //   if (matchedCategory != null) {
              //     onCategorySelected(matchedCategory.id);
              //   } else {
              //     searchResultController.fetchResult(query: value);
              //   }
              //   searchSuggestionController.textController.clear();
              // },
              onChange: (value) =>
                  searchSuggestionController.getSuggestions(value),
              prefixBuilder: (context, value, child) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: FIcon(FAssets.icons.search)),
            ),
          ),
          Obx(() {
            if (searchSuggestionController.suggestions.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: searchSuggestionController.suggestions.length,
                itemBuilder: (context, index) {
                  final item = searchSuggestionController.suggestions[index];
                  return GestureDetector(
                    onTap: () {
                      searchSuggestionController.textController.text = item;

                      final matchedCategory =
                          categoriesController.categories.firstWhereOrNull(
                        (c) => c.title.toLowerCase() == item.toLowerCase(),
                      );

                      if (matchedCategory != null) {
                        onCategorySelected(matchedCategory.id);
                      } else {
                        searchResultController.fetchResult(query: item);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: SearchResultView(),
            ),
          ),
        ],
      ),
    );
  }
}

// class Search extends StatelessWidget {
//   Search({super.key});

//   final searchResultController = Get.put(SearchResultController());
//   final categoriesController = Get.find<CategoriesController>();
//   final productsController = Get.put(ProductCollageController());

//   late final SearchSuggestionController searchSuggestionController;

//   // When user taps a category
//   void onCategorySelected(String categoryId) {
//     searchResultController.fetchResult(
//       categoryId: categoryId,
//       catController: categoriesController,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final category = Get.parameters['category'];

//     // Update controller text safely after build

//     searchSuggestionController = Get.put(
//       SearchSuggestionController(
//         categoriesController: categoriesController,
//         productsController: productsController,
//       ),
//     );
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       searchSuggestionController.textController.text = category ?? "";
//     });

// //    searchSuggestionController.textController.text = category ?? "";

//     // Trigger initial fetch for category products
//     if (category != null && searchResultController.results.isEmpty) {
//       searchResultController.fetchResult(
//         categoryId: category,
//         catController: categoriesController,
//       );
//     }
//     // if (category != null && searchResultController.results.isEmpty) {
//     //   searchResultController.fetchResult(category: category);
//     // }
//     return Container(
//       decoration: BoxDecoration(
//         color: contextTheme.colorScheme.background,
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Search'.tr.toUpperCase(),
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: FTextField(
//               hint: 'Search for products or categories'.tr,
//               keyboardType: TextInputType.text,
//               maxLines: 1,
//               initialValue: category,
//               autofocus: true,
//               //   controller: searchSuggestionController.textController,
//               onSubmit: (value) async {
//                 searchResultController.isLoading.value = true; // show loader
//                 searchResultController.results.clear();
//                 searchSuggestionController.suggestions
//                     .clear(); // clear old results
//                 await searchResultController.fetchResult(query: value);
//                 // searchResultController.results.clear();
//                 // searchResultController.fetchResult(query: value);
//               },
//               onChange: (value) {
//                 searchSuggestionController.filterSuggestions(value);
//               },
//               prefixBuilder: (context, value, child) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: FIcon(FAssets.icons.search),
//                 );
//               },
//             ),
//           ),
//           Obx(() {
//             if (!searchSuggestionController.isLoading.value &&
//                 !searchSuggestionController.hasError.value &&
//                 searchResultController.results.isEmpty) {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: searchSuggestionController.suggestions.length,
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 itemBuilder: (context, index) {
//                   final item = searchSuggestionController.suggestions[index];
//                   return GestureDetector(
//                     onTap: () async {
//                       //    onCategorySelected(categoriesController.categories);
//                       searchSuggestionController.textController.text = item;
//                       searchResultController.results.clear();
//                       await searchResultController.fetchResult(query: item);
//                       searchSuggestionController.suggestions.clear();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       child: Row(
//                         spacing: 8,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           FIcon(FAssets.icons.trendingUp),
//                           Text(
//                             item,
//                             style: contextTheme.typography.sm.copyWith(
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//             return SizedBox.shrink();
//           }),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
//               child: SearchResultView(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
