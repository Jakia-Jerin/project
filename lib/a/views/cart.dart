import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/a/controllers/home.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';

class CartView extends StatelessWidget {
  final cartController = Get.find<CartController>();
  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyController = Get.find<CurrencyController>();
    final cartController = Get.find<CartController>();
    final contextTheme = FTheme.of(context);
    final homeController = Get.put(HomeController());
    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          color: contextTheme.colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FButton.icon(
                      onPress: () => Get.toNamed("/settings"),
                      style: FButtonStyle.outline,
                      child: FIcon(
                        FAssets.icons.chevronLeft,
                        size: 24,
                      ),
                    ),
                    Text(
                      'Cart'.tr.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Obx(() {
                      if (cartController.products.isEmpty) {
                        return SizedBox(width: 39);
                      }
                      return FButton.icon(
                        onPress: () => cartController.products.clear(),
                        style: FButtonStyle.outline,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: FIcon(
                            FAssets.icons.trash2,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Obx(() {
              //   if (cartController.isLoading.value ||
              //       cartController.hasError.value) {
              //     return Center(child: LoaderView());
              //   }
              //   if (cartController.calculateTotal() == 0.00) {
              //     cartController.isLoading.value = false;
              //   }
              //   return Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: FTile(
              //       subtitle: Text('Subtotal'.tr),
              //       title: Text(
              //         currencyController.formatCurrency(
              //           cartController.subtotal(),
              //         ),
              //         style: contextTheme.typography.lg.copyWith(
              //           fontWeight: FontWeight.bold,
              //           color: contextTheme.colorScheme.primary,
              //         ),
              //       ),
              //       suffixIcon: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           FButton(
              //             onPress: () => Get.toNamed('/checkout'),
              //             style: contextTheme.buttonStyles.primary.copyWith(
              //               contentStyle: contextTheme
              //                   .buttonStyles.primary.contentStyle
              //                   .copyWith(
              //                 padding: EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 10,
              //                 ),
              //               ),
              //             ),
              //             label: Text(
              //               'Checkout'.tr,
              //               style: contextTheme.typography.sm.copyWith(
              //                 color: contextTheme.typography.sm.color,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }),
              GetX<CartController>(
                builder: (controller) {
                  if (cartController.isLoading.value == true) {
                    return Center(child: LoaderView());
                  }

                  if (controller.products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/imagecart-removebg-preview.png',
                              width: 200,
                              height: 200,
                            ),
                            // Icon(Icons.shopping_cart_outlined,
                            //     size: 80,
                            //     color: contextTheme.colorScheme.primary),
                            const SizedBox(height: 10),
                            Text(
                              "No items in this cart!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: contextTheme.typography.lg.color,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: FButton(
                                  style: contextTheme.buttonStyles.primary
                                      .copyWith(
                                    contentStyle: contextTheme
                                        .buttonStyles.primary.contentStyle
                                        .copyWith(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                  onPress: () {
                                    Get.toNamed("/");
                                  },
                                  label: Text(
                                    "Continue Shopping",
                                    style: contextTheme.typography.sm.copyWith(
                                      fontSize: 17,
                                      color: contextTheme.typography.sm.color,
                                    ),
                                  )),
                            ),

                            // Expanded(
                            //   child: FCard(
                            //     child: Column(
                            //       children: [
                            //         TopBar(),
                            //         Flexible(
                            //           fit: FlexFit.loose,
                            //           child: GetX<HomeController>(
                            //               builder: (controller) {
                            //             if (controller.isLoading.value) {
                            //               return Center(
                            //                   child: const LoaderView());
                            //             }
                            //             if (controller.hasError.value) {
                            //               return ErrorView(
                            //                 body: "Failed to load store",
                            //                 solution: "Refresh again",
                            //                 retry: controller.fetchSections,
                            //               );
                            //             }
                            //             return ListView.separated(
                            //               shrinkWrap: true,
                            //               itemCount: controller.sections.length,
                            //               padding: EdgeInsets.symmetric(
                            //                   horizontal: 8, vertical: 2),
                            //               separatorBuilder: (context, index) =>
                            //                   SizedBox(height: 8),
                            //               itemBuilder: (context, index) {
                            //                 final sortedSections =
                            //                     List<SectionModel>.from(
                            //                         controller.sections)
                            //                       ..sort((a, b) =>
                            //                           a.index.compareTo(b.index));

                            //                 final section = sortedSections[index];
                            //                 switch (section.type) {
                            //                   case SectionType.horizontalBrochure:
                            //                     return HorizontalBrochure(
                            //                         data: section.data);
                            //                   case SectionType.collage:
                            //                     return ProductCollage(
                            //                         data: section.data);

                            //                   default:
                            //                     return SizedBox.shrink();
                            //                 }
                            //               },
                            //             );
                            //           }),
                            //         ),
                            //         //   SizedBox(height: 10),
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FTileGroup.builder(
                        count: controller.products.length,
                        divider: FTileDivider.full,
                        tileBuilder: (context, index) {
                          final product = controller.products[index];
                          return FTile(
                            prefixIcon: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                product.image ?? '',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            suffixIcon: Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  spacing: 4,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      spacing: 2,
                                      children: [
                                        Text(
                                          currencyController.formatCurrency(
                                              product.price!.toDouble()),
                                          style: contextTheme.typography.sm,
                                        ),
                                        Text(
                                          "×",
                                          style: contextTheme.typography.sm,
                                        ),
                                        Text(
                                          product.quantity.toString(),
                                          style: contextTheme.typography.sm,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      currencyController.formatCurrency(
                                        product.price!.toDouble() *
                                            product.quantity,
                                      ),
                                      style:
                                          contextTheme.typography.lg.copyWith(
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                        color: contextTheme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: contextTheme.colorScheme.primary,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FButton.icon(
                                          onPress: () {
                                            if (product.quantity > 1) {
                                              product.quantity--;
                                            } else {
                                              cartController.products
                                                  .remove(product);
                                              Fluttertoast.showToast(
                                                msg: 'Item removed'.tr,
                                                backgroundColor: contextTheme
                                                    .colorScheme.primary,
                                              );
                                              HapticFeedback.vibrate();
                                            }
                                            cartController.products.refresh();
                                          },
                                          style: FButtonStyle.primary,
                                          child: FIcon(
                                            product.quantity <= 1
                                                ? FAssets.icons.trash
                                                : FAssets.icons.minus,
                                            size: 12,
                                            color: contextTheme
                                                .colorScheme.foreground,
                                          ),
                                        ),
                                        FButton.icon(
                                          onPress: () {
                                            if (product.quantity <=
                                                product.stock!.toInt()) {
                                              product.quantity++;
                                              cartController.products.refresh();
                                            } else {
                                              HapticFeedback.vibrate();
                                            }
                                          },
                                          style: FButtonStyle.primary,
                                          child: FIcon(
                                            FAssets.icons.plus,
                                            size: 12,
                                            color: contextTheme
                                                .colorScheme.foreground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            title: Text(product.title ?? ''),
                            subtitle: Text(product.variant ?? ''),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Obx(() {
                if (cartController.products.isEmpty) return SizedBox.shrink();
                return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FButton(
                      onPress: () => Get.toNamed('/checkout'),
                      style: contextTheme.buttonStyles.primary.copyWith(
                        contentStyle: contextTheme
                            .buttonStyles.primary.contentStyle
                            .copyWith(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      label: Text(
                        'Checkout'.tr,
                        style: contextTheme.typography.sm.copyWith(
                          color: contextTheme.typography.sm.color,
                        ),
                      ),
                    ));
              }),
              // Padding(
              //     padding: const EdgeInsets.all(17.0),
              //     child: FButton(
              //       onPress: () => Get.toNamed('/checkout'),
              //       style: contextTheme.buttonStyles.primary.copyWith(
              //         contentStyle:
              //             contextTheme.buttonStyles.primary.contentStyle.copyWith(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 12,
              //             vertical: 10,
              //           ),
              //         ),
              //       ),
              //       label: Text(
              //         'Checkout'.tr,
              //         style: contextTheme.typography.sm.copyWith(
              //           color: contextTheme.typography.sm.color,
              //         ),
              //       ),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
