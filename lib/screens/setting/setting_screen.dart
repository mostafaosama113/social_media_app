import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget getInfoTail({
  required String title,
  required String data,
  required Function onClick,
}) {
  return InkWell(
    onTap: () => onClick(),
    child: Column(
      children: [
        Padding(
          padding: defaultPadding,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: defaultTextStyle,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data,
                    style: defaultHintStyle,
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: 30.h,
                color: MyColor.grey,
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: MyColor.grey,
          width: double.infinity,
        )
      ],
    ),
  );
}

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);
  final HomeManger homeManger = StaticManger.homeManger!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: defaultPadding,
              child: Text(
                'Personal and account information',
                style: logoTextStyle.copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            getInfoTail(
              title: 'Name',
              data: homeManger.user.name,
              onClick: () {},
            ),
            getInfoTail(
              title: 'Bio',
              data: homeManger.user.bio ?? 'No bio added',
              onClick: () {},
            ),
            getInfoTail(
              title: 'Password',
              data: 'Update your password',
              onClick: () {},
            ),
          ],
        ),
      ),
    );
  }
}
