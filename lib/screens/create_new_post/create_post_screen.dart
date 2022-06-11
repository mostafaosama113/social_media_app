import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/get_current_time.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

class CreateNewPostScreen extends StatefulWidget {
  const CreateNewPostScreen({Key? key}) : super(key: key);

  @override
  _CreateNewPostScreenState createState() => _CreateNewPostScreenState();
}

class _CreateNewPostScreenState extends State<CreateNewPostScreen> {
  final HomeManger homeManger = StaticManger.homeManger!;
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;
  File? photo;
  void upload() async {
    setState(() {
      isLoading = true;
    });
    String uid = homeManger.user.uid;
    String text = textController.text;
    UserModel user = homeManger.user;
    String? image;
    if (photo == null && text.isEmpty) {
      toast('empty post');
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (photo != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      UploadTask tast = FirebaseStorage.instance
          .ref()
          .child('$uid/posts/${Uri.file(photo!.path).pathSegments.last}')
          .putFile(photo!);
      image = await (await tast).ref.getDownloadURL();
    }
    String date = await getCurrentTime();
    PostModel model = PostModel(
      userId: uid,
      date: date,
      image: image,
      content: text,
      userModel: user,
    );
    await homeManger.addNewPost(model);

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  void getPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        photo = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, keyboardOpen) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: true,
              title: Text(
                'Create Post',
                style: defaultTextStyle.copyWith(
                  color: MyColor.blue,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => upload(),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: defaultPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          homeManger.user.image,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        homeManger.user.name,
                        style: defaultTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    decoration: const InputDecoration(
                        contentPadding: defaultPadding,
                        hintText: 'What\'s on your mind?',
                        border: InputBorder.none),
                  ),
                ),

                Builder(builder: (context) {
                  if (photo == null) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () => getPhoto(),
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              border: Border.all(color: MyColor.grey),
                              color: Colors.white,
                            ),
                            height: 70,
                            child: Padding(
                              padding: defaultPadding,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: MyColor.lightBlue,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Add photo',
                                    style: defaultTextStyle.copyWith(
                                        color: MyColor.lightBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (keyboardOpen) {
                    return const SizedBox();
                  } else {
                    return Padding(
                      padding: defaultPadding,
                      child: Stack(
                        children: [
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(3),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.file(photo!),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      photo = null;
                                    });
                                  },
                                  child: const Icon(Icons.cancel,
                                      color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),

                // Spacer(),
              ],
            ),
          ),
          if (isLoading) loadingWidget(),
        ],
      ),
    );
  }
}
