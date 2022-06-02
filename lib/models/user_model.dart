class UserModel {
  late String name;
  late String image;
  late String cover;
  String uid;
  String? bio;

  UserModel.fromJson(this.uid, Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }
}
