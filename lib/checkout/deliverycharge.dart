import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';
import 'package:forui/forui.dart';
import 'package:theme_desiree/checkout/checkout_model.dart';

class DeliveryTileDropdown extends StatelessWidget {
  final CheckoutController checkoutController;
  final CartController cartController;

  const DeliveryTileDropdown({
    super.key,
    required this.checkoutController,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final charges = checkoutController.deliveryCharges;

      if (checkoutController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (charges.isEmpty) {
        return const Text("No delivery charges found");
      }

      final selectedId = checkoutController.selectedDeliveryId.value;

      return GestureDetector(
        onTap: () {
          _showDeliveryPicker(context, charges, selectedId);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.transparent, // background optional
          child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedId.isEmpty
                    ? "Select delivery option"
                    : charges.firstWhere((c) => c.id == selectedId).name ??
                        'Delivery Option',
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: 175),
              FIcon(FAssets.icons.chevronRight, size: 25, color: Colors.black),
            ],
          ),
        ),
      );
    });
  }

  void _showDeliveryPicker(
    BuildContext context,
    List<DeliveryChargeModel> charges,
    String selectedId,
  ) {
    final contextTheme = FTheme.of(context);

    showModalBottomSheet(
      useSafeArea: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: contextTheme.colorScheme.background,
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row with title and cross button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                      child: Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            // List of delivery charges
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: charges.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final charge = charges[index];
                  return ListTile(
                    title: Text("${charge.name} - ${charge.charge} BDT"),
                    selected: charge.id == selectedId,
                    onTap: () {
                      checkoutController.selectDelivery(charge.id);
                      cartController.updateDeliveryCharge(
                        checkoutController.selectedCharge?.charge ?? 0,
                      );
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
