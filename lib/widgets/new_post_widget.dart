import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';

Widget newPostWidget(
    {required UserModel model, required BuildContext context}) {
  return InkWell(
    onTap: () {},
    child: Material(
      elevation: 5,
      child: Container(
        color: Colors.white,
        height: 60.h,
        child: Padding(
          padding: defaultPadding,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  model.image,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'What is in your mind?',
                style: defaultTextStyle.copyWith(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
