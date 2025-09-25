import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/showcase/action_view.dart';
import 'package:theme_desiree/showcase/image_slider.dart';
import 'package:theme_desiree/showcase/product_label.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';

class ShowcaseView extends StatelessWidget {
  const ShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final ShowcaseController controller = Get.put(ShowcaseController());
    final productId = Get.parameters['productId'] ?? '';
    final contextTheme = FTheme.of(context);

    print("ShowcaseView productId: $productId");

    final shopId = dotenv.env['SHOP_ID'];
    final baseUrl = dotenv.env['BASE_URL'];
    //    final productId = Get.parameters['productId'] ?? '';
    print("??????????????????????????????????????????????????");
    print("ShowcaseView productId: $productId"); // debug

    // if (productId.isEmpty) {
    //   return Center(child: Text("No product selected"));
    // }
    // Call API explicitly after controller instantiation
    if (productId.isNotEmpty && controller.product.value == null) {
      controller.fetchProductByID(productId);
    }

    if (productId.isEmpty) {
      return Center(child: Text("No product selected"));
    }

    return GetX<ShowcaseController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.hasError.value) {
          return Center(child: Text("Error loading product"));
        }

        final product = controller.product.value;
        if (product == null) {
          return Center(child: Text("No product available"));
        }

        // --- Null-safe price extraction ---
        final int price = product.price; // uses getter with null check
        final int compareAtPrice = product.compareAtPrice; // getter null safe

        return SingleChildScrollView(
          child: Column(
            children: [
              // ImageSlider(
              //     images: product.images.isNotEmpty
              //         ? product.images
              //         : [
              //             'https://via.placeholder.com/150' // Placeholder if no images
              //           ]),
              Transform.translate(
                offset: Offset(0, -20),
                child: FCard(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageSlider(
                            images: product.images.isNotEmpty
                                ? product.images
                                    .map((img) => "$baseUrl/image/$shopId/$img")
                                    .toList()
                                : ['https://via.placeholder.com/150'],
                          ),
                        ),
                      ),
                      ProductLabel(
                        title: product.title,
                        badges: product.tags,
                      ),

                      FDivider(
                        style: FTheme.of(context)
                            .dividerStyles
                            .horizontalStyle
                            .copyWith(padding: EdgeInsets.zero),
                      ),

                      // About Section
                      // About Section
                      if (product.description != null &&
                          product.description!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(
                                  12), // 👈 Rounded corner
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.05), // subtle shadow
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style:
                                      FTheme.of(context).typography.lg.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.description!,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: FTheme.of(context)
                                      .typography
                                      .base
                                      .copyWith(
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      FDivider(
                        style: FTheme.of(context)
                            .dividerStyles
                            .horizontalStyle
                            .copyWith(padding: EdgeInsets.zero),
                      ),

                      ActionView(
                        available: product.available,
                        variants: product.variants,
                        options: product.options,
                        price: price,
                        compareAtPrice: compareAtPrice,
                      ),
                      // FTabs(
                      //   initialIndex: 0,
                      //   tabs: [
                      //     FTabEntry(
                      //       label: Text('About'),
                      //       content: AboutView(
                      //         description: product.description!,
                      //       ),
                      //     ),
                      //     // FTabEntry(
                      //     //   label: Text('Details'),
                      //     //   content: DetailsView(
                      //     //     specifications: product.details,
                      //     //   ),
                      //     // ),
                      //     // FTabEntry(
                      //     //   label: Text('Reviews'),
                      //     //   content: ReviewView(
                      //     //     reviews: product.reviews,
                      //     //   ),
                      //     // ),
                      //   ],
                      //   onPress: (index) {},
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// class ShowcaseView extends StatelessWidget {
//   ShowcaseView({super.key});

//   final ShowcaseController showcaseController = Get.put(ShowcaseController());

//   @override
//   Widget build(BuildContext context) {
//     final productId = Get.parameters['productId'] ?? '';
//     final product = showcaseController.product.value;
//     // Null safe price extraction
//     final double price = (product?.priceMap?['base'] ?? 0).toDouble();
//     final double compareAtPrice =
//         (product?.priceMap?['compareAt'] ?? 0).toDouble();
//     print(
//         '...........................................................................');
//     print(showcaseController.product.value!.price);
//     print(showcaseController.product.value!.compareAtPrice);

//     if (productId.isEmpty) {
//       return Center(child: Text("No product selected"));
//     }

//     // final productId =
//     //     Get.parameters['productId']; // route e thakbe /showcase/:productId
//     // final id = Get.parameters['id'];
//     return GetX<ShowcaseController>(
//       //   init: showcaseController..fetchProductbyID(productId ?? ""),
//       //  init: showcaseController..fetchProduct(id),
//       builder: (controller) {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         } else if (controller.hasError.value) {
//           return Center(child: Text("Error loading product"));
//         } else if (controller.product.value == null) {
//           return Center(child: Text("No product available"));
//         }
//         final product = controller.product.value;

//         if (product == null) {
//           return Center(child: Text("No product available"));
//         }

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               ImageSlider(images: product.images),
//               Transform.translate(
//                 offset: Offset(0, -20),
//                 child: FCard(
//                   child: Column(
//                     spacing: 10,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ProductLabel(
//                         title: product.title,
//                         badges: product.tags,
//                       ),
//                       ActionView(
//                         available: product.available ?? false,
//                         variants: product.variants ?? [],
//                         options: product.options ?? [],
//                         price: price.toInt(), // ActionView e int parameter ache
//                         compareAtPrice: compareAtPrice
//                             .toInt(), // ActionView e int parameter
//                         // price: price,
//                         // compareAtPrice: compareAtPrice,
//                         // available: product.available,
//                         // variants: product.variants,
//                         // options: product.options,
//                         // price: product.price,
//                         // compareAtPrice: product.compareAtPrice,
//                       ),
//                       FTabs(
//                         initialIndex: 0,
//                         tabs: [
//                           FTabEntry(
//                             label: Text('About'),
//                             content: AboutView(
//                               description: product.description,
//                             ),
//                           ),
//                           FTabEntry(
//                             label: Text('Details'),
//                             content: DetailsView(
//                               specifications: product.details,
//                             ),
//                           ),
//                           FTabEntry(
//                             label: Text('Reviews'),
//                             content: ReviewView(
//                               reviews: product.reviews,
//                             ),
//                           ),
//                         ],
//                         onPress: (index) {},
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
