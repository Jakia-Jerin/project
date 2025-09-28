import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/a/controllers/product_mini_card.dart';
import 'package:theme_desiree/a/models/cart.dart';
import 'package:theme_desiree/a/models/product_mini_card.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/showcase/product_model.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class ProductMiniCard extends StatelessWidget {
  final ProductMiniCardModel data;
  ProductMiniCard({super.key, required this.data});

  final productMiniCardController = Get.put(ProductMiniCardController());
  final currencyController = Get.find<CurrencyController>();
  final cartController = Get.find<CartController>();
  final authController = Get.put(AuthController());
  final shopId = dotenv.env['SHOP_ID'];
  final baseUrl = dotenv.env['BASE_URL'];
  final showcaseController = Get.put(ShowcaseController());
  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    print("Navigating to /item with productId: ${data.id}");
    return FCard(
        style: FCardStyle(
          decoration: BoxDecoration(
            border: contextTheme.cardStyle.decoration.border,
            borderRadius: BorderRadius.circular(8),
          ),
          contentStyle: FCardContentStyle(
            subtitleTextStyle: TextStyle(),
            titleTextStyle: TextStyle(),
            padding: EdgeInsets.all(0),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Get.toNamed("/item", parameters: {"productId": data.id});
            print(
                "*************************************************************************");
            print("Navigating to /item with productId: ${data.id}");
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: (data.gallery.isNotEmpty)
                              ? Image.network(
                                  "$baseUrl/image/$shopId/${data.gallery[0]}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/pngtree-return-icon-image_1130841.jpg",
                                      // height: 150,
                                      // width: 150,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/pngtree-return-icon-image_1130841.jpg",
                                ),

                          // child: Image.network(
                          //   "$baseUrl/image/$shopId/${data.gallery[0]}",
                          //   errorBuilder: (context, error, stackTrace) {
                          //     return Image.asset("assets/download (1).jpg",
                          //         fit: BoxFit.cover);
                          //   },
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black38, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Text(
                              data.title,
                              maxLines: 2,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            currencyController
                                .formatCurrency(data.compareAtPrice.toDouble()),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontStyle: FontStyle.italic,
                                fontSize: 9,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      FBadge(
                        style: contextTheme.badgeStyles.primary.copyWith(
                          contentStyle: contextTheme
                              .badgeStyles.primary.contentStyle
                              .copyWith(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                          ),
                        ),
                        label: Obx(
                          () => Text(
                            currencyController
                                .formatCurrency(data.price.toDouble()),
                            style: TextStyle(
                              color: contextTheme.colorScheme.foreground,
                            ),
                          ),
                        ),
                      ),

                      // Add to Cart Button
                    ],
                  ),
                ),

                // --- Outer Button on Home Page ---
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: FButton(
                    onPress: () async {
                      final prodMini = data; // ProductMiniCardModel
                      final showcaseController = Get.put(ShowcaseController());

                      // 1️⃣ Fetch full product
                      await showcaseController.fetchProductByID(prodMini.id);

                      if (showcaseController.product.value == null) {
                        Fluttertoast.showToast(msg: "Product not found");
                        return;
                      }

                      // 2️⃣ Open BottomSheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor:
                            FTheme.of(context).colorScheme.background,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => ProductBottomSheet(),
                      );
                    },
                    style: contextTheme.buttonStyles.primary.copyWith(
                      contentStyle: contextTheme
                          .buttonStyles.primary.contentStyle
                          .copyWith(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                      ),
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Add to Cart'.tr,
                          style: contextTheme.typography.sm.copyWith(
                              color: contextTheme.typography.sm.color),
                        ),
                      ],
                    ),
                  ),
                )

                // Add to Cart Button
              ],
            ),
          ),
        ));
  }
}

// --- BottomSheet Widget ---
class ProductBottomSheet extends StatelessWidget {
  const ProductBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final showcaseController = Get.find<ShowcaseController>();
    final authController = Get.put(AuthController());
    final cartController = Get.put(CartController());
    final product = showcaseController.product.value!;
    final baseUrl = dotenv.env['BASE_URL'];
    final shopId = dotenv.env['SHOP_ID'];

