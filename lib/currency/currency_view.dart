import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/currency/currency_controller.dart';

class CurrencyView extends StatelessWidget {
  CurrencyView({super.key});
  final CurrencyController currencyController = Get.find<CurrencyController>();
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
                'Currency'.tr.toUpperCase(),
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
              child: Obx(
                () {
                  if (currencyController.currencies.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final selectedCurrency =
                        currencyController.selectedCurrency.value;
                    return FTileGroup.builder(
                      count: currencyController.currencies.length,
                      divider: FTileDivider.full,
                      tileBuilder: (context, index) {
                        final currency = currencyController.currencies[index];
                        return FTile(
                          onPress: () {
                            currencyController.selectCurrency(currency);
                          },
                          prefixIcon: Image.asset(
                            'icons/currency/${currency.code.toLowerCase()}.png',
                            package: 'currency_icons',
                          ),
                          title: Text(
                              '(${currency.code.toUpperCase()}) ${currency.name}'),
                          subtitle: currency.isPayable
                              ? Text('Payable')
                              : Text('Not payable'),
                          suffixIcon: selectedCurrency?.code == currency.code
                              ? FIcon(
                                  FAssets.icons.check,
                                  size: 22,
                                )
                              : null,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
