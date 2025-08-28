import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:theme_desiree/a/models/theme.dart';

class ThemeController extends GetxController {
  final List<ThemeModel> appLightColorSchemes = [
    ThemeModel(name: 'Zinc', key: Key('zinc_light'), theme: FThemes.zinc.light),
    ThemeModel(
        name: 'Slate', key: Key('slate_light'), theme: FThemes.slate.light),
    ThemeModel(name: 'Red', key: Key('red_light'), theme: FThemes.red.light),
    ThemeModel(name: 'Rose', key: Key('rose_light'), theme: FThemes.rose.light),
    ThemeModel(
        name: 'Orange', key: Key('orange_light'), theme: FThemes.orange.light),
    ThemeModel(
        name: 'Green', key: Key('green_light'), theme: FThemes.green.light),
    ThemeModel(name: 'Blue', key: Key('blue_light'), theme: FThemes.blue.light),
    ThemeModel(
        name: 'Yellow', key: Key('yellow_light'), theme: FThemes.yellow.light),
    ThemeModel(
        name: 'Violet', key: Key('violet_light'), theme: FThemes.violet.light),
  ].obs;

  final List<ThemeModel> appDarkColorSchemes = [
    ThemeModel(name: 'Zinc', key: Key('zinc_dark'), theme: FThemes.zinc.dark),
    ThemeModel(
        name: 'Slate', key: Key('slate_dark'), theme: FThemes.slate.dark),
    ThemeModel(name: 'Red', key: Key('red_dark'), theme: FThemes.red.dark),
    ThemeModel(name: 'Rose', key: Key('rose_dark'), theme: FThemes.rose.dark),
    ThemeModel(
        name: 'Orange', key: Key('orange_dark'), theme: FThemes.orange.dark),
    ThemeModel(
        name: 'Green', key: Key('green_dark'), theme: FThemes.green.dark),
    ThemeModel(name: 'Blue', key: Key('blue_dark'), theme: FThemes.blue.dark),
    ThemeModel(
        name: 'Yellow', key: Key('yellow_dark'), theme: FThemes.yellow.dark),
    ThemeModel(
        name: 'Violet', key: Key('violet_dark'), theme: FThemes.violet.dark),
  ].obs;

  var isDarkMode = false.obs;
  var colorScheme = 0.obs;
  var navigation = 0.obs;

  final GetStorage box = GetStorage();
  var currentTheme = FThemes.zinc.light.obs;

  @override
  void onInit() {
    super.onInit();
    setThemeByKey(box.read('theme') ?? 'zinc_light');
  }

  void setThemeByKey(String keyString) {
    int index = appLightColorSchemes
        .indexWhere((theme) => (theme.key as ValueKey).value == keyString);
    if (index != -1) {
      _updateTheme(index, isDark: false);
      return;
    }

    index = appDarkColorSchemes
        .indexWhere((theme) => (theme.key as ValueKey).value == keyString);
    if (index != -1) {
      _updateTheme(index, isDark: true);
      return;
    }

    // Default theme
    _updateTheme(0, isDark: false);
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    _updateTheme(colorScheme.value, isDark: isDark);
  }

  void changeColorScheme(int index)
   {
    _updateTheme(index, isDark: isDarkMode.value);
  }

  void _updateTheme(int index, {required bool isDark}) {
    colorScheme.value = index;
    ThemeModel themeModel =
        isDark ? appDarkColorSchemes[index] : appLightColorSchemes[index];

    currentTheme.value = themeModel.theme;
    isDarkMode.value = isDark;
    box.write('theme', (themeModel.key as ValueKey).value);
  }
}
