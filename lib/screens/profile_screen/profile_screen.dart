import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/photo_viewer.dart';
import 'package:social_media_app/screens/profile_screen/profile_manger.dart';
import 'package:social_media_app/screens/update_picture_screen/update_picture_screen.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/post_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/string_manger.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.postModel, required this.user})
      : super(key: key);
  final List<PostModel> postModel;
  final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileManger gloableModel;

  final HomeManger homeManger = StaticManger.homeManger!;
  @override
  void dispose() {
    super.dispose();
    StaticManger.profileManger = null;
  }

  Widget cameraBtn({required Function onClick}) {
    if (gloableModel.userModel.uid == FirebaseAuth.instance.currentUser!.uid) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onClick(),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 21.5.r,
            child: CircleAvatar(
              backgroundColor: Colors.grey[350],
              radius: 18.5.r,
              child: Icon(
                FontAwesomeIcons.camera,
                size: 18.h,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getHeader(context) {
    return Material(
      elevation: 1,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 250.h,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhotoViewer(gloableModel.userModel.cover),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Image(
                        image: CachedNetworkImageProvider(
                          gloableModel.userModel.cover,
                        ),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 200.h,
                      ),
                      cameraBtn(onClick: () {
                        Navigator.push(
                          context,
                          SlideRight(
                            screen: const UpdatePictureScreen(
                              type: PicType.cover,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: SizedBox(
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
                                        builder: (context) => PhotoViewer(
                                            gloableModel.userModel.image),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 57.r,
                                    backgroundImage: CachedNetworkImageProvider(
                                        gloableModel.userModel.image),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 70.w,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomStart,
                                child: cameraBtn(onClick: () {
                                  Navigator.push(
                                    context,
                                    SlideRight(
                                      screen: const UpdatePictureScreen(
                                        type: PicType.profile,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
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
                gloableModel.userModel.name,
                style: defaultNameStyle,
              ),
            ),
          ),
          if (gloableModel.userModel.bio != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Text(
                  gloableModel.userModel.bio!,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        ProfileManger manger = ProfileManger(
          postModel: widget.postModel,
          userModel: widget.user,
        );
        StaticManger.profileManger = manger;
        gloableModel = manger;
        return manger;
      },
      builder: (context, child) => Consumer<ProfileManger>(
        builder: (context, model, child) {
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
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Builder(
                    builder: (context) {
                      if (model.postModel.isEmpty) {
                        return Column(
                          children: [
                            getHeader(context),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: MyColor.grey,
                                    size: 100.r,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'No Posts Yet',
                                    style: logoTextStyle.copyWith(
                                      color: MyColor.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return getHeader(context);
                            } else {
                              return PostWidget(
                                homeManger: homeManger,
                                postModel: widget.postModel[index - 1],
                                isActive: false,
                              );
                            }
                          },
                          itemCount: widget.postModel.length + 1,
                        );
                      }
                    },
                  ),
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
