import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:theme_desiree/a/models/notification.dart';

class NotificationController extends GetxController {
  final GetStorage box = GetStorage();
  final List notifications = [].obs;

  List<NotificationSettings> settings = [
    NotificationSettings(
        key: 'promotions', label: 'Updates and promotions', agree: true),
    NotificationSettings(
        key: 'security', label: 'Security alerts', agree: true),
    NotificationSettings(
        key: 'orders', label: 'Orders and deliveries', agree: true),
    NotificationSettings(key: 'save', label: 'Save notifications', agree: true),
  ];

  void toggleNotification(String key) {
    int index = notifications.indexWhere((element) => element.key == key);
    if (index != -1) {
      notifications[index] = NotificationSettings(
        key: notifications[index].key,
        label: notifications[index].label,
        agree: !notifications[index].agree,
      );
      // Save updated list
      box.write("notifications", notifications.map((e) => e.toJson()).toList());
    }
  }

  @override
  void onInit() {
    super.onInit();
    //  SocketManager().initSocket();
    final savedSettings = box.read("notifications");
    if (savedSettings != null) {
      notifications.assignAll(
        List<NotificationSettings>.from(
          savedSettings.map((e) => NotificationSettings.fromJson(e)),
        ),
      );
    } else {
      notifications.assignAll(settings);
    }
  }
}
