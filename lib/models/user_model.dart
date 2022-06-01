class UserModel {
  late String name;
  late String image;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}
