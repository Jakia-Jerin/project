import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/address/address_controller.dart';
import 'package:theme_desiree/checkout/address.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';
import 'package:theme_desiree/checkout/receipt.dart';
import 'package:theme_desiree/orders/orders_controller.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final checkoutController = Get.put(CheckoutController());

  final cartController = Get.put(CartController());

  final AddressController controller = Get.put(AddressController());
  final ordersController = Get.put(OrdersController());

  String? selectedId;
  late List<DeliveryChargeModel> charges;

  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    //   checkoutController.getPaymentMethods();
    final contextTheme = FTheme.of(context);

    //  final selectedproduct = cartController.products.toList();
    //  final selectedpaymentmethod = checkoutController.paymentMethods;
    //  final selectaddress = controller.selectedAddress;

    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            /// ---- HEADER ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FButton.icon(
                  onPress: () => Get.toNamed("/account"),
                  style: FButtonStyle.outline,
                  child: FIcon(
                    FAssets.icons.chevronLeft,
                    size: 24,
                  ),
                ),
                Text(
                  'Checkout'.tr.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: contextTheme.typography.lg.color),
                ),
                const SizedBox(width: 40),
              ],
            ),

            const SizedBox(height: 5),

            // /// ---- CART PRODUCTS ----
            // Obx(() {
            //   if (cartController.products.isEmpty) {
            //     return const Center(child: Text('Your cart is empty'));
            //   }
            //   return Column(
            //     children:
            //         List.generate(cartController.products.length, (index) {
            //       final product = cartController.products[index];
            //       return Column(
            //         children: [
            //           ListTile(
            //             leading: product.image != null
            //                 ? Image.network(product.image!,
            //                     width: 50, height: 50)
            //                 : const Icon(Icons.image),
            //             title: Text(product.title ?? 'No Title'),
            //             subtitle: Text('Quantity: ${product.quantity}'),
            //             trailing: Text(
            //                 'Price: \$${(product.price ?? 0) * product.quantity}'),
            //           ),
            //           const Divider(),
            //         ],
            //       );
            //     }),
            //   );
            // }),

            /// ---- RECEIPT ----
            const SizedBox(height: 10),
            const Receipt(),

            /// ---- DIVIDER ----
            //  const SizedBox(height: 10),
            // FDivider(
            //   style: FDividerStyle(
            //     color: FTheme.of(context).dividerStyles.horizontalStyle.color,
            //     padding: EdgeInsets.zero,
            //   ),
            // ),
            const SizedBox(height: 15),
            FDivider(
              style: FDividerStyle(
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 15),

            ///--------Address ------------
            AddressMethod(),
            SizedBox(height: 15),

            FDivider(
              style: FDividerStyle(
                color: FTheme.of(context).dividerStyles.horizontalStyle.color,
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 5),

            //............Delivery Charge..............

            Text(
              'Delivery Charge',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: contextTheme.typography.sm.color),
            ),
            const SizedBox(height: 10),

            Obx(() {
              if (checkoutController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (checkoutController.deliveryCharges.isEmpty) {
                return const Text("No delivery charges found");
              }

              // ListView return kora hocche
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: checkoutController.deliveryCharges.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final charge = checkoutController.deliveryCharges[index];
                  return RadioListTile<String>(
                    value: charge.id,
                    groupValue: checkoutController.selectedDeliveryId.value,
                    activeColor:
                        contextTheme.colorScheme.primary, // primary color
                    title: Text(charge.name ?? "Default Delivery"),
                    subtitle: Text("Charge: ${charge.charge} BDT"),
                    onChanged: (val) {
                      checkoutController.selectDelivery(val!);

                      cartController.updateDeliveryCharge(
                          checkoutController.selectedCharge?.charge ?? 0);
                    },
                  );
                },
              );
            }),
            SizedBox(height: 30),

            /// ---- PAYMENT METHODS ----
            ///
            ///
            ///
            Text(
              'Payment Method',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: contextTheme.typography.sm.color),
            ),
            SizedBox(height: 1),
            Row(
              children: [
                Radio<String>(
                  value: 'cod',
                  groupValue: selectedPaymentMethod,
                  activeColor: FTheme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                Text('Cash on Delivery', style: TextStyle(fontSize: 16)),
              ],
            ),
            // Text(
            //   'Select Payment Method',
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18,
            //       color: contextTheme.typography.sm.color),
            // ),
            // SizedBox(height: 20),
            // PaymentMethods(),

            /// ---- PLACE ORDER BUTTON ----
            const SizedBox(height: 40),

            Obx(() {
              final isLoading = checkoutController.isLoading.value;
              final hasCart = cartController.products.isNotEmpty;
              final hasAddress = controller.selectedAddress.value != null;
              final hasPayment =
                  selectedPaymentMethod != null; // ✅ UI er sate match
              final hasDelivery = checkoutController
                  .selectedDeliveryId.value.isNotEmpty; // ✅ delivery check

              final canPlaceOrder =
                  hasCart && hasAddress && hasPayment && hasDelivery;

              if (isLoading || !canPlaceOrder) {
                return const SizedBox(); // hide button
              }

              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: FButton(
                    style: contextTheme.buttonStyles.primary.copyWith(
                      contentStyle: contextTheme
                          .buttonStyles.primary.contentStyle
                          .copyWith(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                    ),
                    onPress: () async {
                      await checkoutController.placeOrder(
                        paymentMethod: selectedPaymentMethod!,
                        total: cartController.totals.value.total,
                        //   products: cartController.products,
                        //   shippingMethod: checkoutController.selectedCharge?.name ?? "standard",
                      );
                    },
                    label: Text(
                      'Place Order',
                      style: contextTheme.typography.sm.copyWith(
                        color: contextTheme.typography.sm.color,
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Obx(() {
            //   final isLoading = checkoutController.isLoading.value;
            //   //    final hasCart = cartController.products.isNotEmpty;
            //   final hasAddress = controller.selectedAddress.value != null;
            //   final hasPayment =
            //       selectedPaymentMethod != null;
            //   final hasDelivery =
            //       checkoutController.selectedDeliveryId.value.isNotEmpty;
            //   if (isLoading || !hasAddress || !hasPayment) {
            //     return SizedBox();
            //   }

            //   return SizedBox(
            //     width: double.infinity,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 17),
            //       child: FButton(
            //         style: contextTheme.buttonStyles.primary.copyWith(
            //           contentStyle: contextTheme
            //               .buttonStyles.primary.contentStyle
            //               .copyWith(
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 12,
            //               vertical: 10,
            //             ),
            //           ),
            //         ),
            //         onPress: () async {
            //           checkoutController.placeOrder(
            //             paymentMethod: selectedPaymentMethod!,
            //             total: cartController.totals.value.total,
            //           );
            //           // final newOrder = OrdersModel(
            //           //   id: DateTime.now().millisecondsSinceEpoch.toString(),
            //           //   status: 'pending',
            //           //   orderDate: DateTime.now().toString(),
            //           //   shippingDate: 'TBD',
            //           //   paymentMethod:
            //           //       checkoutController.selectedMethod.value?.name ??
            //           //           'Unknown',
            //           //   total: cartController.totals.value.total,
            //           //   products: cartController.products
            //           //       .map((p) => p.copy())
            //           //       .toList(),
            //           //   address: controller.selectedAddress.value!,
            //           // );

            //           // ordersController.addOrder(newOrder);

            //           //         if (selectedproduct.isEmpty) {
            //           //           Get.snackbar(
            //           //               'Failed', 'Please select at least one product');
            //           //           return;
            //           //         }

            //           //         if (selectedpaymentmethod.isEmpty) {
            //           //           Get.snackbar('Failed', 'Please select a payment method');
            //           //           return;
            //           //         }

            //           //         if (selectaddress.value == null) {
            //           //           Get.snackbar(
            //           //               'Failed', 'Please select a delivery address');
            //           //           return;
            //           //         }
            //           try {
            //             checkoutController.isLoading.value = true;

            //             // Simulate order delay
            //             await Future.delayed(const Duration(seconds: 2));

            //             Get.snackbar(
            //               'Success',
            //               'Order placed successfully!',
            //               backgroundColor: contextTheme.colorScheme.background,
            //               snackPosition: SnackPosition.TOP,
            //             );
            //             Future.delayed(const Duration(seconds: 2), () {
            //               Get.toNamed("settings/orders");
            //             });

            //             // Optional: clear cart after order
            //             // cartController.products.clear();
            //           } catch (e) {
            //             Get.snackbar(
            //               'Failed',
            //               'Failed to place order. Please try again.',
            //               backgroundColor: contextTheme.colorScheme.background,
            //               snackPosition: SnackPosition.TOP,
            //             );
            //           } finally {
            //             checkoutController.isLoading.value = false;
            //           }
            //         },
            //         label: Text(
            //           'Place Order',
            //           style: contextTheme.typography.sm.copyWith(
            //             color: contextTheme.typography.sm.color,
            //           ),
            //         ),
            //       ),
            //     ),
            //   );
            // }),
            const SizedBox(height: 20),

            // SizedBox(
            //   width: double.infinity,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 17),
            //     child: FButton(
            //       style: contextTheme.buttonStyles.primary.copyWith(
            //         contentStyle:
            //             contextTheme.buttonStyles.primary.contentStyle.copyWith(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 12,
            //             vertical: 10,
            //           ),
            //         ),
            //       ),
            //       onPress: () async {

            //         if (selectedproduct.isEmpty) {
            //           Get.snackbar(
            //               'Failed', 'Please select at least one product');
            //           return;
            //         }

            //         if (selectedpaymentmethod.isEmpty) {
            //           Get.snackbar('Failed', 'Please select a payment method');
            //           return;
            //         }

            //         if (selectaddress.value == null) {
            //           Get.snackbar(
            //               'Failed', 'Please select a delivery address');
            //           return;
            //         }
            //         try {
            //           // Simulate order processing delay
            //           await Future.delayed(const Duration(seconds: 2));

            //           // Order success snackbar
            //           Get.snackbar(
            //             'Success',
            //             'Order placed successfully!',
            //             backgroundColor: contextTheme.colorScheme.background,
            //             snackPosition: SnackPosition.TOP,
            //           );

            //           // Navigate to OrderDetailsView with cart products
            //           // final cartController = Get.find<CartController>();
            //           // final selectedProducts = cartController.products.toList();
            //           // Get.to(
            //           //     () => OrderDetailsView(products: selectedProducts));

            //           // Optional: Clear cart after order
            //           // cartController.products.clear();
            //         }

            //          catch (e) {
            //           // Order failure snackbar
            //           Get.snackbar(
            //             'Failed',
            //             'Failed to place order. Please try again.',
            //             backgroundColor: contextTheme.colorScheme.background,
            //             snackPosition: SnackPosition.TOP,
            //           );
            //         }
            //       },
            //       label: Text(
            //         'Place Order',
            //         style: contextTheme.typography.sm.copyWith(
            //           color: contextTheme.typography.sm.color,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}





// class CheckoutView extends StatelessWidget {
//   CheckoutView({super.key}) {
//     checkoutController.getPaymentMethods();
//   }

//   final checkoutController = Get.put(CheckoutController());

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FButton.icon(
//                   onPress: () => Get.toNamed("/account"),
//                   style: FButtonStyle.outline,
//                   child: FIcon(
//                     FAssets.icons.chevronLeft,
//                     size: 24,
//                   ),
//                 ),
//                 Text(
//                   'Checkout'.tr.toUpperCase(),
//                   style:
//                       const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                 ),
//                 const SizedBox(width: 40),
//               ],
//             ),



//           ),
       
//             // FDivider(
//             //     style: FDividerStyle(
//             //       color: FTheme.of(context).dividerStyles.horizontalStyle.color,
//             //       padding: EdgeInsets.zero,
//             //     ),
//             //   ),
//           // FDivider(
//           //   style: FTheme.of(context).dividerStyles.verticalStyle.copyWith(
//           //         width: 1,
//           //         padding: EdgeInsets.zero,
//           //       ),
//           // ),
//           Receipt(),
//           SizedBox(height: 10),
//             FDivider(
//                 style: FDividerStyle(
//                   color: FTheme.of(context).dividerStyles.horizontalStyle.color,
//                   padding: EdgeInsets.zero,
//                 ),
//               ),
//           SizedBox(height: 10),

//           PaymentMethods(),
//         ],
//       ),
//     );
//   }
// }
