import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';
import 'package:theme_desiree/checkout/payment_methods.dart';
import 'package:theme_desiree/checkout/receipt.dart';

class CheckoutView extends StatelessWidget {
  CheckoutView({super.key}) {
    checkoutController.getPaymentMethods();
  }

  final checkoutController = Get.put(CheckoutController());

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
                onPress: () => Get.toNamed("/account"),
                style: FButtonStyle.outline,
                child: FIcon(
                  FAssets.icons.chevronLeft,
                  size: 24,
                ),
              ),
              Text(
                'Checkout'.tr.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        Receipt(),
        PaymentMethods(),
      ],
    );
  }
}
