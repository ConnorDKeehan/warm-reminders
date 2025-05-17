import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:warmreminders/utils/storage_util.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  Future<void> initialize() async {
    _requestPermission();

    await _getAndSetDeviceToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _getAndSetDeviceToken() async {
    String? token;
    try {
      token = await _messaging.getToken();
      if (token != null) {
        await setPushNotificationToken(token);
      }
    } catch (e) {
      Exception("Cannot get Token");
    }
  }
}



