import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:http/http.dart' as http;

class CreateNewPostScreen extends StatefulWidget {
  const CreateNewPostScreen({Key? key, this.postModel}) : super(key: key);
  final PostModel? postModel;
  @override
  _CreateNewPostScreenState createState() => _CreateNewPostScreenState();
}

class _CreateNewPostScreenState extends State<CreateNewPostScreen> {
  final HomeManger homeManger = StaticManger.homeManger!;
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;
  File? photo;
  @override
  void initState() {
    super.initState();
    if (widget.postModel != null) {
      editPost();
    }
  }

  void editPost() async {
    setState(() {
      isLoading = true;
    });
    PostModel model = widget.postModel!;
    if (model.image != null) {
      var url = Uri.parse(model.image!);
      final response = await http.get(url);
      final documentDirectory = await getApplicationDocumentsDirectory();
      photo = File(join(documentDirectory.path, 'imagetest.png'));
      photo!.writeAsBytesSync(response.bodyBytes);
    }

    if (model.content != null) textController.text = model.content!;
    setState(() {
      isLoading = false;
    });
  }

  void upload(context) async {
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

    if (widget.postModel == null) {
      await homeManger.addNewPost(model);
    } else {
      model.postId = widget.postModel!.postId;
      model.date = widget.postModel!.date;
      await homeManger.updatePost(
        model,
      );
    }

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  void getPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
                  onPressed: () => upload(context),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                    return Container(
                      height: MediaQuery.of(context).size.height * .4,
                      child: Padding(
                        padding: defaultPadding,
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(3),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.file(photo!),
                              ),
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
