import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/photo_viewer.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/post_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/string_manger.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen(
      {Key? key,
      required this.postModel,
      required this.homeManger,
      required this.userModel})
      : super(key: key);

  final List<PostModel> postModel;
  final HomeManger homeManger;
  final UserModel userModel;
  Widget cameraBtn({required Function onClick}) {
    if (userModel.uid == FirebaseAuth.instance.currentUser!.uid) {
      return InkWell(
        onTap: () => onClick(),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 18.5,
              child: Icon(
                FontAwesomeIcons.camera,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget getHeader(context) {
    return Column(
      children: [
        Container(
          height: 250.h,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewer(userModel.cover),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Image(
                      image: NetworkImage(
                        userModel.cover,
                      ),
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 200.h,
                    ),
                    cameraBtn(onClick: () {}),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    height: 150.h,
                    width: 140.h,
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60.r,
                            child: Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PhotoViewer(userModel.image),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 57.r,
                                  backgroundImage:
                                      NetworkImage(userModel.image),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: cameraBtn(onClick: () {}),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: defaultPadding,
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              userModel.name,
              style: defaultNameStyle,
            ),
          ),
        ),
        if (userModel.bio != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                userModel.bio!,
                style: defaultHintStyle,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            color: Colors.grey,
            height: 1,
            width: double.infinity,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              StringManger.appTitle,
              style: logoTextStyle,
            ),
          ),
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return getHeader(context);
              } else {
                return PostWidget(
                  homeManger: homeManger,
                  postModel: postModel[index - 1],
                  isActive: false,
                );
              }
            },
            itemCount: postModel.length + 1,
          ),
        ),
        if (false) loadingWidget(),
      ],
    );
  }
}
