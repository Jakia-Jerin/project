import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:theme_desiree/a/services/socket.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      initialNotificationContent: 'Preparing',
      initialNotificationTitle: 'Backgroun Sync',
    ),
  );
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  SocketManager().initSocket();
}
