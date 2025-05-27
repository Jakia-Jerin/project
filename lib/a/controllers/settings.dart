import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/models/settings.dart';

class SettingsController extends GetxController {
  final List<SettingsModel> profileMenus = [
    SettingsModel(
        title: 'Profile',
        subtitle: 'Change general information',
        icon: FIcon(FAssets.icons.user),
        route: '/settings/profile'),
    SettingsModel(
        title: 'Orders',
        subtitle: 'Order history and reviews',
        icon: FIcon(FAssets.icons.fileClock),
        route: '/settings/orders'),
    SettingsModel(
        title: 'Currency',
        subtitle: 'Change currency',
        icon: FIcon(FAssets.icons.circleDollarSign),
        route: '/settings/currency'),
    SettingsModel(
        title: 'Themes',
        subtitle: 'Custom theme and color',
        icon: FIcon(FAssets.icons.palette),
        route: '/settings/theme'),
    SettingsModel(
        title: 'Notification',
        subtitle: 'Control notifications',
        icon: FIcon(FAssets.icons.bellDot),
        route: '/settings/notification'),
    SettingsModel(
        title: 'Language',
        subtitle: 'Set language preference',
        icon: FIcon(FAssets.icons.languages),
        route: '/settings/language'),
  ].obs;
}
