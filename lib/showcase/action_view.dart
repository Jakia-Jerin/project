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

    // আলাদা করে colors এবং sizes বের করি
    final colorVariants = variants
        .where((v) => v.options.any((o) => o.contains(RegExp(r'[a-zA-Z]'))))
        .toList();
    final sizeVariants = variants
        .where((v) => v.options.any((o) => o.contains(RegExp(r'\d'))))
        .toList();

    // selected color & size
    final selectedColor = showcaseController.selectedOptions['color'].obs;
    final selectedSize = showcaseController.selectedOptions['size'].obs;
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
                  FButton(
                    onPress: () {},
                    style: FButtonStyle.outline,
                    label:
                        Text(isAvailable ? 'In stock'.tr : 'Limited stock'.tr),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyController.formatCurrency(displayPrice),
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

          FDivider(
            style: FTheme.of(context)
                .dividerStyles
                .horizontalStyle
                .copyWith(padding: EdgeInsets.zero),
          ),

          // --- Options Selection ---
          // --- Options Selection ---
          // Obx(() {
          //   final productVariants =
          //       showcaseController.product.value?.variants ?? [];
          //   if (productVariants.isEmpty) return SizedBox.shrink();

          //   // Keep track of selected option per row
          //   final RxList<String?> selectedOptions =
          //       List.generate(options.length, (_) => null).obs;

          //   return Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: List.generate(options.length, (index) {
          //         // Filter variants based on previous selections
          //         final validVariants = productVariants.where((v) {
          //           for (int j = 0; j < index; j++) {
          //             if (selectedOptions[j] != null &&
          //                 selectedOptions[j] != v.options[j]) return false;
          //           }
          //           return true;
          //         }).toList();

          //         // Get unique options for this row
          //         final uniqueOptions = validVariants
          //             .map((v) => v.options[index])
          //             .toSet()
          //             .toList();

          //         return Padding(
          //           padding: const EdgeInsets.only(bottom: 8.0),
          //           child: Wrap(
          //             spacing: 8,
          //             children: uniqueOptions.map((opt) {
          //               final isSelected = selectedOptions[index] == opt;

          //               return GestureDetector(
          //                 onTap: () {
          //                   // Select only this option for this row
          //                   selectedOptions[index] = opt;

          //                   // Reset all later selections
          //                   for (int k = index + 1;
          //                       k < selectedOptions.length;
          //                       k++) {
          //                     selectedOptions[k] = null;
          //                   }

          //                   // Update selectedVariant based on current selections
          //                   final matchedVariant = productVariants.firstWhere(
          //                     (v) => ListEquality()
          //                         .equals(v.options, selectedOptions),
          //                     orElse: () => productVariants.first,
          //                   );

          //                   showcaseController.selectedVariant.value =
          //                       matchedVariant;
          //                 },
          //                 child: FBadge(
          //                   style: isSelected
          //                       ? FBadgeStyle.primary
          //                       : FBadgeStyle.outline,
          //                   label: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text(opt),
          //                   ),
          //                 ),
          //               );
          //             }).toList(),
          //           ),
          //         );
          //       }),
          //     ),
          //   );
          // }),
          if (colorVariants.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Color'),
                  Obx(() => Wrap(
                        spacing: 8,
                        children: colorVariants.expand((v) {
                          return v.options.map((color) {
                            final isSelected = selectedColor.value == color;
                            return GestureDetector(
                              onTap: () {
                                selectedColor.value = color;
                                showcaseController.selectedOptions['color'] =
                                    color;
                              },
                              child: FBadge(
                                style: isSelected
                                    ? FBadgeStyle.primary
                                    : FBadgeStyle.outline,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(color),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      )),
                ],
              ),
            ),

          // Sizes
          if (sizeVariants.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size'),
                  Obx(() => Wrap(
                        spacing: 8,
                        children: sizeVariants.expand((v) {
                          return v.options.map((size) {
                            final isSelected = selectedSize.value == size;
                            return GestureDetector(
                              onTap: () {
                                selectedSize.value = size;
                                showcaseController.selectedOptions['size'] =
                                    size;
                              },
                              child: FBadge(
                                style: isSelected
                                    ? FBadgeStyle.primary
                                    : FBadgeStyle.outline,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(size),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      )),
                ],
              ),
            ),

          // Obx(() {
          //   final selectedVariant = showcaseController.selectedVariant.value;

          //   if (selectedVariant == null || selectedVariant.options.isEmpty) {
          //     return SizedBox.shrink();
          //   }

          //   return Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children:
          //           List.generate(selectedVariant.options.length, (index) {
          //         // Filter matched variants based on previous selections
          //         List<VariantModel> matchedVariants = showcaseController
          //             .product.value!.variants
          //             .where((variant) {
          //           if (index == 0) {
          //             return true; // first attribute: all variants show
          //           }
          //           final previousSelected =
          //               selectedVariant.options.sublist(0, index);
          //           final previousVariant = variant.options.sublist(0, index);
          //           return ListEquality()
          //               .equals(previousSelected, previousVariant);
          //         }).toList();

          //         // Sort matchedVariants: selected option first
          //         matchedVariants.sort((a, b) {
          //           final aOption =
          //               a.options.length > index ? a.options[index] : '';
          //           final bOption =
          //               b.options.length > index ? b.options[index] : '';
          //           final selectedOption = selectedVariant.options[index];

          //           if (aOption == selectedOption &&
          //               bOption != selectedOption) {
          //             return -1;
          //           }
          //           if (aOption != selectedOption &&
          //               bOption == selectedOption) {
          //             return 1;
          //           }
          //           return 0;
          //         });

          //         return Padding(
          //           padding: const EdgeInsets.only(bottom: 8.0),
          //           child: SingleChildScrollView(
          //             scrollDirection: Axis.horizontal,
          //             child: Wrap(
          //               spacing: 8,
          //               children: matchedVariants.map((variant) {
          //                 final variantOption = index < variant.options.length
          //                     ? variant.options[index]
          //                     : '';

          //                 final isSelected =
          //                     selectedVariant.options[index] == variantOption;

          //                 return GestureDetector(
          //                   onTap: () {
          //                     showcaseController.selectedVariant.value =
          //                         variant;
          //                   },
          //                   child: FBadge(
          //                     style: isSelected
          //                         ? FBadgeStyle.primary
          //                         : FBadgeStyle.outline,
          //                     label: Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child: Text(variantOption),
          //                     ),
          //                   ),
          //                 );
          //               }).toList(),
          //             ),
          //           ),
          //         );
          //       }),
          //     ),
          //   );
          // }),

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
                      final currentVariant =
                          showcaseController.selectedVariant.value;
                      final product = showcaseController.product.value;

                      if (product == null) return;

                      // 1️⃣ Create CartModel
                      final cartItem = CartModel(
                         cartItemId: '',
                          productId: product.id,
                          //  variantId: selectedVariant?.id ?? '',
                          variantId: currentVariant?.id ?? '',
                          title: product.title,
                          variant:
                              '${showcaseController.selectedOptions['color']}, ${showcaseController.selectedOptions['size']}',
                          // variant: currentVariant?.options.join(" >") ?? '',
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
                              '${showcaseController.selectedOptions['color']} > ${showcaseController.selectedOptions['size']}',
                          shop: cartController.vendorId);

                      //  Call centralized helper
                      cartController.handleAddToCart(
                        cartItem,
                        option:
                            "${showcaseController.selectedOptions['color']}, ${showcaseController.selectedOptions['size']}",
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
                    style: FButtonStyle.outline,
                    label: Text('Add to cart'.tr),
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
                Expanded(
                  child: FButton(
                    onPress: () {},
                    style: FButtonStyle.primary,
                    label: Text('Buy now'.tr),
                  ),
                ),
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
