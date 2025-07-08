// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:theme_desiree/a/services/utils.dart';

// class NotificationService extends GetxController {
//   final notificationPlugin = FlutterLocalNotificationsPlugin();
//   final isInitialize = false.obs;
//   final utils = Utils();
//   Future<void> initNotification() async {
//     await Permission.notification.request();
//     if (isInitialize.value) return;

//     const initSettingsAndroid =
//         AndroidInitializationSettings("@mipmap/launcher_icon");

//     const initSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingsIOS,
//     );

//     await notificationPlugin.initialize(initSettings);
//     isInitialize.value = true;
//   }

//   Future<NotificationDetails> notificationDetails(String? icon, String? image,
//       Importance importance, Priority priority) async {
//     final bigPicturePath =
//         await utils.downloadFile(image, UniqueKey().toString());
//     final largeIconPath =
//         await utils.downloadFile(icon, UniqueKey().toString());

//     final styleInformation = bigPicturePath == null
//         ? null
//         : BigPictureStyleInformation(
//             FilePathAndroidBitmap(bigPicturePath),
//             largeIcon: largeIconPath == null
//                 ? null
//                 : FilePathAndroidBitmap(largeIconPath),
//           );
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         "apidoxy_notification_channel_id",
//         "Notification",
//         importance: importance,
//         priority: priority,
//         styleInformation: styleInformation,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   Future<void> showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? icon,
//     String? image,
//     String? url,
//     String? priority,
//   }) async {
//     late Priority priorityMeasure;
//     late Importance importanceMeasure;
//     switch (priority) {
//       case 'high':
//         priorityMeasure = Priority.high;
//         importanceMeasure = Importance.high;
//       case 'low':
//         priorityMeasure = Priority.low;
//         importanceMeasure = Importance.low;
//       case 'max':
//         priorityMeasure = Priority.max;
//         importanceMeasure = Importance.max;
//       case 'min':
//         priorityMeasure = Priority.min;
//         importanceMeasure = Importance.min;
//       default:
//         priorityMeasure = Priority.defaultPriority;
//         importanceMeasure = Importance.defaultImportance;
//     }
//     await notificationPlugin.show(
//       id,
//       title,
//       body,
//       await notificationDetails(
//         icon,
//         image,
//         importanceMeasure,
//         priorityMeasure,
//       ),
//     );
//   }
// }
