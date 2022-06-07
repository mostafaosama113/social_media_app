import 'package:flutter/material.dart';
import 'package:social_media_app/screens/update_picture_screen/update_picture_screen.dart';

class UpdatePicManger extends ChangeNotifier {
  UpdatePicManger(this.type);
  final PicType type;
  bool isLoading = false;
  void update(context) {
    Navigator.pop(context);
  }
}
