import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name;
  late String image;
  late String cover;
  late String uid;
  String? bio;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    uid = snapshot.id;
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }
  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }
  UserModel({
    required this.name,
    required this.image,
    required this.cover,
    required this.uid,
    this.bio,
  });
  Map toJson() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'cover': cover,
      'bio': bio,
    };
  }
}
