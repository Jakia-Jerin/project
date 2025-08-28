import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/product_collage.dart';
import 'package:theme_desiree/a/views/product_mini_card.dart';
import 'package:theme_desiree/a/ui/error_view.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';

class ProductCollage extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductCollage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tag = UniqueKey().toString();
    final productCollageController =
        Get.put(ProductCollageController(), tag: tag);
    final contextTheme = FTheme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productCollageController.fetchProducts();
    });

    return GetX<ProductCollageController>(
      tag: tag,
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: LoaderView(),
          );
        } else if (controller.hasError.value) {
          return ErrorView(
            retry: () => controller.fetchProducts(),
          );
        }
        return FCard(
          style: contextTheme.cardStyle.copyWith(
            contentStyle: contextTheme.cardStyle.contentStyle.copyWith(
              padding: EdgeInsets.all(8),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount =
                  (constraints.maxWidth / 240).round().clamp(2, 8);
              return MasonryGridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return ProductMiniCard(data: controller.products[index]);
                },
              );
            },
          ),
        );
      },
    );
  }
}
