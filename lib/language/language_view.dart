import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/language/language_contoller.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, String>> translations = Languages().keys;
    List<String> languageCodes = translations.keys.toList();
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
                'Language'.tr.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(width: 40)
            ],
          ),
        ),
        FDivider(
          style: FTheme.of(context).dividerStyles.verticalStyle.copyWith(
              width: 1,
              padding: EdgeInsets.zero,
              color: FTheme.of(context).colorScheme.border),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FTileGroup.builder(
                count: languageCodes.length,
                divider: FTileDivider.full,
                tileBuilder: (context, index) {
                  String langCode = languageCodes[index];
                  return FTile(
                    onPress: () {
                      List<String> parts = langCode.split('_');
                      Locale locale =
                          Locale(parts[0], parts.length > 1 ? parts[1] : '');
                      Get.updateLocale(locale);
                    },
                    title: Text(
                      translations[langCode]?['lang_name'] ??
                          'Unknown Language',
                    ),
                    suffixIcon:
                        Get.locale!.languageCode == langCode.split('_')[0]
                            ? FIcon(
                                FAssets.icons.check,
                                size: 20,
                              )
                            : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
