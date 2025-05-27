import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/views/product_mini_card.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/a/controllers/search_result.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';

class SearchResultView extends StatelessWidget {
  final String? query;
  SearchResultView({super.key, this.query});

  final CurrencyController currencyController = Get.find<CurrencyController>();
  @override
  Widget build(BuildContext context) {
    return GetX<SearchResultController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: LoaderView(),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: SizedBox.shrink(),
          );
        }

        return LayoutBuilder(builder: (context, constraints) {
          int crossAxisCount = (constraints.maxWidth / 240).floor().clamp(2, 8);
          return MasonryGridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            itemCount: controller.results.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = controller.results[index];
              return ProductMiniCard(data: item);
            },
          );
        });
      },
    );
  }
}
