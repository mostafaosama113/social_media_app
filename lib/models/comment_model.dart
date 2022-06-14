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
}
