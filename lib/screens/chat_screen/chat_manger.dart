import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/models/chat_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/get_current_time.dart';
import 'package:social_media_app/shared/get_messenger_code.dart';

class ChatManger extends ChangeNotifier {
  bool isTyping = false;
  List<ChatModel> chats = [];
  UserModel receiver;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  bool forFirstTime = true;
  late String messengerCode = getMessengerCode(myUid, receiver.uid);
  late StreamSubscription subscription;
  late StreamSubscription isTypingSubscription;
  ChatManger(this.receiver) {
    openStream();
    isTypingStream();
  }
  void closeAllStream() async {
    await subscription.cancel();
    await isTypingSubscription.cancel();
  }

  void isTypingStream() {
    isTypingSubscription = FirebaseFirestore.instance
        .collection('messenger')
        .doc(messengerCode)
        .collection('typing')
        .doc(receiver.uid)
        .snapshots()
        .listen(
      (event) async {
        if (!forFirstTime) {
          isTyping = true;
          notifyListeners();
          await Future.delayed(const Duration(seconds: 1));
          isTyping = false;
          notifyListeners();
        }
        forFirstTime = false;
      },
    );
  }

  void openStream() {
    subscription = FirebaseFirestore.instance
        .collection('messenger')
        .doc(messengerCode)
        .collection('massages')
        .orderBy('date', descending: true)
        .snapshots()
        .listen(
      (event) {
        chats = [];
        for (var element in event.docs) {
          chats.add(ChatModel.fromJson(element));
        }
        notifyListeners();
      },
    );
  }

  void sendMessage(TextEditingController controller) async {
    if (controller.text.isNotEmpty) {
      ChatModel model = ChatModel(
          date: '',
          from: myUid,
          to: receiver.uid,
          massage: controller.text,
          sent: false);
      chats.insert(0, model);
      controller.clear();
      notifyListeners();
      String date = await getCurrentTime();
      model.date = date;
      DocumentReference reference = await FirebaseFirestore.instance
          .collection('messenger')
          .doc(messengerCode)
          .collection('massages')
          .add(model.getJson());
    }
  }

  void deleteMessage(ChatModel chat) async {
    await FirebaseFirestore.instance
        .collection('messenger')
        .doc(messengerCode)
        .collection('massages')
        .doc(chat.id)
        .delete();
  }

  void typing() {
    FirebaseFirestore.instance
        .collection('messenger')
        .doc(messengerCode)
        .collection('typing')
        .doc(myUid)
        .set({'typing': generateRandomString(15)});
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
