import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<CheckoutController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.hasError.value) {
            return const Center(child: Text('Error loading payment methods'));
          }
          return Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            runSpacing: 8,
            children: List.generate(controller.paymentMethods.length, (index) {
              final payment = controller.paymentMethods[index];
              final selected = controller.selectedMethod.value;
              return GestureDetector(
                onTap: () => controller.selectedMethod.value = payment,
                child: FCard(
                  style: FTheme.of(context).cardStyle.copyWith(
                        contentStyle:
                            FTheme.of(context).cardStyle.contentStyle.copyWith(
                                  padding: EdgeInsets.all(1),
                                ),
                        decoration: payment == selected
                            ? BoxDecoration(
                                border: Border.all(
                                  color: FTheme.of(context).colorScheme.primary,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : BoxDecoration(
                                border: Border.all(
                                  color: FTheme.of(context).colorScheme.border,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                      ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      children: [
                        Image.network(
                          payment.logo,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              FIcon(FAssets.icons.image),
                        ),
                        Visibility(
                          visible: payment == selected,
                          child: Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: FTheme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: FIcon(
                                FAssets.icons.check,
                                color: FTheme.of(context)
                                    .colorScheme
                                    .primaryForeground,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
