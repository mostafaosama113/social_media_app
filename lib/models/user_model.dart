class UserModel {
  late String name;
  late String image;
  late String cover;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
  }
}
