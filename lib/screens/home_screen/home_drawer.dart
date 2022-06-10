import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/profile_screen/profile_screen.dart';
import 'package:social_media_app/screens/setting/setting_screen.dart';
import 'package:social_media_app/shared/navigator.dart';
import '../../shared/colors.dart';
import '../../shared/manger/text_style_manger.dart';

Widget homeDrawer(
    {required BuildContext context,
    required UserModel userModel,
    required HomeManger model}) {
  return Drawer(
    width: MediaQuery.of(context).size.width * .55,
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: MyColor.blue,
                radius: 52.r,
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userModel.image),
                    radius: 50.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            btnBar(
              context: context,
              title: 'View profile',
              icon: FontAwesomeIcons.user,
              onClick: () => Navigator.push(
                context,
                SlideRight(
                  screen: ProfileScreen(
                    user: userModel,
                    postModel: model
                            .postById[FirebaseAuth.instance.currentUser!.uid] ??
                        [],
                  ),
                ),
              ),
            ),
            btnBar(
              context: context,
              title: 'messanger',
              icon: FontAwesomeIcons.facebookMessenger,
              onClick: () {},
            ),
            btnBar(
              context: context,
              title: 'Setting',
              icon: FontAwesomeIcons.gear,
              onClick: () {
                Navigator.push(
                  context,
                  SlideRight(
                    screen: SettingScreen(),
                  ),
                );
              },
            ),
            btnBar(
              context: context,
              title: 'Sign out',
              icon: FontAwesomeIcons.arrowRightFromBracket,
              onClick: () => model.signOut(context),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget btnBar({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Function onClick,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Row(
      children: [
        Icon(
          icon,
          color: MyColor.lightBlue,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onClick();
          },
          child: Text(
            title,
            style: defaultTextStyle,
          ),
        ),
      ],
    ),
  );
}