    print("🟢 Opening BottomSheet for productId: ${product.id}");
    print("Title: ${product.title}");
    print("Price: ${product.price}, CompareAtPrice: ${product.compareAtPrice}");
    print("Variants count: ${product.variants.length}");

    // Set default variant after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showcaseController.selectedVariant.value == null &&
          product.variants.isNotEmpty) {
        final firstVariant = product.variants.first;
        showcaseController.selectedVariant.value = firstVariant;
        print("🔹 Default variant selected: ${firstVariant.id}");
        for (int i = 0; i < firstVariant.options.length; i++) {
          showcaseController.setOption(i, firstVariant.options[i]);
          print("  ➡ Option set: ${firstVariant.options[i]}");
        }
      }
    });

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image + Title + Price
            Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Image.network(
                    product.images.isNotEmpty
                        ? "$baseUrl/image/$shopId/${product.featuredImage}"
                        : "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print("⚠️ Image failed to load, using placeholder");
                      return Image.asset('assets/download (1).jpg');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("৳ ${product.price}"),
                      Text(
                        "৳ ${product.compareAtPrice}",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Variant Selection
            ...product.variants.map((variant) {
              final rowIndex = product.variants.indexOf(variant);
              print(
                  "🔸 Variant: ${variant.title}, Options: ${variant.options}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (variant.title != null && variant.title!.isNotEmpty)
                    Text(variant.title!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: variant.options.map((opt) {
                      return Obx(() => ChoiceChip(
                            label: Text(opt),
                            selected: showcaseController
                                    .selectedOptions[rowIndex]?.value ==
                                opt,
                            onSelected: (_) {
                              showcaseController.setOption(rowIndex, opt);
                              print(
                                  "✅ Option selected for variant $rowIndex: $opt");
                            },
                          ));
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Add to Cart Button
            FButton(
              onPress: () {
                final product = showcaseController.product.value;
                final selectedOptions = showcaseController.selectedOptions;

                if (product == null) {
                  print(" Product is null, cannot add to cart");
                  return;
                }

                // Check if all variants have been selected
                if (selectedOptions.length != product.variants.length ||
                    selectedOptions.values.any((rx) => rx.value.isEmpty)) {
                  Fluttertoast.showToast(
                    msg: 'Please choose option'.tr,
                    backgroundColor: FTheme.of(context).colorScheme.primary,
                  );
                  print(" Not all variants selected!");
                  return;
                }

                // Build variants array
                final variantsBody = selectedOptions.entries.map((entry) {
                  final variant = product.variants[entry.key];
                  final selectedOption = entry.value.value;
                  print(
                      "➡️ Variant selected: ${variant.title} => $selectedOption");
                  return {
                    "variantId": variant.id,
                    "name": variant.title,
                    "option": selectedOption,
                  };
                }).toList();

                // Build CartItem
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
                  price: product.price,
                  subtotal: (product.price) * 1,
                  isAvailable: product.available ?? product.available,
                  quantity: 1,
                  options: variantsBody.map((v) => v["option"]).join(" > "),
                  shop: cartController.vendorId,
                );

                print("🛒 CartItem ready: ${cartItem.toJson()}");

                if (authController.isLoggedIn.value) {
                  Fluttertoast.showToast(
                    msg: 'Added to cart'.tr,
                    backgroundColor: FTheme.of(context).colorScheme.primary,
                  );
                  HapticFeedback.vibrate();
                } else {
                  Fluttertoast.showToast(
                    msg: 'Please Login to add Product'.tr,
                    backgroundColor: FTheme.of(context).colorScheme.primary,
                  );
                  HapticFeedback.vibrate();
                }

                cartController.handleAddToCart(cartItem);
                print("✅ Item added to cart");
              },
              label: Text("Add to Cart"),
            )
          ],
        ));
  }
}
