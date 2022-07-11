import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/static_access/mangers.dart';

void showNotification({
  required RemoteMessage message,
}) {
  UserModel userModel = UserModel.fromJson(json.decode(message.data['model']));
  if (StaticManger.chatManger[userModel.uid] == null ||
      StaticManger.chatManger[userModel.uid]!.receiver.uid != userModel.uid) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        groupKey: userModel.uid,
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
}
