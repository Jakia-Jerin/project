import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);

    final cartController = Get.find<CartController>();
    final controller = Get.put(CheckoutController());
    return Obx(() {
      // final totals = cartController.totals.value;
      return FTileGroup(children: [
        FTile(
          title: Text('Subtotal'),
          suffixIcon: Text(
            "${cartController.totals.value.subtotal.toInt()}",
            //  '${cartController.subtotal()}',
            style: TextStyle(color: contextTheme.typography.sm.color),
          ),
        ),
        FTile(
          title: Text('Vat'),
          suffixIcon: Text(
            "${cartController.totals.value.vat.toInt()}",
            style: TextStyle(color: contextTheme.typography.sm.color),
          ),
        ),
        FTile(
          title: Text('Delivery charge'),
          suffixIcon: Text(
            //  "${controller.selectedCharge?.charge ?? 0}",
            "${cartController.totals.value.deliveryCharge.toInt()}",
            style: TextStyle(color: contextTheme.typography.sm.color),
          ),
        ),
        FTile(
          title: Text('Total'),
          suffixIcon: Text(
            '${cartController.totals.value.total.toInt()}',
            style: TextStyle(color: contextTheme.typography.sm.color),
          ),
        ),
      ]);
    });
  }
}
