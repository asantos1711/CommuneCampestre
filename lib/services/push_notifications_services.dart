import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// P8 : key ID: 68K3Q7J7DM

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _streamMessage =
      new StreamController.broadcast();
  static Stream<String> get messageStream => _streamMessage.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print("backgroundHandler ${message.messageId}");
    _streamMessage.sink.add(message.notification?.title ?? 'No title');
    _streamMessage.sink.add(message.notification?.body ?? 'No Body');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print("onMessageHandler ${message.messageId}");
    //_streamMessage.sink.add(message.notification?.title ?? 'No title');
    _streamMessage.sink.add(message.notification?.body ?? 'No Body');
  }

  static Future _onOpenMessageOpenApp(RemoteMessage message) async {
    print("onOpenMessageOpenApp ${message.messageId}");
    //_streamMessage.sink.add(message.notification?.title ?? 'No title');
    _streamMessage.sink.add(message.notification?.body ?? 'No Body');
  }

  static Future initializeApp() async {
    //Push notifications

    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    }

    else{
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
      

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification as RemoteNotification;
      AndroidNotification android = message.notification?.android as AndroidNotification;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
    }

    token = await FirebaseMessaging.instance.getToken();

    print("Token Messaging: " + token.toString());

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessageOpenApp);
    //Local notificatios
  }

  getToken() {
    return token.toString();
  }

  static closeStream() {
    _streamMessage.close();
  }
}
