import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/categories.dart';
import 'package:theme_desiree/a/ui/error_view.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';

class Categories extends StatelessWidget {
  final String? selectedHandle;
  Categories({super.key, this.selectedHandle});

  final categoriesController = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FButton.icon(
                  onPress: () => Get.toNamed("/"),
                  child: FIcon(
                    FAssets.icons.chevronLeft,
                    size: 28,
                  ),
                ),
                Text(
                  'Categories'.tr.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Obx(
                  () => FButton.icon(
                    onPress: categoriesController.changeOrientation,
                    child: FIcon(
                      categoriesController.isGrid.value
                          ? FAssets.icons.grid2x2
                          : FAssets.icons.list,
                      size: 28,
                    ),
                  ),
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
              onTap: () => Get.toNamed("/search"),
              prefixBuilder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FIcon(FAssets.icons.search),
                );
              },
            ),
          ),
          Obx(
            () {
              if (categoriesController.isLoading.value) {
                return Expanded(child: Center(child: LoaderView()));
              }
              if (categoriesController.hasError.value) {
                return Expanded(
                  child: Center(
                    child: ErrorView(
                      retry: () => categoriesController.fetchCategories(),
                    ),
                  ),
                );
              }

              final selectedCategoryItems =
                  categoriesController.selectedCategoryItems;

              if (!categoriesController.isGrid.value &&
                  selectedCategoryItems.isNotEmpty) {
                return Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 12, right: 12),
                      child: SingleChildScrollView(
                        child: FTileGroup(
                          divider: FTileDivider.full,
                          children: categoriesController.selectedCategoryItems
                              .map((category) {
                            return FTile(
                              onPress: () {
                                final hasRoot = categoriesController
                                    .selectCategoryItems(category.handle);
                                if (!hasRoot) {
                                  Get.toNamed("/search", parameters: {
                                    "category": category.handle
                                  });
                                }
                              },
                              prefixIcon: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  category.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              suffixIcon: FIcon(FAssets.icons.chevronRight),
                              title: Text(category.title),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
                );
              }

              return Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 12, right: 12),
                      child: SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1 / 1,
                          ),
                          itemCount:
                              categoriesController.selectedCategoryItems.length,
                          itemBuilder: (context, index) {
                            final category = categoriesController
                                .selectedCategoryItems[index];

                            return GestureDetector(
                              onTap: () {
                                final hasRoot = categoriesController
                                    .selectCategoryItems(category.handle);
                                if (!hasRoot) {
                                  Get.toNamed("/search", parameters: {
                                    "category": category.handle
                                  });
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FCard(
                                  style: FCardStyle(
                                    decoration: BoxDecoration(),
                                    contentStyle: FCardContentStyle(
                                      titleTextStyle: TextStyle(),
                                      subtitleTextStyle: TextStyle(),
                                      padding: EdgeInsets.all(0),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: (constraints.maxWidth - 48) / 3,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.network(
                                            category.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black45,
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              category.title,
                                              style: contextTheme
                                                  .typography.base
                                                  .copyWith(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
