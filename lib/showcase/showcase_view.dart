import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/showcase/action_view.dart';
import 'package:theme_desiree/showcase/about_view.dart';
import 'package:theme_desiree/showcase/image_slider.dart';
import 'package:theme_desiree/showcase/product_label.dart';
import 'package:theme_desiree/showcase/review_view.dart';
import 'package:theme_desiree/showcase/showcase_controller.dart';
import 'package:theme_desiree/showcase/details_view.dart';

class ShowcaseView extends StatelessWidget {
  ShowcaseView({super.key});

  final ShowcaseController showcaseController = Get.put(ShowcaseController());

  @override
  Widget build(BuildContext context) {
    final productId = Get.parameters['productId'] ?? '';

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
              ImageSlider(
                  images: product.images.isNotEmpty
                      ? product.images
                      : [
                          'https://via.placeholder.com/150' // Placeholder if no images
                        ]),
              Transform.translate(
                offset: Offset(0, -20),
                child: FCard(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageSlider(images: product.images),
                      ProductLabel(
                        title: product.title,
                        badges: product.tags,
                      ),
                      ActionView(
                        available: product.available,
                        variants: product.variants,
                        options: product.options,
                        price: price,
                        compareAtPrice: compareAtPrice,
                      ),
                      FTabs(
                        initialIndex: 0,
                        tabs: [
                          FTabEntry(
                            label: Text('About'),
                            content: AboutView(
                              description: product.description,
                            ),
                          ),
                          FTabEntry(
                            label: Text('Details'),
                            content: DetailsView(
                              specifications: product.details,
                            ),
                          ),
                          FTabEntry(
                            label: Text('Reviews'),
                            content: ReviewView(
                              reviews: product.reviews,
                            ),
                          ),
                        ],
                        onPress: (index) {},
                      ),
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
