import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/search.dart';
import 'package:theme_desiree/a/controllers/search_result.dart';
import 'package:theme_desiree/a/views/search_result.dart';

class Search extends StatelessWidget {
  Search({super.key});

  final searchSuggestionController = Get.put(SearchSuggestionController());
  final searchResultController = Get.find<SearchResultController>();
  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final category = Get.parameters['category'];
    searchSuggestionController.textController.text = category ?? "";
    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Search'.tr.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FTextField(
              hint: 'Search for products or categories'.tr,
              keyboardType: TextInputType.text,
              maxLines: 1,
              initialValue: category,
              autofocus: true,
              controller: searchSuggestionController.textController,
              onSubmit: (value) => searchResultController.fetchResult("query"),
              prefixBuilder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FIcon(FAssets.icons.search),
                );
              },
            ),
          ),
          Obx(() {
            if (!searchSuggestionController.isLoading.value &&
                !searchSuggestionController.hasError.value &&
                searchResultController.results.isEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: searchSuggestionController.suggestions.length,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final item = searchSuggestionController.suggestions[index];
                  return GestureDetector(
                    onTap: () =>
                        searchSuggestionController.textController.text = item,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FIcon(FAssets.icons.trendingUp),
                          Text(
                            item,
                            style: contextTheme.typography.sm.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return SizedBox.shrink();
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: SearchResultView(),
            ),
          )
        ],
      ),
    );
  }
}
