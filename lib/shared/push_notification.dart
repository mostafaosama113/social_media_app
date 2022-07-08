import 'package:dio/dio.dart';

Future pushNotification({
  required String toToken,
  required String name,
  required String message,
}) async {
  var serverKey =
      'AAAAZ-ZpkBU:APA91bHfyJJyjlNnn5D9O8hQDjoN0UBPUJGyRjrxnDQ5GTssgeV24rQZ3FdOxEXO-fwrShfbwOYxAVQn6YCrHV-nznqQdvXUwf-_ElSWJIwksDjhd3IofFphi8DVjf4-lNhBNRQDjRrD';
  Dio dio = Dio();
  await dio.post(
    'https://fcm.googleapis.com/fcm/send',
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
    ),
    data: {
      'to': '/topics/$toToken',
      "data": {
        "title": name,
        "body": message,
      },
    },
  );
}
