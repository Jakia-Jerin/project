import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/cart.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);

    final cartController = Get.find<CartController>();
    return FTileGroup(children: [
      FTile(
        title: Text('Subtotal'),
        suffixIcon: Text(
          '${cartController.subtotal()}',
          style: TextStyle(color: contextTheme.typography.sm.color),
        ),
      ),
      FTile(
        title: Text('Vat'),
        suffixIcon: Text(
          '50',
          style: TextStyle(color: contextTheme.typography.sm.color),
        ),
      ),
      FTile(
        title: Text('Delivery charge'),
        suffixIcon: Text(
          '120',
          style: TextStyle(color: contextTheme.typography.sm.color),
        ),
      ),
      FTile(
        title: Text('Total'),
        suffixIcon: Text(
          '${cartController.recipttotal()}',
          style: TextStyle(color: contextTheme.typography.sm.color),
        ),
      ),
    ]);
  }
}
