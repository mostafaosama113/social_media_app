import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/user_model.dart';

class MessangerManger extends ChangeNotifier {
  bool isLoading = false;
  List<UserModel> users = [];
  MessangerManger() {
    getAllUser();
  }
  void getAllUser() async {
    isLoading = true;
    notifyListeners();
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<QueryDocumentSnapshot> list = snapshot.docs;
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    for (QueryDocumentSnapshot documentSnapshot in list) {
      UserModel model = UserModel.fromJson(documentSnapshot);
      if (model.uid != myUid) users.add(model);
    }
    isLoading = false;
    notifyListeners();
  }
}
