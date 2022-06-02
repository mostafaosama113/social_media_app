import 'package:flutter/material.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({Key? key, required this.title, required this.onClick})
      : super(key: key);
  final String title;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: InkWell(
        onTap: () => onClick(),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            height: 55.h,
            color: MyColor.blue,
            child: Center(
              child: Text(
                title,
                style: defaultButtonStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
