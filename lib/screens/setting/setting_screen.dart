import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/setting/setting_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/show_alert_dialog.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

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

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final HomeManger homeManger = StaticManger.homeManger!;
  @override
  void dispose() {
    super.dispose();
    StaticManger.settingManger = null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        SettingManger settingManger = SettingManger();
        StaticManger.settingManger = settingManger;
        return settingManger;
      },
      child: Consumer<SettingManger>(
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
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
                        onClick: () =>
                            updatePersonalData(context, type: UpdateType.name),
                      ),
                      getInfoTail(
                        title: 'Bio',
                        data: (homeManger.user.bio == null ||
                                homeManger.user.bio!.isEmpty)
                            ? 'No bio'
                            : homeManger.user.bio!,
                        onClick: () =>
                            updatePersonalData(context, type: UpdateType.bio),
                      ),
                      getInfoTail(
                        title: 'Password',
                        data: 'Update your password',
                        onClick: () => updatePassword(context),
                      ),
                    ],
                  ),
                ),
              ),
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
