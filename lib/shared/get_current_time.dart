import 'package:dio/dio.dart';

Future<String> getCurrentTime() async {
  Response response =
      await Dio().get('http://worldtimeapi.org/api/timezone/Africa/Cairo');
  return response.data['datetime'];
}
