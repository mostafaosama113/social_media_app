import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/picture_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/login_screen/login_screen.dart';
import 'package:social_media_app/shared/get_current_time.dart';
import 'package:social_media_app/shared/navigator.dart';

class HomeManger extends ChangeNotifier {
  bool isLoading = false;
  List<PostModel> posts = [];
  Map<String, List<PostModel>> postById = {};
  DateTime? dateTime;
  UserModel user;

  HomeManger(this.user);
  void getPosts() async {
    posts = [];
    postById.clear();
    isLoading = true;
    notifyListeners();
    String curTime = await getCurrentTime();
    dateTime = DateTime.parse(curTime);
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
        model.userModel = UserModel.fromJson(snapshot);
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
