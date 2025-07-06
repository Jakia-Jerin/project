import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:theme_desiree/a/models/notification.dart';
import 'package:theme_desiree/a/services/notification.dart';

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  final box = GetStorage();

  IO.Socket? _socket;

  SocketManager._internal();

  void initSocket() {
    // Initialize socket connection
    _socket = IO.io(
        'https://test-socket-2m2q.onrender.com/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"query": "data"})
            .build());

    // Connect to the server
    _socket?.connect();

    final savedSettings = box.read("notifications") ?? [];
    final savedNotificationSettings = List<NotificationSettings>.from(
      savedSettings.map((e) => NotificationSettings.fromJson(e)),
    );
    // Listen for incoming notifications
    _socket?.on('message', (data) {
      final String notificationType = data['type'];

      NotificationSettings? notificationSettings = savedNotificationSettings
          .firstWhereOrNull((element) => element.key == notificationType);

      if (notificationSettings != null && notificationSettings.agree) {
        NotificationService().showNotification(
          id: data['id'],
          title: data['title'],
          body: data['body'],
          icon: data['icon'],
          image: data['image'],
          url: data['url'],
          priority: data['priority'],
        );
      }
    });
  }

  void dispose() {
    // Disconnect the socket when no longer needed
    _socket?.disconnect();
  }
}
