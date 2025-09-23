import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/a/ui/loader_view.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class CartView extends StatelessWidget {
  final cartController = Get.find<CartController>();
  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyController = Get.find<CurrencyController>();
    final authController = Get.put(AuthController());
    final contextTheme = FTheme.of(context);
    final shopId = dotenv.env['SHOP_ID'];
    final baseUrl = dotenv.env['BASE_URL'];

    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FButton.icon(
                    onPress: () => Get.toNamed("/"),
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
                      return const SizedBox(width: 39);
                    }
                    return FButton.icon(
                      onPress: () => cartController.products.clear(),
                      style: FButtonStyle.outline,
                      child: Padding(
                        padding: EdgeInsets.all(2),
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

            // Cart content
            Obx(() {
              // Login check
              if (!authController.isLoggedIn.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/360_F_241431868_8DFQpCcmpEPVG0UvopdztOAd4a6Rqsoo-removebg-preview.png",
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Please login to view your Cart",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FButton(
                          style: contextTheme.buttonStyles.primary.copyWith(
                            contentStyle: contextTheme
                                .buttonStyles.primary.contentStyle
                                .copyWith(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                          // style: FButtonStyle.primary,
                          onPress: () => Get.toNamed("/settings/profile"),
                          label: Text(
                            "Login Now",
                            style: contextTheme.typography.sm.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: contextTheme.typography.sm.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Loading check
              if (cartController.isLoading.value) {
                return Center(child: LoaderView());
              }

              // Empty cart check
              if (cartController.products.isEmpty) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: FButton(
                            style: contextTheme.buttonStyles.primary.copyWith(
                              contentStyle: contextTheme
                                  .buttonStyles.primary.contentStyle
                                  .copyWith(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            onPress: () => Get.toNamed("/"),
                            label: Text(
                              "Continue Shopping",
                              style: contextTheme.typography.sm.copyWith(
                                fontSize: 17,
                                color: contextTheme.typography.sm.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Cart items list
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    FTileGroup.builder(
                      count: cartController.products.length,
                      divider: FTileDivider.full,
                      tileBuilder: (context, index) {
                        final product = cartController.products[index];
                        return Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: product.isSelected.value,
                                  onChanged: (val) =>
                                      cartController.toggleProductSelection(
                                          product, val ?? false),
                                )),
                            Expanded(
                              child: FTile(
                                prefixIcon: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      "$baseUrl/image/$shopId/${product.image}",
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        width: 60,
                                        height: 60,
                                        color:
                                            contextTheme.colorScheme.background,
                                        child: Center(
                                          child: FIcon(
                                            FAssets.icons.image,
                                            size: 24,
                                            color:
                                                contextTheme.colorScheme.border,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(product.title ?? ''),
                                subtitle: Text(
                                  product.variant.isNotEmpty
                                      ? product.variant
                                          .map((v) => v.options.join(","))
                                          .join('>')
                                      : (product.options.isNotEmpty
                                          ? product.options
                                          : 'No options'),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          spacing: 2,
                                          children: [
                                            Text(
                                              currencyController.formatCurrency(
                                                  product.price.toDouble()),
                                              style: contextTheme.typography.sm,
                                            ),
                                            Text("×",
                                                style:
                                                    contextTheme.typography.sm),
                                            Text(
                                              product.quantity.toString(),
                                              style: contextTheme.typography.sm,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          currencyController.formatCurrency(
                                              product.subtotal.toDouble()),
                                          style: contextTheme.typography.lg
                                              .copyWith(
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                            color: contextTheme
                                                .colorScheme.primary,
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
                                              onPress: () async {
                                                if (product.quantity > 1) {
                                                  product.quantity--;
                                                  await cartController
                                                      .updateCartItem(
                                                    cartItemId:
                                                        product.cartItemId,
                                                    productId:
                                                        product.productId,
                                                    quantity: 1,
                                                    action: "dec",
                                                  );
                                                } else {
                                                  await cartController
                                                      .removeCartItem(
                                                    product.cartItemId,
                                                    product.productId,
                                                  );
                                                  cartController.products
                                                      .remove(product);
                                                  Fluttertoast.showToast(
                                                    msg: 'Item removed'.tr,
                                                    backgroundColor:
                                                        contextTheme.colorScheme
                                                            .primary,
                                                  );
                                                  HapticFeedback.vibrate();
                                                }
                                                cartController.products
                                                    .refresh();
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
                                              onPress: () async {
                                                product.quantity++;
                                                await cartController
                                                    .updateCartItem(
                                                  productId: product.productId,
                                                  quantity: 1,
                                                  action: "inc",
                                                  cartItemId:
                                                      product.cartItemId,
                                                );
                                                await cartController
                                                    .getUserCart();
                                                cartController.products
                                                    .refresh();
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
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Checkout button
                    FButton(
                      onPress: () => Get.toNamed('/checkout'),
                      style: contextTheme.buttonStyles.primary.copyWith(
                        contentStyle: contextTheme
                            .buttonStyles.primary.contentStyle
                            .copyWith(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      label: Text(
                        'Checkout'.tr,
                        style: contextTheme.typography.sm.copyWith(
                          color: contextTheme.typography.sm.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}


// class CartView extends StatelessWidget {
//   final cartController = Get.find<CartController>();
//   CartView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currencyController = Get.find<CurrencyController>();
//     final authController = Get.put(AuthController());
//     final cartController = Get.find<CartController>();
//     final contextTheme = FTheme.of(context);
//     final shopId = dotenv.env['SHOP_ID'];
//     final baseUrl = dotenv.env['BASE_URL'];
//     //   final homeController = Get.put(HomeController());

//     //cartController.getUserCart();
//     return Scaffold(
//       backgroundColor: contextTheme.colorScheme.background,
//       body: Container(
//         decoration: BoxDecoration(
//           color: contextTheme.colorScheme.background,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FButton.icon(
//                       onPress: () => Get.toNamed("/settings"),
//                       style: FButtonStyle.outline,
//                       child: FIcon(
//                         FAssets.icons.chevronLeft,
//                         size: 24,
//                       ),
//                     ),
//                     Text(
//                       'Cart'.tr.toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     ),
//                     Obx(() {
//                       // if (!authController.isLoggedIn.value) {
//                       //   return Center(
//                       //     child: Column(
//                       //       mainAxisAlignment: MainAxisAlignment.center,
//                       //       children: [
//                       //         Image.asset(
//                       //             "assets/flying-shopping-cart-bags-on-600nw-1878510373-removebg-preview.png",
//                       //             height: 100,
//                       //             width: 100),
//                       //         SizedBox(height: 16),
//                       //         Text(
//                       //           "Please login to view your Cart",
//                       //           style: TextStyle(fontSize: 18),
//                       //           textAlign: TextAlign.center,
//                       //         ),
//                       //         SizedBox(height: 16),
//                       //         Padding(
//                       //           padding: const EdgeInsets.all(20.0),
//                       //           child: FButton(
//                       //             style: FButtonStyle.primary,
//                       //             onPress: () =>
//                       //                 Get.toNamed("/settings/profile"),
//                       //             label: Text("Login Now",
//                       //                 style: contextTheme.typography.sm),
//                       //           ),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   );
//                       // }
//                       if (cartController.products.isEmpty) {
//                         return SizedBox(width: 39);
//                       }
//                       return FButton.icon(
//                         onPress: () => cartController.products.clear(),
//                         style: FButtonStyle.outline,
//                         child: Padding(
//                           padding: const EdgeInsets.all(2),
//                           child: FIcon(
//                             FAssets.icons.trash2,
//                             size: 20,
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),

//               // Obx(() {
//               //   if (cartController.isLoading.value ||
//               //       cartController.hasError.value) {
//               //     return Center(child: LoaderView());
//               //   }
//               //   if (cartController.calculateTotal() == 0.00) {
//               //     cartController.isLoading.value = false;
//               //   }
//               //   return Padding(
//               //     padding: const EdgeInsets.all(8.0),
//               //     child: FTile(
//               //       subtitle: Text('Subtotal'.tr),
//               //       title: Text(
//               //         currencyController.formatCurrency(
//               //           cartController.subtotal(),
//               //         ),
//               //         style: contextTheme.typography.lg.copyWith(
//               //           fontWeight: FontWeight.bold,
//               //           color: contextTheme.colorScheme.primary,
//               //         ),
//               //       ),
//               //       suffixIcon: Row(
//               //         mainAxisSize: MainAxisSize.min,
//               //         children: [
//               //           FButton(
//               //             onPress: () => Get.toNamed('/checkout'),
//               //             style: contextTheme.buttonStyles.primary.copyWith(
//               //               contentStyle: contextTheme
//               //                   .buttonStyles.primary.contentStyle
//               //                   .copyWith(
//               //                 padding: EdgeInsets.symmetric(
//               //                   horizontal: 12,
//               //                   vertical: 10,
//               //                 ),
//               //               ),
//               //             ),
//               //             label: Text(
//               //               'Checkout'.tr,
//               //               style: contextTheme.typography.sm.copyWith(
//               //                 color: contextTheme.typography.sm.color,
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   );
//               // }),
//               GetX<CartController>(
//                 builder: (controller) {
//                   if (!authController.isLoggedIn.value) {
//                     return Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Image.asset(
//                             "assets/360_F_241431868_8DFQpCcmpEPVG0UvopdztOAd4a6Rqsoo-removebg-preview.png",
//                             height: 100,
//                             width: 100,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             "Please login to view your Cart",
//                             style: TextStyle(fontSize: 18),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 16),
//                           Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: FButton(
//                               style: FButtonStyle.primary,
//                               onPress: () => Get.toNamed("/settings/profile"),
//                               label: Text(
//                                 "Login Now",
//                                 style: contextTheme.typography.sm,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (cartController.isLoading.value == true) {
//                     return Center(child: LoaderView());
//                   }

//                   if (controller.products.isEmpty) {
//                     return Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 70),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/imagecart-removebg-preview.png',
//                               width: 200,
//                               height: 200,
//                             ),
//                             // Icon(Icons.shopping_cart_outlined,
//                             //     size: 80,
//                             //     color: contextTheme.colorScheme.primary),
//                             const SizedBox(height: 10),
//                             Text(
//                               "No items in this cart!",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: contextTheme.typography.lg.color,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 60),
//                               child: FButton(
//                                   style: contextTheme.buttonStyles.primary
//                                       .copyWith(
//                                     contentStyle: contextTheme
//                                         .buttonStyles.primary.contentStyle
//                                         .copyWith(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 10,
//                                       ),
//                                     ),
//                                   ),
//                                   onPress: () {
//                                     Get.toNamed("/");
//                                   },
//                                   label: Text(
//                                     "Continue Shopping",
//                                     style: contextTheme.typography.sm.copyWith(
//                                       fontSize: 17,
//                                       color: contextTheme.typography.sm.color,
//                                     ),
//                                   )),
//                             ),

//                             // Expanded(
//                             //   child: FCard(
//                             //     child: Column(
//                             //       children: [
//                             //         TopBar(),
//                             //         Flexible(
//                             //           fit: FlexFit.loose,
//                             //           child: GetX<HomeController>(
//                             //               builder: (controller) {
//                             //             if (controller.isLoading.value) {
//                             //               return Center(
//                             //                   child: const LoaderView());
//                             //             }
//                             //             if (controller.hasError.value) {
//                             //               return ErrorView(
//                             //                 body: "Failed to load store",
//                             //                 solution: "Refresh again",
//                             //                 retry: controller.fetchSections,
//                             //               );
//                             //             }
//                             //             return ListView.separated(
//                             //               shrinkWrap: true,
//                             //               itemCount: controller.sections.length,
//                             //               padding: EdgeInsets.symmetric(
//                             //                   horizontal: 8, vertical: 2),
//                             //               separatorBuilder: (context, index) =>
//                             //                   SizedBox(height: 8),
//                             //               itemBuilder: (context, index) {
//                             //                 final sortedSections =
//                             //                     List<SectionModel>.from(
//                             //                         controller.sections)
//                             //                       ..sort((a, b) =>
//                             //                           a.index.compareTo(b.index));

//                             //                 final section = sortedSections[index];
//                             //                 switch (section.type) {
//                             //                   case SectionType.horizontalBrochure:
//                             //                     return HorizontalBrochure(
//                             //                         data: section.data);
//                             //                   case SectionType.collage:
//                             //                     return ProductCollage(
//                             //                         data: section.data);

//                             //                   default:
//                             //                     return SizedBox.shrink();
//                             //                 }
//                             //               },
//                             //             );
//                             //           }),
//                             //         ),
//                             //         //   SizedBox(height: 10),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       ),
//                     );
//                   }

                 
//                     return SingleChildScrollView(
//                       child: Padding(
//                         // padding: EdgeInsets.only(left: 30, right: 10),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 18.0,
//                         ),
//                         child: FTileGroup.builder(
//                           count: controller.products.length,
//                           divider: FTileDivider.full,
//                           tileBuilder: (context, index) {
//                             final product = controller.products[index];
//                             return Row(
//                               children: [
//                                 Obx(() => Checkbox(
//                                       value: product.isSelected.value,
//                                       onChanged: (val) =>
//                                           cartController.toggleProductSelection(
//                                               product, val ?? false),
//                                     )),
//                                 Expanded(
//                                   child: FTile(
//                                     prefixIcon: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(
//                                             8), // optional
//                                         color: Colors.grey[
//                                             200], // background jodi image load na hoy
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(4),
//                                         child: Image.network(
//                                           "$baseUrl/image/$shopId/${product.image}",
//                                           fit: BoxFit.cover,
//                                           //    product.image ?? '',
//                                           height: 50,
//                                           width: 50,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   Container(
//                                             width: 60,
//                                             height: 60,
//                                             color: FTheme.of(context)
//                                                 .colorScheme
//                                                 .background,
//                                             child: Center(
//                                               child: FIcon(
//                                                 FAssets.icons.image,
//                                                 size: 24,
//                                                 color: FTheme.of(context)
//                                                     .colorScheme
//                                                     .border,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     suffixIcon: Row(
//                                       spacing: 8,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Column(
//                                           spacing: 4,
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             Row(
//                                               spacing: 2,
//                                               children: [
//                                                 Text(
//                                                   currencyController
//                                                       .formatCurrency(product
//                                                           .price
//                                                           .toDouble()),
//                                                   style: contextTheme
//                                                       .typography.sm,
//                                                 ),
//                                                 Text(
//                                                   "×",
//                                                   style: contextTheme
//                                                       .typography.sm,
//                                                 ),
//                                                 Text(
//                                                   product.quantity.toString(),
//                                                   style: contextTheme
//                                                       .typography.sm,
//                                                 ),
//                                               ],
//                                             ),
//                                             Text(
//                                               currencyController.formatCurrency(
//                                                   product.subtotal.toDouble()),
//                                               // currencyController.formatCurrency(
//                                               //   product.price!.toDouble() *
//                                               //       product.quantity,
//                                               // ),
//                                               style: contextTheme.typography.lg
//                                                   .copyWith(
//                                                 height: 1,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: contextTheme
//                                                     .colorScheme.primary,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           child: Container(
//                                             color: contextTheme
//                                                 .colorScheme.primary,
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 FButton.icon(
//                                                   onPress: () async {
//                                                     if (product.quantity > 1) {
//                                                       product.quantity--;
//                                                       await cartController
//                                                           .updateCartItem(
//                                                         cartItemId:
//                                                             product.cartItemId,
//                                                         productId:
//                                                             product.productId,
//                                                         //    variantId: product.variantId,
//                                                         quantity: 1,
//                                                         action: "dec",
//                                                         // cartItemId: '',
//                                                       );
//                                                     } else {
//                                                       await cartController
//                                                           .removeCartItem(
//                                                         product.cartItemId,
//                                                         product.productId,
//                                                       );
//                                                       cartController.products
//                                                           .refresh();

//                                                       cartController.products
//                                                           .remove(product);
//                                                       // await cartController
//                                                       //     .updateCartItem(
//                                                       //   productId: product.productId,
//                                                       //   variantId: product.variantId,
//                                                       //   quantity: 1,
//                                                       //   action: "dec",
//                                                       // );
//                                                       Fluttertoast.showToast(
//                                                         msg: 'Item removed'.tr,
//                                                         backgroundColor:
//                                                             contextTheme
//                                                                 .colorScheme
//                                                                 .primary,
//                                                       );
//                                                       HapticFeedback.vibrate();
//                                                     }
//                                                     cartController.products
//                                                         .refresh();
//                                                   },
//                                                   style: FButtonStyle.primary,
//                                                   child: FIcon(
//                                                     product.quantity <= 1
//                                                         ? FAssets.icons.trash
//                                                         : FAssets.icons.minus,
//                                                     size: 12,
//                                                     color: contextTheme
//                                                         .colorScheme.foreground,
//                                                   ),
//                                                 ),
//                                                 FButton.icon(
//                                                   onPress: () async {
//                                                     // if (product.quantity <
//                                                     //     product.stock!.toInt()) {
//                                                     product.quantity++;
//                                                     await cartController
//                                                         .updateCartItem(
//                                                       productId:
//                                                           product.productId,
//                                                       //  variantId: product.variantId,
//                                                       quantity: 1,
//                                                       action: "inc",
//                                                       cartItemId:
//                                                           product.cartItemId,
//                                                     );
//                                                     await cartController
//                                                         .getUserCart();
//                                                     cartController.products
//                                                         .refresh();
//                                                     // // } else {
//                                                     //   Fluttertoast.showToast(
//                                                     //     msg: 'Out of stock'.tr,
//                                                     //     backgroundColor: Colors.red,
//                                                     //   );
//                                                     //   HapticFeedback.vibrate();
//                                                     // }
//                                                   },
//                                                   style: FButtonStyle.primary,
//                                                   child: FIcon(
//                                                     FAssets.icons.plus,
//                                                     size: 12,
//                                                     color: contextTheme
//                                                         .colorScheme.foreground,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     title: Text(product.title ?? ''),
//                                     subtitle: Text(
//                                       product.variant.isNotEmpty
//                                           ? product.variant
//                                               .map((v) => v.options.join(","))
//                                               .join('>')
//                                           : (product.options.isNotEmpty
//                                               ? product.options
//                                               : 'No options'),
//                                     ),

//                                     //
//                                     //  variant.options.join(', ')
//                                     //  subtitle: Text(product.variant ?? ''),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   }
                
//               ),
//               SizedBox(height: 10),
//               Obx(() {
//                 if (cartController.products.isEmpty) return SizedBox.shrink();
//                 return Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: FButton(
//                       onPress: () => Get.toNamed('/checkout'),
//                       style: contextTheme.buttonStyles.primary.copyWith(
//                         contentStyle: contextTheme
//                             .buttonStyles.primary.contentStyle
//                             .copyWith(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 10,
//                           ),
//                         ),
//                       ),
//                       label: Text(
//                         'Checkout'.tr,
//                         style: contextTheme.typography.sm.copyWith(
//                           color: contextTheme.typography.sm.color,
//                         ),
//                       ),
//                     ));
//               }),
//               // Padding(
//               //     padding: const EdgeInsets.all(17.0),
//               //     child: FButton(
//               //       onPress: () => Get.toNamed('/checkout'),
//               //       style: contextTheme.buttonStyles.primary.copyWith(
//               //         contentStyle:
//               //             contextTheme.buttonStyles.primary.contentStyle.copyWith(
//               //           padding: EdgeInsets.symmetric(
//               //             horizontal: 12,
//               //             vertical: 10,
//               //           ),
//               //         ),
//               //       ),
//               //       label: Text(
//               //         'Checkout'.tr,
//               //         style: contextTheme.typography.sm.copyWith(
//               //           color: contextTheme.typography.sm.color,
//               //         ),
//               //       ),
//               //     ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
