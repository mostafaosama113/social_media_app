import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/user_model.dart';

class PostModel {
  String? content;
  late String date;
  late String userId;
  UserModel? userModel;
  String? image;
  late String postId;

  PostModel.fromJson(QueryDocumentSnapshot data) {
    postId = data.id;
    Map<String, dynamic> json = data.data() as Map<String, dynamic>;
    content = json['content'];
    date = json['date'];
    userId = json['user_id'];
    image = json['image'];
  }
  PostModel(
      {this.content,
      required this.date,
      required this.userId,
      this.userModel,
      this.image});

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'user_id': userId,
      'image': image,
    };
  }
}
