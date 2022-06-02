import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_screen.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/components/toast.dart';

class LoginManger extends ChangeNotifier {
  bool isLoading = false;

  void login(context, {required String email, required String password}) {
    isLoading = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (email.isEmpty) {
      toast(
        'Email is required',
      );
      return;
    }
    if (password.isEmpty) {
      toast(
        'Password is required',
      );
      return;
    }
    notifyListeners();
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        UserModel userModel = UserModel.fromJson(value.id, value.data()!);
        isLoading = false;
        notifyListeners();
        Navigator.pushReplacement(
            context, SlideRight(screen: HomeScreen(userModel)));
      });
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      toast(error.message);
    });
  }
}
