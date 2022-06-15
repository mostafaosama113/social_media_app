import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/user_model.dart';

class CommentModel {
  late String userId;
  late String comment;
  late String data;
  UserModel? user;
  CommentModel({
    required this.comment,
    required this.userId,
    required this.data,
  });
  CommentModel.fromJson(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    userId = json['user_id'];
    comment = json['comment'];
    data = json['data'];
  }
}
