import 'package:flutter/material.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';

Widget commentBubble(CommentModel commentModel) {
  return Padding(
    padding: defaultPadding,
    child: InkWell(
      onLongPress: () {
        //todo : delete comment
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
