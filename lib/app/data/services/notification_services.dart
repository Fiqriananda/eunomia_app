import 'package:get/get.dart';
import 'api_service.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Pesan masuk di background: ${message.messageId}");
}

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // Harus sama dengan yang di AndroidManifest.xml
    'High Importance Notifications',
    description: 'Channel untuk notifikasi penting aplikasi.',
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    final fcmToken = await _fcm.getToken();
    print("FCM Token Perangkat: $fcmToken");

    if (fcmToken != null && Get.isRegistered<ApiService>() && ApiService.to.isAuthenticated) {
      ApiService.to.registerDeviceToken(fcmToken);
    }

    // Pantau jika token diperbarui oleh sistem
    _fcm.onTokenRefresh.listen((newToken) {
      if (Get.isRegistered<ApiService>() && ApiService.to.isAuthenticated) {
        ApiService.to.registerDeviceToken(newToken);
      }
    });

    // 3. Setup Local Notifications (untuk memunculkan pop-up saat Foreground)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      settings:
          const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          final data = jsonDecode(details.payload!);
          _handleNotificationClick(data);
        }
      },
    );

    // Daftarkan channel ke sistem Android
    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    await androidPlugin?.requestNotificationsPermission();

    // Agar iOS tetap memunculkan banner saat aplikasi sedang dibuka
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Daftarkan Listener
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listener saat aplikasi sedang DIBUKA (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final title = notification?.title ?? message.data['title'] ?? 'Eunomia';
      final body = notification?.body ?? message.data['body'] ?? '';

      // Munculkan pop-up di Foreground
      if (notification != null || message.data.isNotEmpty) {
        _localNotifications.show(
          id: message.messageId.hashCode,
          title: title,
          body: body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    // Listener saat notifikasi DIKLIK dari posisi Background (App diminimize)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });

    // Cek apakah aplikasi baru saja dibuka dari kondisi Terminated (Mati total) lewat klik notif
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    print("Notifikasi diklik dengan data: $data");
    // TODO: Arahkan halaman menggunakan NavigatorKey atau GoRouter
    // Contoh: if (data['type'] == 'order') router.push('/orders/${data['id']}');
  }
}