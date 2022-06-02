import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_screen.dart';
import 'package:social_media_app/screens/login_screen/login_screen.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() {
    User? user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(seconds: 2), () {
      if (user == null) {
        Navigator.pushReplacement(context, SlideRight(screen: LoginScreen()));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          UserModel userModel = UserModel.fromJson(value);
          Navigator.pushReplacement(
              context, SlideRight(screen: HomeScreen(userModel)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.blue,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColor.blue,
        ),
      ),
      backgroundColor: MyColor.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          Icon(
            FontAwesomeIcons.facebook,
            size: 150.r,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
