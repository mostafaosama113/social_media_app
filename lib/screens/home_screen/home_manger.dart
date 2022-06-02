import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/login_screen/login_screen.dart';
import 'package:social_media_app/shared/navigator.dart';

class HomeManger extends ChangeNotifier {
  bool isLoading = false;
  List<PostModel> posts = [];
  Map<String, List<PostModel>> postById = {};
  void getPosts() {
    isLoading = true;
    notifyListeners();
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) async {
      List<QueryDocumentSnapshot> dataList = value.docs;
      for (QueryDocumentSnapshot data in dataList) {
        PostModel model =
            PostModel.fromJson(data.data() as Map<String, dynamic>);
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(model.userId)
            .get();
        model.userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        posts.add(model);
        if (postById[model.userId] == null) postById[model.userId] = [];
        postById[model.userId]!.add(model);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut(context) {
    isLoading = true;
    notifyListeners();
    FirebaseAuth.instance.signOut().then(
      (value) {
        isLoading = false;
        notifyListeners();
        Navigator.pushReplacement(context, SlideRight(screen: LoginScreen()));
      },
    );
  }
}
