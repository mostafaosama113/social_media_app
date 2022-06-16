import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/user_model.dart';

class CommentModel {
  late String userId;
  late String comment;
  late String data;
  late String commentId;
  UserModel? user;
  CommentModel({
    required this.comment,
    required this.userId,
    required this.data,
    this.user,
  });
  CommentModel.fromJson(QueryDocumentSnapshot snapshot) {
    commentId = snapshot.id;
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    userId = json['user_id'];
    comment = json['comment'];
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'data': data,
      'user_id': userId,
    };
  }
}
