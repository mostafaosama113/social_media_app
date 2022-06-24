import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/profile_screen/profile_screen.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/post_setting.dart';

Widget commentBubble({
  required context,
  required CommentModel commentModel,
  required PostModel postModel,
  required Function onClick,
}) {
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  void navigateToProfile() => Navigator.push(
        context,
        SlideRight(
          screen: ProfileScreen(
            user: commentModel.user!,
            postModel:
                StaticManger.homeManger!.postById[commentModel.user!.uid]!,
          ),
        ),
      );

  return Padding(
    padding: defaultPadding,
    child: InkWell(
      splashColor: myUid == commentModel.userId ? null : Colors.transparent,
      highlightColor: myUid == commentModel.userId ? null : Colors.transparent,
      onLongPress: () {
        if (myUid == commentModel.userId /*|| postModel.userId == myUid*/) {
          showModalBottomSheet(
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0,
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: postSetting(
                        icon: Icons.delete,
                        title: 'Delete comment',
                        onClick: () {
                          onClick();
                          Navigator.pop(context);
                        }),
                  ));
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: InkWell(
              onTap: () => navigateToProfile(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: CircleAvatar(
                radius: 22.r,
                backgroundImage: NetworkImage(commentModel.user!.image),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Material(
              color: Colors.grey[300],
              elevation: 1,
              borderRadius: const BorderRadiusDirectional.all(
                Radius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => navigateToProfile(),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        commentModel.user!.name,
                        style: defaultTextStyle.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      commentModel.comment,
                      style: defaultTextStyle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
