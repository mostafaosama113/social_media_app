import 'package:flutter/material.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';

Widget postSetting({
  required IconData icon,
  required String title,
  required Function onClick,
  double? size,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 5,
      right: 15,
      left: 15,
    ),
    child: InkWell(
      onTap: () => onClick(),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 15,
        child: Container(
          height: 60.h,
          width: double.infinity,
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
            padding: defaultPadding,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: MyColor.lightBlue,
                  size: size,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: defaultButtonStyle.copyWith(
                    color: MyColor.lightBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
