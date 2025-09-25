import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/showcase/product_model.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class ActionView extends StatelessWidget {
  final bool available;
  final List<VariantModel> variants;
  final List<String> options;
  final int price;
  final int compareAtPrice;

  const ActionView({
    super.key,
    required this.available,
    required this.variants,
    required this.options,
    required this.price,
    required this.compareAtPrice,
  });

  @override
  Widget build(BuildContext context) {
    final currencyController = Get.find<CurrencyController>();
    final showcaseController = Get.find<ShowcaseController>();
    final cartController = Get.find<CartController>();
    final authController = Get.put(AuthController());
    final contextTheme = FTheme.of(context);
    //   final letterSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

    // final colorVariants = variants
    //     .where((v) => v.options.any((o) => o.contains(RegExp(r'[a-zA-Z]'))))
    //     .toList();

    // final sizeVariants = variants.where((v) {
    //   return v.options
    //       .any((o) => letterSizes.contains(o) || RegExp(r'^\d+$').hasMatch(o));
    // }).toList();
    // final selectedColor = showcaseController.selectedColor.value.obs;
    // final selectedSize = showcaseController.selectedSize.value.obs;

    // selected color & size

    final product = showcaseController.product.value!;

    // final colorVariants =
    //     product.variants.where((v) => v.optionsType == 'color').toList();
    // final sizeVariants =
    //     product.variants.where((v) => v.optionsType == 'size').toList();
    // final selectedColor = showcaseController.selectedOptions['color'].obs;
    // final selectedSize = showcaseController.selectedOptions['size'].obs;

    // select 1st varinat

    return FCard(
      style: FTheme.of(context).cardStyle.copyWith(
            contentStyle: FTheme.of(context).cardStyle.contentStyle.copyWith(
                  padding: EdgeInsets.zero,
                ),
          ),
      child: Column(
        children: [
          // --- Price & Stock Row ---
          Padding(
            padding: const EdgeInsets.all(8),
            child: Obx(() {
              final selectedVariant = showcaseController.selectedVariant.value;

              // Null-safe values
              final isAvailable = selectedVariant?.available ?? available;
              final displayPrice =
                  (selectedVariant?.price['base'] ?? price).toDouble();
              final displayCompare =
                  (selectedVariant?.price['compareAt'] ?? compareAtPrice)
                      .toDouble();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // FButton(
                  //   onPress: () {},
                  //   style: FButtonStyle.outline,
                  //   label:
                  //       Text(isAvailable ? 'In stock'.tr : 'Limited stock'.tr),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Price: ৳${currencyController.formatCurrency(displayPrice)}",
                        style: FTheme.of(context).typography.xl.copyWith(
                              color: FTheme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (displayCompare > 0)
                        Text(
                          currencyController.formatCurrency(displayCompare),
                          style: FTheme.of(context).typography.sm.copyWith(
                                color: FTheme.of(context)
                                    .colorScheme
                                    .mutedForeground,
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                    ],
                  )
                ],
              );
            }),
          ),
          SizedBox(
            height: 3,
          ),
          FDivider(
            style: FTheme.of(context)
                .dividerStyles
                .horizontalStyle
                .copyWith(padding: EdgeInsets.zero),
          ),

          // Color selection
          Obx(() {
            final prod = showcaseController.product.value;
            if (prod == null) return Container();

            return Column(
              children: List.generate(prod.variants.length, (rowIndex) {
                final variant = prod.variants[rowIndex];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8, // horizontal gap
                    runSpacing: 8, // vertical gap if wrapped
                    children: variant.options.map((opt) {
                      final isSelected =
                          showcaseController.selectedOptions[rowIndex]?.value ==
                              opt;

                      return GestureDetector(
                        onTap: () =>
                            showcaseController.setOption(rowIndex, opt),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FBadge(
                            style: isSelected
                                ? FBadgeStyle.primary
                                : FBadgeStyle.outline,
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(opt),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            );
          }),

          FDivider(
            style: FTheme.of(context)
                .dividerStyles
                .horizontalStyle
                .copyWith(padding: EdgeInsets.zero),
          ),

          // --- Add to Cart & Buy Now Buttons ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Flex(
              direction: Axis.horizontal,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FButton(
                    onPress: () {
//                       final currentVariant =
//                           showcaseController.selectedVariant.value;
//                       final product = showcaseController.product.value;

//                       if (product == null) return;

// // 1️⃣ Create CartModel
//                       final cartItem = CartModel(
//                           cartItemId: '',
//                           productId: product.id,
//                           variantId:
//                               cartController.selectedVariantIds.isNotEmpty
//                                   ? cartController.selectedVariantIds
//                                   : [],
//                           title: product.title,
//                           variant:
//                               currentVariant != null ? [currentVariant] : [],
//                           // List<VariantModel>
//                           // variant:
//                           //     '${showcaseController.selectedOptions['color']}, ${showcaseController.selectedOptions['size']}',
//                           // variant: currentVariant?.options.join(" >") ?? '',
//                           image: product.featuredImage,
//                           stock: 10,
//                           price: currentVariant?.price['base'] ?? product.price,
//                           subtotal:
//                               (currentVariant?.price['base'] ?? product.price) *
//                                   1,
//                           isAvailable:
//                               currentVariant?.available ?? product.available,
//                           quantity: 1,
//                           options: showcaseController.selectedOptions.entries
//                               .map((e) => e.value
//                                   .value) // get selected value for each option type
//                               .join(' >'),

//                           // options:
//                           //     '${showcaseController.selectedOptions['color']} > ${showcaseController.selectedOptions['size']}',
//                           shop: cartController.vendorId);
//                       final currentVariant =
//                           showcaseController.selectedVariant.value;
//                       final product = showcaseController.product.value;

//                       if (product == null) return;

// // Build variantsBody like [{id: v1, option: Red}, {id: v1, option: M}]
//                       final variantsBody = <Map<String, dynamic>>[];
//                       if (currentVariant != null) {
//                         showcaseController.selectedOptions
//                             .forEach((rowIndex, rxOption) {
//                           final selectedOption = rxOption.value;
//                           if (selectedOption.isNotEmpty) {
//                             variantsBody.add({
//                               "id": currentVariant.id,
//                               "option": selectedOption,
//                             });
//                           }
//                         });
//                       }

// // 1️⃣ Create CartModel
//                       final cartItem = CartModel(
//                         cartItemId: '',
//                         productId: product.id,
//                         variantId: variantsBody
//                             .map((v) => v["id"].toString())
//                             .toList(),
//                         title: product.title,
//                         variant: variantsBody
//                             .map((v) => VariantModel(
//                                   id: v["id"].toString(),
//                                   title: null, // optional
//                                   options: [v["option"].toString()],
//                                   price: {},
//                                   available: true,
//                                 ))
//                             .toList(),
//                         image: product.featuredImage,
//                         stock: 10,
//                         price: currentVariant?.price['base'] ?? product.price,
//                         subtotal:
//                             (currentVariant?.price['base'] ?? product.price) *
//                                 1,
//                         isAvailable:
//                             currentVariant?.available ?? product.available,
//                         quantity: 1,
//                         options:
//                             variantsBody.map((v) => v["option"]).join(" > "),
//                         shop: cartController.vendorId,
//                       );

                      final currentVariant =
                          showcaseController.selectedVariant.value;
                      final product = showcaseController.product.value;

                      if (product == null) {
                        print("❌ Product is null, cannot add to cart");
                        return;
                      }
                      // if (showcaseController.selectedVariant.value == null &&
                      //     showcaseController.product.value != null &&
                      //     showcaseController
                      //         .product.value!.variants.isNotEmpty) {
                      //   final firstVariant =
                      //       showcaseController.product.value!.variants.first;
                      //   showcaseController.selectedVariant.value = firstVariant;
                      //   if (firstVariant.options.isNotEmpty) {
                      //     for (int i = 0;
                      //         i < firstVariant.options.length;
                      //         i++) {
                      //       showcaseController.setOption(
                      //           i, firstVariant.options[i]);
                      //     }
                      //   }
                      // }

// Build variantsBody like [{id: v1, option: Red}, {id: v2, option: M}]
                      final variantsBody = <Map<String, dynamic>>[];
                      if (currentVariant != null) {
                        showcaseController.selectedOptions
                            .forEach((rowIndex, rxOption) {
                          final selectedOption = rxOption.value;
                          print(
                              "➡️ Selected option at row=$rowIndex => $selectedOption");
                          if (selectedOption.isNotEmpty) {
                            variantsBody.add({
                              "id": currentVariant.id,
                              "option": selectedOption,
                            });
                          }
                        });
                      }

                      print("📝 Final variantsBody from UI: $variantsBody");

// 1️⃣ Create CartModel
                      final cartItem = CartModel(
                        cartItemId: '',
                        productId: product.id,
                        variantId: variantsBody
                            .map((v) => v["variantId"].toString())
                            .toList(),
                        title: product.title,
                        variant: variantsBody
                            .map((v) => VariantModel(
                                  id: v["variantId"].toString(),
                                  title: null,
                                  options: [v["option"].toString()],
                                  price: {},
                                  available: true,
                                ))
                            .toList(),
                        image: product.featuredImage,
                        stock: 10,
                        price: currentVariant?.price['base'] ?? product.price,
                        subtotal:
                            (currentVariant?.price['base'] ?? product.price) *
                                1,
                        isAvailable:
                            currentVariant?.available ?? product.available,
                        quantity: 1,
                        options:
                            variantsBody.map((v) => v["option"]).join(" > "),
                        shop: cartController.vendorId,
                      );

                      print("🛒 CartItem ready: ${cartItem.toJson()}");

                      //  Call centralized helper
                      cartController.handleAddToCart(
                        cartItem,
                        // option: showcaseController.selectedOptions.entries
                        //     .map((e) => e.value.value)
                        //     .join(' >')
                        // "${showcaseController.selectedOptions['color']}, ${showcaseController.selectedOptions['size']}",
                      );
                      if (authController.isLoggedIn.value) {
                        Fluttertoast.showToast(
                          msg: 'Added to cart'.tr,
                          backgroundColor:
                              FTheme.of(context).colorScheme.primary,
                        );
                        HapticFeedback.vibrate();
                      }
                    },
                    style: contextTheme.buttonStyles.primary.copyWith(
                      contentStyle: contextTheme
                          .buttonStyles.primary.contentStyle
                          .copyWith(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                    label: Text(
                      'Add to cart'.tr,
                      style: contextTheme.typography.sm.copyWith(
                        fontSize: 15,
                        color: contextTheme.typography.sm.color,
                      ),
                    ),
                  ),
                ),

                // Expanded(
                //   child: FButton(
                //     onPress: () {
                //       final currentVariant =
                //           showcaseController.selectedVariant.value;
                //       final product = showcaseController.product.value;

                //       if (product == null) return;

                //       cartController.addProductToServer(CartModel(
                //         productId: product.id,
                //         variantId: currentVariant?.id ?? '',
                //         title: product.title,
                //         variant: currentVariant?.options.join(" >") ?? '',
                //         image: product.featuredImage,
                //         stock: 10,
                //         price: currentVariant?.price['base'] ?? product.price,
                //         isAvailable:
                //             currentVariant?.available ?? product.available,
                //         quantity: 1,
                //       ),

                //           // productId: product.id,
                //           // variantId: currentVariant?.id ?? '',
                //           // title: product.title,
                //           // variant: currentVariant?.options.join(" >") ?? '',
                //           // image: product.featuredImage,
                //           // stock: 10,
                //           // price: currentVariant?.price['base'] ?? product.price,
                //           // isAvailable:
                //           //     currentVariant?.available ?? product.available,
                //           );
                //       if (authController.isLoggedIn.value) {
                //         Fluttertoast.showToast(
                //           msg: 'Added to cart'.tr,
                //           backgroundColor:
                //               FTheme.of(context).colorScheme.primary,
                //         );
                //         HapticFeedback.vibrate();
                //       }
                //     },
                //     style: FButtonStyle.outline,
                //     label: Text('Add to cart'.tr),
                //   ),
                // ),
                // Expanded(
                //   child: FButton(
                //     onPress: () {},
                //     style: FButtonStyle.primary,
                //     label: Text('Buy now'.tr),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ActionView extends StatelessWidget {
//   final bool available;
//   final List<VariantModel> variants;
//   final List<String> options;
//   final int price;
//   final int compareAtPrice;

//   const ActionView(
//       {super.key,
//       required this.available,
//       required this.variants,
//       required this.options,
//       required this.price,
//       required this.compareAtPrice});

//   @override
//   Widget build(BuildContext context) {
//     final currencyController = Get.find<CurrencyController>();
//     final showcaseController = Get.find<ShowcaseController>();
//     final cartController = Get.find<CartController>();

//     double priceDouble =
//         showcaseController.product.value?.price.toDouble() ?? 0.0;
//     double compareDouble =
//         showcaseController.product.value?.compareAtPrice.toDouble() ?? 0.0;
//     return FCard(
//       style: FTheme.of(context).cardStyle.copyWith(
//             contentStyle: FTheme.of(context).cardStyle.contentStyle.copyWith(
//                   padding: EdgeInsets.zero,
//                 ),
//           ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Obx(() {
//               final selectedVariant = showcaseController.selectedVariant.value;

//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   FButton(
//                     onPress: () {},
//                     style: FButtonStyle.outline,
//                     label: Text(
//                       selectedVariant!.available
//                           ? 'In stock'.tr
//                           : 'Limited stock'.tr,
//                       style: FTheme.of(context).typography.base.copyWith(
//                             fontStyle: FontStyle.italic,
//                             height: 1,
//                           ),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         currencyController.formatCurrency(priceDouble),
//                         // currencyController.formatCurrency(
//                         //     showcaseController.product.value!.price.toDouble()),
//                         style: FTheme.of(context).typography.xl.copyWith(
//                               color: FTheme.of(context).colorScheme.primary,
//                               fontWeight: FontWeight.bold,
//                               height: 1.2,
//                             ),
//                       ),
//                       Text(
//                         currencyController.formatCurrency(compareDouble),
//                         // currencyController.formatCurrency(showcaseController
//                         //     .product.value!.compareAtPrice
//                         //     .toDouble()),
//                         style: FTheme.of(context).typography.sm.copyWith(
//                               color: FTheme.of(context)
//                                   .colorScheme
//                                   .mutedForeground,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                       ),
//                       // Text(
//                       //   currencyController.formatCurrency(
//                       //       (showcaseController.product.value!.price as num).toDouble()),
//                       //   style: FTheme.of(context).typography.xl.copyWith(
//                       //         color: FTheme.of(context).colorScheme.primary,
//                       //         fontWeight: FontWeight.bold,
//                       //         height: 1.2,
//                       //       ),
//                       // ),
//                       // Text(
//                       //   currencyController.formatCurrency(
//                       //     (showcaseController.product.value!.compareAtPrice ?? 0) as double
//                       //   ),
//                       //   style: FTheme.of(context).typography.sm.copyWith(
//                       //         color: FTheme.of(context)
//                       //             .colorScheme
//                       //             .mutedForeground,
//                       //         fontWeight: FontWeight.bold,
//                       //         decoration: TextDecoration.lineThrough,
//                       //       ),
//                       // ),
//                     ],
//                   )
//                 ],
//               );
//             }),
//           ),
//           FDivider(
//             style: FTheme.of(context)
//                 .dividerStyles
//                 .horizontalStyle
//                 .copyWith(padding: EdgeInsets.zero),
//           ),
//           Obx(() {
//             final selectedVariant = showcaseController.selectedVariant.value;

//             return Padding(
//               padding: const EdgeInsets.all(10),
//               child: ListView.builder(
//                 itemCount: options.length,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   Set<String> seenOptions = {};
//                   List<VariantModel> matchedVariants = variants.where((item) {
//                     if (index == 0) {
//                       if (!seenOptions.contains(item.options[0])) {
//                         seenOptions.add(item.options[index]);
//                         return ListEquality().equals(
//                             item.options.sublist(0, index),
//                             selectedVariant!.options.sublist(0, index));
//                       } else {
//                         return false;
//                       }
//                     } else {
//                       return ListEquality().equals(
//                           item.options.sublist(0, index),
//                           selectedVariant!.options.sublist(0, index));
//                     }
//                   }).toList();

//                   return Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Flex(
//                         direction: Axis.horizontal,
//                         spacing: 8,
//                         children: List.generate(matchedVariants.length, (i) {
//                           return GestureDetector(
//                             onTap: () {
//                               showcaseController.selectedVariant.value =
//                                   matchedVariants[i];
//                             },
//                             child: FBadge(
//                               style: selectedVariant!.options[index] ==
//                                       matchedVariants[i].options[index]
//                                   ? FBadgeStyle.primary
//                                   : FBadgeStyle.outline,
//                               label: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   matchedVariants[i].options[index].toString(),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }),
//           FDivider(
//             style: FTheme.of(context)
//                 .dividerStyles
//                 .horizontalStyle
//                 .copyWith(padding: EdgeInsets.zero),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Flex(
//               direction: Axis.horizontal,
//               spacing: 8,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: FButton(
//                     onPress: () {
//                       cartController.addProduct(
//                         productId:
//                             showcaseController.product.value!.id.toString(),
//                         variantId: showcaseController.selectedVariant.value!.id
//                             .toString(),
//                         title: showcaseController.product.value!.title,
//                         variant: showcaseController
//                             .selectedVariant.value?.options
//                             .join(" > "),
//                         image: showcaseController.product.value!.featuredImage,
//                         stock: 10,
//                         price:
//                             showcaseController.selectedVariant.value?.price ??
//                                 showcaseController.product.value!.price,
//                         isAvailable: showcaseController
//                                 .selectedVariant.value?.available ??
//                             showcaseController.product.value!.available,
//                       );
//                       Fluttertoast.showToast(
//                         msg: 'Added to cart'.tr,
//                         backgroundColor: FTheme.of(context).colorScheme.primary,
//                       );
//                       HapticFeedback.vibrate();
//                     },
//                     style: FButtonStyle.outline,
//                     label: Text('Add to cart'.tr),
//                   ),
//                 ),
//                 Expanded(
//                   child: FButton(
//                     onPress: () {},
//                     style: FButtonStyle.primary,
//                     label: Text('Buy now'.tr),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
