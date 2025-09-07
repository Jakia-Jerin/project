import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/settings.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final accountController = Get.put(SettingsController());
  final authController = Get.put(AuthController());
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Account'.tr.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
          FDivider(
            style: FTheme.of(context)
                .dividerStyles
                .verticalStyle
                .copyWith(width: 1, padding: EdgeInsets.zero),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() {
            if (authController.isLoggedIn.value) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   "Logged in as",
                    //   style: contextTheme.typography.sm.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(height: 6),
                    Text(
                      authController.userEmailOrPhone.value,
                      style: contextTheme.typography.sm
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('settings/userme');
                      },
                      child: FIcon(
                        FAssets.icons.circleUser,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: FButton(
                  onPress: () => Get.toNamed('settings/profile'),
                  style: contextTheme.buttonStyles.primary.copyWith(
                    contentStyle:
                        contextTheme.buttonStyles.primary.contentStyle.copyWith(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  label: Text(
                    'Sign up or Log in'.tr,
                    style: contextTheme.typography.sm.copyWith(
                      color: contextTheme.typography.sm.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 10),
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
                child: Column(
                  children: [
                    GetX<SettingsController>(
                      builder: (controller) {
                        return FTileGroup.builder(
                          count: controller.profileMenus.length,
                          tileBuilder: (context, index) {
                            final item = controller.profileMenus[index];
                            return FTile(
                              onPress: () {
                                Get.toNamed(item.route);
                              },
                              title: Text(item.title.tr),
                              subtitle: Text(item.subtitle.tr),
                              prefixIcon: item.icon,
                              suffixIcon: FIcon(FAssets.icons.chevronRight),
                            );
                          },
                          divider: FTileDivider.full,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    FTile(
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text('Log out'),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                ),
                                //   actionsAlignment: MainAxisAlignment.end,
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 10),
                                      FButton(
                                        style: contextTheme.buttonStyles.primary
                                            .copyWith(
                                          contentStyle: contextTheme
                                              .buttonStyles.primary.contentStyle
                                              .copyWith(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 8),
                                          ),
                                        ),
                                        onPress: () {
                                          Navigator.of(context).pop();
                                        },
                                        label: Text('CANCEL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: contextTheme
                                                    .typography.lg.color,
                                                fontSize: 15)),
                                      ),
                                      SizedBox(width: 16),
                                      FButton(
                                        style: contextTheme.buttonStyles.primary
                                            .copyWith(
                                          contentStyle: contextTheme
                                              .buttonStyles.primary.contentStyle
                                              .copyWith(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 8),
                                          ),
                                        ),
                                        onPress: () {
                                          authController.logout();
                                        },
                                        label: Text(
                                          'LOG OUT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: contextTheme
                                                  .typography.lg.color,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]);
                          },
                        );
                      },
                      title: Text(
                        "Logout".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      prefixIcon: FIcon(
                        FAssets.icons.logOut,
                        size: 22,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      suffixIcon: FIcon(
                        FAssets.icons.chevronRight,
                        size: 22,
                        color: FTheme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Version 10.2.3',
                      style: FTheme.of(context).typography.xs.copyWith(
                            fontStyle: FontStyle.italic,
                            color: FTheme.of(context)
                                .colorScheme
                                .secondaryForeground
                                .withAlpha(80),
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
