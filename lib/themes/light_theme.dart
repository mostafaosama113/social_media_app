import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
          // statusBarBrightness: Brightness.dark,
        )),
  );
}
