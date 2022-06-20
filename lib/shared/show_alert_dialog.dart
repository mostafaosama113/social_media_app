import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/setting/setting_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';

enum UpdateType {
  name,
  bio,
}

void _showAlertDialog({
  required BuildContext context,
  required Widget build,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: build,
      );
    },
  );
}

void updatePersonalData(
  context, {
  required UpdateType type,
}) {
  HomeManger homeManger = StaticManger.homeManger!;
  SettingManger settingManger = StaticManger.settingManger!;
  TextEditingController controller = TextEditingController();
  String oldData = '';
  if (type == UpdateType.name) {
    controller.text = homeManger.user.name;
    oldData = homeManger.user.name;
  } else {
    controller.text = homeManger.user.bio ?? '';
    oldData = homeManger.user.bio ?? '';
  }
  _showAlertDialog(
    context: context,
    build: SizedBox(
      height: 150,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: defaultPadding,
                height: 125,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 10,
                    ),
                    Text(
                      'Update ${type == UpdateType.name ? 'Name' : 'Bio'}',
                      style: logoTextStyle,
                    ),
                    TextField(
                      controller: controller,
                      maxLength: 50,
                      style: defaultHintStyle.copyWith(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(0),
                        hintText: type == UpdateType.name ? 'Name' : 'Bio',
                        hintStyle: defaultHintStyle,
                        //border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 5.0),
              child: InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (type == UpdateType.name && controller.text.isEmpty) {
                    toast('Name is required');
                    return;
                  }
                  if (controller.text != oldData) {
                    if (type == UpdateType.name) {
                      settingManger.updateName(controller.text);
                    } else {
                      settingManger.updateBio(controller.text);
                    }
                  }
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: MyColor.lightBlue,
                  child: const Icon(
                    FontAwesomeIcons.arrowUp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
