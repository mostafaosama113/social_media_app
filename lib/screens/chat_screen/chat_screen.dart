import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/chat_screen/chat_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/post_setting.dart';
import 'package:social_media_app/widgets/send_widget.dart';
import 'package:social_media_app/widgets/user_tile.dart';

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
    StaticManger.chatManger!.closeAllStream();
    StaticManger.chatManger = null;
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
              title: userTile(
                widget.userModel,
                isTyping: model.isTyping,
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
                      return InkWell(
                        onLongPress: () {
                          if (myUid == model.chats[index].from) {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: postSetting(
                                  icon: Icons.delete,
                                  title: 'Delete message',
                                  onClick: () {
                                    Navigator.pop(context);
                                    model.deleteMessage(model.chats[index]);
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: BubbleSpecialThree(
                          text: model.chats[index].massage,
                          tail: true,
                          sent:
                              widget.userModel.uid != model.chats[index].from &&
                                  model.chats[index].sent,
                          isSender:
                              widget.userModel.uid != model.chats[index].from,
                          color: widget.userModel.uid != model.chats[index].from
                              ? MyColor.lightBlue
                              : MyColor.grey,
                        ),
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
                  onChange: () => model.typing(),
                  hint: 'Aa',
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
