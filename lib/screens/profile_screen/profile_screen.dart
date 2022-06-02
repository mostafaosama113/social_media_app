import 'package:flutter/material.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/photo_viewer.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/post_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
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
                                  builder: (context) =>
                                      PhotoViewer(userModel.cover),
                                ),
                              );
                            },
                            child: Image(
                              image: NetworkImage(
                                userModel.cover,
                              ),
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: 200.h,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
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
                        ],
                      ),
                    ),
                    Text(
                      userModel.name,
                      style: defaultNameStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        color: Colors.grey,
                        height: 1,
                        width: double.infinity,
                      ),
                    )
                  ],
                );
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
