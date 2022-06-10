import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';

class ProfileManger extends ChangeNotifier {
  bool isLoading = false;
  List<PostModel> postModel;
  ProfileManger(this.postModel);
}
