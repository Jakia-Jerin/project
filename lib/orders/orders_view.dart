import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                'ORders'.tr.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(width: 40)
            ],
          ),
        ),
        FDivider(
          style: FTheme.of(context)
              .dividerStyles
              .verticalStyle
              .copyWith(width: 1, padding: EdgeInsets.zero),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
