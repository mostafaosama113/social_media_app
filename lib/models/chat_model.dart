import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String date;
  late String from;
  late String to;
  late String massage;
  bool sent = true;

  ChatModel.fromJson(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    date = json['date'];
    from = json['from'];
    to = json['to'];
    massage = json['massage'];
  }
  ChatModel({
    required this.date,
    required this.from,
    required this.massage,
    required this.to,
    this.sent = true,
  });

  Map<String, dynamic> getJson() {
    return {
      'date': date,
      'from': from,
      'to': to,
      'massage': massage,
    };
  }
}
