import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    return FTileGroup(children: [
      FTile(
        title: Text('Subtotal'),
        suffixIcon: Text('5000'),
      ),
      FTile(
        title: Text('Vat'),
        suffixIcon: Text('50'),
      ),
      FTile(
        title: Text('Delivery charge'),
        suffixIcon: Text('120'),
      ),
      FTile(
        title: Text('Total'),
        suffixIcon: Text('5170'),
      ),
    ]);
  }
}
