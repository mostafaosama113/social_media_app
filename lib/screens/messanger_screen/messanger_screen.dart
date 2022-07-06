import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/chat_screen/chat_screen.dart';
import 'package:social_media_app/screens/messanger_screen/messanger_manger.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/shared/string_manger.dart';
import 'package:social_media_app/widgets/user_tile.dart';

import '../../widgets/loading_widget.dart';

class MessangerScreen extends StatefulWidget {
  const MessangerScreen({Key? key}) : super(key: key);

  @override
  _MessangerScreenState createState() => _MessangerScreenState();
}

class _MessangerScreenState extends State<MessangerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        MessangerManger manger = MessangerManger();
        return manger;
      },
      builder: (context, child) => Consumer<MessangerManger>(
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Text(
                    StringManger.messanger,
                    style: logoTextStyle,
                  ),
                ),
                body: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: defaultPadding,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideRight(
                            screen: ChatScreen(model.users[index]),
                          ),
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: userTile(
                        model.users[index],
                      ),
                    ),
                  ),
                  itemCount: model.users.length,
                ),
              ),
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
