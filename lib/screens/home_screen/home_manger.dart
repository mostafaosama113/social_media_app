import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/login_screen/login_screen.dart';
import 'package:social_media_app/screens/profile_screen/profile_manger.dart';
import 'package:social_media_app/shared/get_current_time.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/static_access/mangers.dart';

class HomeManger extends ChangeNotifier {
  bool isLoading = false;
  List<PostModel> posts = [];
  Map<String, List<PostModel>> postById = {};
  DateTime? dateTime;
  UserModel user;

  HomeManger(this.user);
  Future getPosts() async {
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
        PostModel model = PostModel.fromJson(data);
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

  Future addNewPost(PostModel model) async {
    DocumentReference ref =
        await FirebaseFirestore.instance.collection('posts').add(
              model.toJson(),
            );
    model.postId = ref.id;
    posts.insert(0, model);
    if (postById[user.uid] == null) postById.addAll({});
    postById[user.uid]!.insert(0, model);
    notifyListeners();
  }

  void deletePost(context, PostModel model, bool isActive) async {
    isLoading = true;
    ProfileManger? manger = StaticManger.profileManger;
    if (!isActive) {
      manger!.isLoading = true;
      manger.notifyListeners();
    }
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(model.postId)
        .delete();
    int index = 0;
    for (PostModel temp in posts) {
      if (temp.postId == model.postId) {
        break;
      }
      index++;
    }
    posts.removeAt(index);
    index = 0;
    for (PostModel temp in postById[user.uid]!) {
      if (temp.postId == model.postId) {
        break;
      }
      index++;
    }
    postById[user.uid]!.removeAt(index);
    isLoading = false;
    notifyListeners();
    if (!isActive) {
      manger!.postModel = postById[user.uid]!;
      manger.isLoading = false;
      manger.notifyListeners();
    }
    Navigator.pop(context);
  }
}
