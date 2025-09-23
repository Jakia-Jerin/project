import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/horizontal_brochure.dart';
import 'package:theme_desiree/a/models/horizontal_brochure.dart';
import 'package:theme_desiree/a/views/product_mini_card.dart';

class HorizontalBrochure extends StatelessWidget {
  const HorizontalBrochure({super.key});

  @override
  Widget build(BuildContext context) {
    final String tag = UniqueKey().toString();
    final horizontalBrochureController =
        Get.put(HorizontalBrochureController(), tag: tag);
    //  horizontalBrochureController.fetchCategoryWiseBrochures();

    final contextTheme = FTheme.of(context);
    final shopId = dotenv.env['SHOP_ID'];
    final baseUrl = dotenv.env['BASE_URL'];
    return GetX<HorizontalBrochureController>(
      tag: tag,
      builder: (controller) {
        // if (controller.isLoading.value) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (controller.hasError.value) {
          return Center(child: Text("Failed to load brochures"));
        }
        if (controller.brochures.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          //  children: controller.brochures.map((brochure)
          children: controller.brochures
              .where((brochure) => brochure.products.isNotEmpty)
              .map((brochure) {
            // Take only first 2 products for preview
            final displayedProducts = brochure.products.take(2).toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FCard.raw(
                style: contextTheme.cardStyle.copyWith(
                  contentStyle: contextTheme.cardStyle.contentStyle.copyWith(
                    padding: EdgeInsets.all(1),
                  ),
                ),
                child: Column(
                  children: [
                    // Image Section
                    // if (brochure.image != null && brochure.image!.isNotEmpty)
                    //   ClipRRect(
                    //     borderRadius: const BorderRadius.only(
                    //       topLeft: Radius.circular(8),
                    //       topRight: Radius.circular(8),
                    //     ),
                    //     child: Image.network(
                    //       "$baseUrl/image/$shopId/${brochure.image}",
                    //       fit: BoxFit.cover,
                    //       height: 140,
                    //       width: double.infinity,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Container(
                    //           height: 140,
                    //           width: double.infinity,
                    //           color: Colors.grey[300],
                    //           child:
                    //               Icon(Icons.broken_image, color: Colors.grey),
                    //         );
                    //       },
                    //     ),
                    //   )
                    // else
                    //   Container(
                    //     height: 140,
                    //     width: double.infinity,
                    //     color: Colors.grey[300],
                    //     child: Icon(Icons.image, color: Colors.grey),
                    //   ),

                    // Title & Subtitle
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brochure.title,
                                  style: contextTheme.typography.base,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  brochure.subtitle,
                                  style: contextTheme.typography.sm,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          FButton(
                            style: contextTheme.buttonStyles.primary.copyWith(
                              contentStyle: contextTheme
                                  .buttonStyles.primary.contentStyle
                                  .copyWith(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            onPress: () {
                              // Navigate to FullBrochurePage with brochure
                              Get.to(
                                  () => FullBrochurePage(brochure: brochure));
                            },
                            //    onPress: () => Get.toNamed(brochure.handle),
                            label: Text(
                              "View more",
                              style: contextTheme.typography.sm.copyWith(
                                  color: contextTheme.colorScheme.foreground),
                            ),
                            suffix: FIcon(
                              FAssets.icons.chevronRight,
                              size: 18,
                              color: contextTheme.colorScheme.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal Products List
                    // SizedBox(
                    //   height: 230,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 8, vertical: 8),
                    //     physics: const BouncingScrollPhysics(),
                    //     itemCount: brochure.products.length,
                    //     itemBuilder: (context, index) {
                    //       final product = brochure.products[index];
                    //       return Padding(
                    //         padding: const EdgeInsets.only(right: 8),
                    //         child: SizedBox(
                    //           width: 172,
                    //           child: ProductMiniCard(data: product),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    if (brochure.products.isNotEmpty)
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          physics: const BouncingScrollPhysics(),
                          itemCount: displayedProducts.length,
                          //       itemCount: brochure.products.length,
                          itemBuilder: (context, index) {
                            final product = displayedProducts[index];
                            //  final product = brochure.products[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SizedBox(
                                width: 172,
                                child: ProductMiniCard(data: product),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class FullBrochurePage extends StatelessWidget {
  final HorizontalBrochureModel brochure;

  const FullBrochurePage({super.key, required this.brochure});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);

    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: contextTheme.colorScheme.background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FButton.icon(
            style: FButtonStyle.outline,
            child: FIcon(
              FAssets.icons.chevronLeft,
              size: 24,
            ),
            onPress: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          '${brochure.title}'.tr.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: contextTheme.typography.lg.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   brochure.subtitle,
            //   style: contextTheme.typography.base,
            // ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // row 2 item
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7, // card  width-height ratio
                ),
                itemCount: brochure.products.length,
                itemBuilder: (context, index) {
                  final product = brochure.products[index];
                  return ProductMiniCard(data: product);
                },
              ),
            )
            // Expanded(
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: brochure.products.length,
            //     padding: EdgeInsets.symmetric(horizontal: 8),
            //     physics: BouncingScrollPhysics(),
            //     itemBuilder: (context, index) {
            //       final product = brochure.products[index];
            //       return Padding(
            //         padding: const EdgeInsets.only(right: 12),
            //         child: SizedBox(
            //           width: 160,
            //           child: ProductMiniCard(data: product),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
// class HorizontalBrochure extends StatelessWidget {
//   final Map<String, dynamic> data;
//   const HorizontalBrochure({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final String tag = UniqueKey().toString();
//     final horizontalBrochureController =
//         Get.put(HorizontalBrochureController(), tag: tag);

//     //horizontalBrochureController.fromJson(data);
//     horizontalBrochureController.fetchBrochure();

//     final contextTheme = FTheme.of(context);

//     return GetX<HorizontalBrochureController>(
//       tag: tag,
//       builder: (controller) {
//         if (controller.isLoading.value || controller.hasError.value) {
//           return SizedBox.shrink();
//         }

//         final brochure = controller.brochure.value;
//         if (brochure == null) {
//           return SizedBox.shrink();
//         }

//         return FCard.raw(
//           style: contextTheme.cardStyle.copyWith(
//             contentStyle: contextTheme.cardStyle.contentStyle.copyWith(
//               padding: EdgeInsets.all(1),
//             ),
//           ),
//           child: Column(
//             children: [
//               if (brochure.image != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       topRight: Radius.circular(8)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(1),
//                     child: Image.network(brochure.image!, fit: BoxFit.cover),
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   spacing: 8,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             brochure.title,
//                             style: contextTheme.typography.base,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             brochure.subtitle,
//                             style: contextTheme.typography.sm,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     FButton(
//                       style: contextTheme.buttonStyles.primary.copyWith(
//                         contentStyle: contextTheme
//                             .buttonStyles.primary.contentStyle
//                             .copyWith(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                       onPress: () => Get.toNamed(brochure.handle),
//                       label: Text(
//                         "View more",
//                         style: contextTheme.typography.sm.copyWith(
//                             color: contextTheme.colorScheme.foreground),
//                       ),
//                       suffix: FIcon(
//                         FAssets.icons.chevronRight,
//                         size: 18,
//                         color: contextTheme.colorScheme.foreground,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 230,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   physics: BouncingScrollPhysics(),
//                   itemCount: brochure.products.length,
//                   itemBuilder: (context, index) {
//                     final id = brochure.products[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: SizedBox(
//                         width: 172,
//                         child: ProductMiniCard(data: id),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
