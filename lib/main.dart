import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_media_app/screens/splash_screen.dart';
import 'package:social_media_app/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
