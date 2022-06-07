import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/shared/colors.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: MyColor.blue),
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: MyColor.blue,
        // statusBarBrightness: Brightness.dark,
      ),
    ),
  );
}
