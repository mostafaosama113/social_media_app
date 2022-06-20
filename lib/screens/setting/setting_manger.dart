import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';

class SettingManger extends ChangeNotifier {
  bool isLoading = false;
  final HomeManger _homeManger = StaticManger.homeManger!;

  void updateName(String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    isLoading = true;
    notifyListeners();
    await FirebaseFirestore.instance.collection('users').doc(uid).update(
      {'name': name},
    );
    _homeManger.user.name = name;
    isLoading = false;
    _homeManger.notifyListeners();
    notifyListeners();
  }

  void updateBio(String? bio) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (bio!.isEmpty) bio = null;
    isLoading = true;
    notifyListeners();
    await FirebaseFirestore.instance.collection('users').doc(uid).update(
      {'bio': bio},
    );
    _homeManger.user.bio = bio;
    isLoading = false;
    _homeManger.notifyListeners();
    notifyListeners();
  }
}
