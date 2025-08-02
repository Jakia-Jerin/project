// import 'package:flutter/material.dart';
// import 'package:theme_desiree/a/models/cart.dart';




// class OrderDetailsView extends StatelessWidget {
//   final List<CartModel> products;

//   const OrderDetailsView({super.key, required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Order Details")),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final product = products[index];
//           return ListTile(
//             leading: Image.network(product.image ?? '', width: 60, fit: BoxFit.cover),
//             title: Text(product.title ?? ''),
//             subtitle: Text(product.variant ?? ''),
//             trailing: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text("৳${product.price} × ${product.quantity}"),
//                 Text("৳${product.price! * product.quantity}",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// class OrderDetailsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final contextTheme = FTheme.of(context);
//     final productController = Get.put(ProductController());
//     final productMiniCardController = Get.put(ProductMiniCardController());

//     return Container(
//       decoration: BoxDecoration(
//         color: contextTheme.colorScheme.background,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title Bar with Back Button and Title
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 FButton.icon(
//                   onPress: () => Get.toNamed("/settings"),
//                   child: FIcon(
//                     FAssets.icons.chevronLeft,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Order details'.tr.toUpperCase(),
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Product details section
//           Obx(() {
//             if (productMiniCardController.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (productMiniCardController.hasError.value) {
//               return const Center(child: Text('Error loading product'));
//             }

//             final productMini = productMiniCardController.product.value;
//             print("DEBUG: ProductMini value = $productMini");

//             if (productMini == null) {
//               return const Center(child: Text('No product found'));
//             }

//             final imageUrl = productMini.images.isNotEmpty
//                 ? productMini.images.first
//                 : 'https://via.placeholder.com/150';

//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: FCard(
//              //   padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Image.network(
//                       imageUrl,
//                       height: 200,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       productMini.title ?? 'Unnamed Product',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       productMini.description ?? 'No description',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
