import 'package:flutter/material.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget userTile(UserModel model, {bool isTyping = false}) {
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: NetworkImage(model.image),
      ),
      SizedBox(
        width: 10.w,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.name,
            style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (isTyping)
            Text(
              'Typing...',
              style: defaultHintStyle,
            )
        ],
      ),
    ],
  );
}
