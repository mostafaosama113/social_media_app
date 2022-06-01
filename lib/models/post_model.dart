import 'package:social_media_app/models/user_model.dart';

class PostModel {
  String? content;
  late String date;
  late String userId;
  UserModel? userModel;
  String? image;

  PostModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    date = json['date'];
    userId = json['user_id'];
    image = json['image'];
  }
}
