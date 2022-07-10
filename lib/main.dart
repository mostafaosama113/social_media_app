import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/chat_screen/chat_screen.dart';
import 'package:social_media_app/screens/splash_screen.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/shared/notification_widget.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/themes/light_theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  showNotification(message: message, isForeground: false);
}

void initializeNotification() async {
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          locked: true,
          defaultPrivacy: NotificationPrivacy.Public,
          importance: NotificationImportance.High,
          channelShowBadge: true),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();
  await Firebase.initializeApp();
  AwesomeNotifications()
      .actionStream
      .listen((ReceivedNotification receivedNotification) async {
    UserModel user = UserModel.fromJson(
        json.decode(receivedNotification.payload!['model']!));
    if (StaticManger.context ==
        null /*receivedNotification.payload!['isForeground'] == 'no'*/) {
      await Future.delayed(const Duration(seconds: 5));
    }
    Navigator.push(
      StaticManger.context!,
      SlideRight(
        screen: ChatScreen(user),
      ),
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    return ScreenUtilInit(
      builder: (context, child) => OKToast(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            home: const SplashScreen()),
      ),
    );
  }
}
