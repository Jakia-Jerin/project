import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/theme.dart';

class ThemesView extends StatelessWidget {
  const ThemesView({super.key});

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: contextTheme.colorScheme.background,
      ),
      child: Column(
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
                  'Themes'.tr.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                GetX<ThemeController>(
                  builder: (controller) {
                    return FSwitch(
                      style: contextTheme.switchStyle.copyWith(
                        labelLayoutStyle:
                            FLabelLayoutStyle(childPadding: EdgeInsets.zero),
                      ),
                      value: controller.isDarkMode.value,
                      onChange: (value) => controller.toggleTheme(value),
                    );
                  },
                ),
              ],
            ),
          ),
          FDivider(
            style: contextTheme.dividerStyles.verticalStyle
                .copyWith(width: 1, padding: EdgeInsets.zero),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: GetX<ThemeController>(
                builder: (controller) {
                  final isDark = controller.isDarkMode.value;
                  final appColorSchemes = isDark
                      ? controller.appDarkColorSchemes
                      : controller.appLightColorSchemes;

                  return FTileGroup.builder(
                    count: appColorSchemes.length,
                    tileBuilder: (context, index) {
                      final item = appColorSchemes[index];
                      return FTile(
                        onPress: () => controller.changeColorScheme(index),
                        title: Text(item.name.tr),
                        suffixIcon: controller.colorScheme.value == index
                            ? FIcon(
                                FAssets.icons.check,
                                size: 22,
                              )
                            : null,
                        prefixIcon: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: item.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                    divider: FTileDivider.full,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
