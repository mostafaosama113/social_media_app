import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/post_setting.dart';

Widget commentBubble({
  required context,
  required CommentModel commentModel,
  required Function onClick,
}) {
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  return Padding(
    padding: defaultPadding,
    child: InkWell(
      splashColor: myUid == commentModel.userId ? null : Colors.transparent,
      highlightColor: myUid == commentModel.userId ? null : Colors.transparent,
      onLongPress: () {
        if (myUid == commentModel.userId) {
          showModalBottomSheet(
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0,
              context: context,
              builder: (context) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: postSetting(
                        icon: Icons.delete,
                        title: 'Remove comment',
                        onClick: () {
                          onClick();
                          Navigator.pop(context);
                        }),
                  ));
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: NetworkImage(commentModel.user!.image),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Material(
              color: Colors.grey[300],
              elevation: 1,
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
                bottomStart: Radius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                child: Text(
                  commentModel.comment,
                  style: defaultTextStyle.copyWith(fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
