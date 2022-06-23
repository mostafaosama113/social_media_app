import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/chat_screen/chat_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/send_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.userModel, {Key? key}) : super(key: key);
  final UserModel userModel;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    StaticManger.chatManger!.subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    return ChangeNotifierProvider(
      create: (context) {
        StaticManger.chatManger = ChatManger(widget.userModel);
        return StaticManger.chatManger;
      },
      builder: (context, child) => Consumer<ChatManger>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.image),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.userModel.name,
                    style: defaultTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemBuilder: (context, index) {
                      return BubbleSpecialThree(
                        text: model.chats[index].massage,
                        tail: true,
                        sent: widget.userModel.uid != model.chats[index].from &&
                            model.chats[index].sent,
                        isSender:
                            widget.userModel.uid != model.chats[index].from,
                        color: widget.userModel.uid != model.chats[index].from
                            ? MyColor.lightBlue
                            : MyColor.grey,
                      );
                    },
                    itemCount: model.chats.length,
                  ),
                ),
                Container(
                  height: 1,
                  color: MyColor.blue,
                ),
                sendWidget(
                    controller: controller,
                    onClick: () {
                      model.sendMessage(controller);
                    },
                    hint: 'Aa')
              ],
            ),
          );
        },
      ),
    );
  }
}
