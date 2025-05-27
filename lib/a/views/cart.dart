import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
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
          Obx(() {
            if (cartController.isLoading.value ||
                cartController.hasError.value) {
              return Center(child: LoaderView());
            }
            if (cartController.calculateTotal() == 0.00) null;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FTile(
                subtitle: Text('Subtotal'.tr),
                title: Text(
                  currencyController.formatCurrency(
                    cartController.calculateTotal(),
                  ),
                  style: contextTheme.typography.lg.copyWith(
                    fontWeight: FontWeight.bold,
                    color: contextTheme.colorScheme.primary,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FButton(
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
                    ),
                  ],
                ),
              ),
            );
          }),
          GetX<CartController>(
            builder: (controller) {
              if (controller.products.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Cart is empty'.tr,
                      style: contextTheme.typography.base.copyWith(
                        color:
                            contextTheme.colorScheme.foreground.withAlpha(100),
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: SingleChildScrollView(
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
                                    style: contextTheme.typography.lg.copyWith(
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
