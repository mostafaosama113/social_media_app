import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/get_current_time.dart';
import 'package:social_media_app/static_access/mangers.dart';

class CommentManger extends ChangeNotifier {
  CommentManger(this.postModel) {
    getAllComments();
  }
  final PostModel postModel;
  bool isLoading = false;
  List<CommentModel> comments = [];

  void addNewComment(TextEditingController controller) async {
    String comment = controller.text;
    if (comment.isNotEmpty) {
      String date = await getCurrentTime();
      String uid = FirebaseAuth.instance.currentUser!.uid;
      UserModel user = StaticManger.userModel!;
      CommentModel commentModel = CommentModel(
        userId: uid,
        data: date,
        comment: comment,
        user: user,
      );
      controller.clear();
      comments.add(commentModel);
      notifyListeners();
      try {
        DocumentReference reference = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postModel.postId)
            .collection('comments')
            .add(
              commentModel.toJson(),
            );
        commentModel.commentId = reference.id;
      } catch (error) {
        toast('Error');
        comments.remove(commentModel);
        notifyListeners();
      }
    }
  }

  void getAllComments() async {
    isLoading = true;
    notifyListeners();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('comments')
        .orderBy('data')
        .get();
    List<QueryDocumentSnapshot<Object?>> list = snapshot.docs;
    for (QueryDocumentSnapshot element in list) {
      CommentModel model = CommentModel.fromJson(element);
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection('users')
          .doc(model.userId)
          .get();
      model.user = UserModel.fromJson(user);
      comments.add(model);
    }
    isLoading = false;
    notifyListeners();
  }

  void deleteComment(
      {required CommentModel commentModel,
      required PostModel postModel}) async {
    int index = comments.indexOf(commentModel);
    comments.remove(commentModel);
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postModel.postId)
          .collection('comments')
          .doc(commentModel.commentId)
          .delete();
    } catch (error) {
      toast('Error');
      comments.insert(index, commentModel);
      notifyListeners();
    }
  }
}
