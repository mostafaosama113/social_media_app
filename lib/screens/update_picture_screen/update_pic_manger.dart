import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/picture_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/update_picture_screen/update_picture_screen.dart';
import 'package:social_media_app/static_access/mangers.dart';

class UpdatePicManger extends ChangeNotifier {
  final PicType type;
  bool isLoading = false;
  BuildContext context;
  List<PictureModel> pictures = [];
  UpdatePicManger({required this.type, required this.context}) {
    isLoading = true;
    notifyListeners();
    getAllPicture();
  }
  void getAllPicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    ListResult result =
        await storageRef.child('$uid/personal_picture').listAll();
    List<Reference> data = result.items;
    HomeManger homeManger = StaticManger.homeManger!;
    for (Reference ref in data) {
      String link = await ref.getDownloadURL();
      PictureModel model = PictureModel(link: link);
      if (type == PicType.profile && homeManger.user.image == link) {
        model.isSelected = true;
      } else if (type == PicType.cover && homeManger.user.cover == link) {
        model.isSelected = true;
      }
      pictures.add(model);
    }
    isLoading = false;
    notifyListeners();
  }

  void update(context) async {
    isLoading = true;
    notifyListeners();
    HomeManger homeManger = StaticManger.homeManger!;
    String selectedPhoto = '';
    for (PictureModel picture in pictures) {
      if (picture.isSelected) {
        selectedPhoto = picture.link;
        break;
      }
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(homeManger.user.uid)
        .update({type == PicType.profile ? 'image' : 'cover': selectedPhoto});
    if (type == PicType.profile) {
      homeManger.user.image = selectedPhoto;
    }
    if (type == PicType.cover) {
      homeManger.user.cover = selectedPhoto;
    }
    isLoading = false;
    notifyListeners();
    homeManger.getPosts();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
