import 'package:dio/dio.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/string_manger.dart';

Future pushNotification({
  required UserModel receiver,
  required String senderName,
  required String message,
}) async {
  Dio dio = Dio();
  await dio.post(
    'https://fcm.googleapis.com/fcm/send',
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=${StringManger.serverKey}',
      },
    ),
    data: {
      'to': '/topics/${receiver.uid}',
      "data": {
        "name": senderName,
        "message": message,
        "model": receiver.toJson(),
      },
    },
  );
}
