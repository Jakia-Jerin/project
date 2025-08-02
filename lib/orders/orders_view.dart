import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/address/address_controller.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';
import 'package:theme_desiree/orders/orders_controller.dart';

class OrdersView extends StatelessWidget {
  OrdersView({super.key}) {
    // ordersController.addOrder(order);
  }

  final ordersController = Get.put(OrdersController());
  final cartController = Get.find<CartController>();
  final checkoutController = Get.put(CheckoutController());
  final AddressController controller = Get.put(AddressController());

  //   final selectedProducts = cartController.products.toList();

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    final selectedproduct = cartController.products.toList();

    return Column(
      children: [
        // Header
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
                'Orders'.tr.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Divider
        FDivider(
          style: contextTheme.dividerStyles.verticalStyle.copyWith(
            width: 1,
            padding: EdgeInsets.zero,
          ),
        ),

        // Orders List
        Expanded(
          child: Obx(() {
            // if (ordersController.isLoading.value) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            // if (ordersController.hasError.value) {
            //   return const Center(child: Text("Error loading orders"));
            // }
            if (ordersController.orders.isEmpty) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: contextTheme.colorScheme.primary),
                        const SizedBox(height: 20),
                        Text(
                          "No Orders Yet!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: contextTheme.typography.lg.color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "Looks like you haven’t placed any orders yet.\nDiscover amazing products and exclusive deals now!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: contextTheme.typography.sm.color,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(50.0),
                          child: FButton(
                              style: FButtonStyle.primary,
                              onPress: () {
                                Get.toNamed("/");
                              },
                              label: Text("Continue Shopping")),
                        )
                      ],
                    ),
                  ),
                ),
              );

              // return  Center(
              //   child: Text("Your order list is empty"));
            }

            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FTileGroup.builder(
                        count: ordersController.orders.length,
                        divider: FTileDivider.full,
                        tileBuilder: (context, index) {
                          final reverseorder =
                              ordersController.orders.reversed.toList();
                          final order = reverseorder[index];
                          //         final productorder = order.products;

                          // Icon & Color based on status
                          IconData statusIcon;
                          Color statusColor;

                          switch (order.status.toLowerCase()) {
                            case 'pending':
                              statusIcon = LucideIcons.clock;
                              statusColor = Colors.orange;
                              break;
                            case 'shipped':
                              statusIcon = LucideIcons.truck;
                              statusColor = Colors.green;
                              break;
                            case 'delivered':
                              statusIcon = LucideIcons.check_check;
                              statusColor = Colors.red;
                              break;
                            default:
                              statusIcon = LucideIcons.info;
                              statusColor = Colors.grey;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              color: contextTheme.colorScheme.background,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: FTile(
                              prefixIcon: Icon(
                                statusIcon,
                                color: statusColor,
                                size: 24,
                              ),
                              title: Text(
                                "Order ID: ${order.id}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status: ${order.status}",
                                      style: TextStyle(color: statusColor),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Order Date: ${order.orderDate}",
                                      style: TextStyle(
                                          color:
                                              contextTheme.typography.sm.color),
                                    ),
                                    Text(
                                      "Shipping Date: ${order.shippingDate}",
                                      style: TextStyle(
                                          color:
                                              contextTheme.typography.sm.color),
                                    ),
                                    Text(
                                      "Payment: ${order.paymentMethod}",
                                      style: TextStyle(
                                          color:
                                              contextTheme.typography.sm.color),
                                    ),
                                    Text(
                                      'Total: ৳${order.total}',
                                      style: TextStyle(
                                          color:
                                              contextTheme.typography.sm.color),
                                    ),
                                  ],
                                ),
                              ),
                              suffixIcon: FIcon(
                                FAssets.icons.chevronRight,
                                size: 24,
                              ),
                              onPress: () {
                                final cartController = Get.find<
                                    CartController>(); // or pass your custom controller
                                final selectedProducts = order.products
                                    .map((p) => p.copy())
                                    .toList();

                                // Calculate subtotal from selected products
                                double orderSubtotal = selectedProducts.fold(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      ((item.price ?? 0) *
                                          (item.quantity ?? 1)),
                                );
                                double vat = 50;
                                double delivery = 120;
                                double total = orderSubtotal + vat + delivery;

                                showModalBottomSheet(
                                    backgroundColor:
                                        contextTheme.colorScheme.background,
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) {
                                      final accordions =
                                          selectedProducts.map((product) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Column(
                                            children: [
                                              FAccordion(
                                                controller:
                                                    FAccordionController(
                                                        max: 1),
                                                items: [
                                                  FAccordionItem(
                                                    title: Text(
                                                        product.title ?? ''),
                                                    child: Row(
                                                      children: [
                                                        product.image != null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image
                                                                    .network(
                                                                  product
                                                                      .image!,
                                                                  width: 60,
                                                                  height: 60,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                size: 60,
                                                              ),
                                                        const SizedBox(
                                                            width: 12),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'Quantity: ${product.quantity ?? 1}'),
                                                              Text(
                                                                'Variant: ${product.variant ?? "N/A"}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Text(
                                                                  'Per Price: ৳${product.price ?? 0}'),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  FAccordionItem(
                                                    title: Text(
                                                        "Shipping Address"),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Address Category: ${order.address!.addressType}"),
                                                        Text(
                                                            "Line 1: ${order.address!.line1}"),
                                                        if (order.address!
                                                                    .line2 !=
                                                                null &&
                                                            order
                                                                .address!
                                                                .line2!
                                                                .isNotEmpty)
                                                          Text(
                                                              "Line 2: ${order.address!.line2}"),
                                                        Text(
                                                            "Region: ${order.address!.region}"),
                                                        Text(
                                                            "District: ${order.address!.district}"),
                                                        Text(
                                                            "Postcode: ${order.address!.postcode}"),
                                                      ],
                                                    ),
                                                  ),
                                                  FAccordionItem(
                                                      title: Text(
                                                          "Payment Methods"),
                                                      child: Text(
                                                          order.paymentMethod)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList();

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 24),
                                        child: SingleChildScrollView(
                                          child: selectedProducts.isEmpty
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  child: Text("No Orders Yet",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22)))
                                              // ?  Text("No Orders Yet",style:TextStyle(fontWeight: FontWeight.bold))
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ...accordions,
                                                    // FDivider(
                                                    //   style: contextTheme
                                                    //       .dividerStyles
                                                    //       .verticalStyle
                                                    //       .copyWith(
                                                    //     width: 1,
                                                    //     padding:
                                                    //         EdgeInsets.zero,
                                                    //   ),
                                                    // ),
                                                    FAccordion(
                                                      controller:
                                                          FAccordionController(
                                                              max: 3),
                                                      items: [
                                                        FAccordionItem(
                                                          title: const Text(
                                                              "Subtotal"),
                                                          child: Text(
                                                              '৳${orderSubtotal.toString()}'),
                                                        ),
                                                        FAccordionItem(
                                                          title:
                                                              const Text("Vat"),
                                                          child: Text("৳50"),
                                                        ),
                                                        FAccordionItem(
                                                          title: const Text(
                                                              "Delivery Charge"),
                                                          child: Text("৳120"),
                                                        ),
                                                      ],
                                                    ),
                                                    FDivider(
                                                      style: contextTheme
                                                          .dividerStyles
                                                          .verticalStyle
                                                          .copyWith(
                                                        width: 1,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ),

                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        'Total: ৳${total.toString()}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          );
                        })));
          }),
        ),
      ],
    );
  }
}
