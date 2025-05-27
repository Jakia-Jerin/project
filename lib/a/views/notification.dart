import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/a/controllers/notification.dart';
import 'package:theme_desiree/a/models/notification.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});
  final notificationController = Get.find<NotificationController>();
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
                  'Notifications'.tr.toUpperCase(),
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
                  child: Obx(() {
                    return FTileGroup.builder(
                      count: notificationController.notifications.length,
                      divider: FTileDivider.full,
                      tileBuilder: (context, index) {
                        final NotificationSettings option =
                            notificationController.notifications[index];
                        return FTile(
                          title: Text(option.label.tr),
                          suffixIcon: FSwitch(
                            value: option.agree,
                            onChange: (value) {
                              HapticFeedback.heavyImpact();
                              notificationController
                                  .toggleNotification(option.key);
                            },
                          ),
                        );
                      },
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
