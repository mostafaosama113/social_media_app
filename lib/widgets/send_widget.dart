import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/shared/colors.dart';

Widget sendWidget(
    {required controller, required Function onClick, required String hint}) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () => onClick(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: Icon(
                FontAwesomeIcons.paperPlane,
                color: MyColor.blue,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
