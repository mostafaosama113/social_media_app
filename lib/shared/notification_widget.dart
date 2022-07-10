import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_media_app/models/user_model.dart';

void showNotification({
  required RemoteMessage message,
  required bool isForeground,
}) {
  UserModel userModel = UserModel.fromJson(json.decode(message.data['model']));
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      wakeUpScreen: true,
      channelKey: 'basic_channel',
      title: message.data['name'],
      body: message.data['message'],
      payload: {
        'model': message.data['model'],
      },
    ),
  );
}
