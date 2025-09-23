import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:theme_desiree/a/controllers/categories.dart';
import 'package:theme_desiree/a/controllers/home.dart';
import 'package:theme_desiree/a/controllers/notification.dart';
import 'package:theme_desiree/a/controllers/search_result.dart';
import 'package:theme_desiree/a/controllers/cart.dart';
import 'package:theme_desiree/currency/currency_controller.dart';
import 'package:theme_desiree/language/language_contoller.dart';
import 'package:theme_desiree/navigation/routes.dart';
import 'package:theme_desiree/a/controllers/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:theme_desiree/checkout/checkout_controller.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';
//import 'package:flutter/rendering.dart';
//import 'package:theme_desiree/signin_opt/phonecontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');

  await GetStorage.init();
//  NotificationService().initNotification();
//  initializeService();
  usePathUrlStrategy();
  Get.put(CartController());
  Get.put(CheckoutController());

  Get.put(AuthController());
  // Get.put(NotificationService());
  Get.put(NotificationController());
  Get.lazyPut(() => CurrencyController());
  Get.lazyPut(() => ThemeController());
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => CategoriesController());
  Get.lazyPut(() => SearchResultController());

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with OneSignal App ID
  OneSignal.initialize(
    dotenv.env['ONESIGNAL_APP_ID']!,
  );

  OneSignal.Notifications.requestPermission(true);
  await GetStorage.init();
  // debugPaintSizeEnabled = true;
  runApp(Application());
}

class Application extends StatelessWidget {
  Application({super.key});
  final checkoutController = Get.put(CheckoutController());
  final cartController = Get.put(CartController());

  // final cartController = Get.find<CartController>();
  // final checkoutController = Get.find<CheckoutController>();

  @override
  Widget build(BuildContext context) {
    print('\x1b[32m this is onesignal api key \x1b[0m');
    print(dotenv.env['ONESIGNAL_APP_ID']);
    return GetMaterialApp(
      builder: (context, child) {
        return GetX<ThemeController>(
          builder: (controller) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor:
                    controller.currentTheme.value.colorScheme.primary,
                systemNavigationBarColor: controller
                    .currentTheme.value.colorScheme.primary
                    .withAlpha(235),
                systemNavigationBarIconBrightness: controller.isDarkMode.value
                    ? Brightness.dark
                    : Brightness.light,
              ),
            );

            return FTheme(
              data: controller.currentTheme.value,
              child: SafeArea(
                child: FScaffold(
                  contentPad: false,
                  content: FTheme(
                    data: controller.currentTheme.value,
                    child: child!,
                  ),
                  footer: FBottomNavigationBar(
                    index: controller.navigation.value,
                    onChange: (index) {
                      controller.navigation.value = index;
                      switch (index) {
                        case 0:
                          Get.toNamed('/');
                          break;
                        case 1:
                          Get.toNamed('/categories');
                          break;
                        case 2:
                          Get.toNamed('/search');
                          break;
                        case 3:
                          Get.toNamed('/cart');
                          break;

                        case 4:
                          Get.toNamed('/settings');
                          break;

                        // case 4:
                        //   Get.toNamed('/settings');
                        //   break;
                      }
                    },
                    children: [
                      FBottomNavigationBarItem(
                        icon: FIcon(FAssets.icons.house),
                        label: const Text('Home'),
                      ),
                      FBottomNavigationBarItem(
                        icon: FIcon(FAssets.icons.layoutGrid),
                        label: const Text('Caregories'),
                      ),
                      FBottomNavigationBarItem(
                        icon: FIcon(FAssets.icons.search),
                        label: const Text('Search'),
                      ),
                      FBottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            FIcon(FAssets.icons.shoppingCart),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Builder(builder: (context) {
                                return Obx(() {
                                  if (cartController.products.isEmpty) {
                                    return SizedBox.shrink();
                                  }
                                  return Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.red,
                                    ),
                                  );
                                });
                              }),
                            ),
                          ],
                        ),
                        label: const Text('Cart'),
                      ),
                      FBottomNavigationBarItem(
                        icon: FIcon(FAssets.icons.circleUserRound),
                        label: const Text('Account'),
                      ),
                      // FBottomNavigationBarItem(
                      //   icon: FIcon(FAssets.icons.settings),
                      //   label: const Text('Settings'),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      translations: Languages(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}
