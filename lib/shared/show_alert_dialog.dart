import 'package:firebase_auth/firebase_auth.dart';
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
                      height: 15,
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

void updatePassword(context) {
  HomeManger homeManger = StaticManger.homeManger!;
  SettingManger settingManger = StaticManger.settingManger!;
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();
  _showAlertDialog(
    context: context,
    build: SizedBox(
      height: 310,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                padding: defaultPadding,
                height: 285,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 15,
                    ),
                    Text(
                      'Update Password',
                      style: logoTextStyle,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 15,
                    ),
                    TextField(
                      maxLength: 50,
                      style: defaultHintStyle.copyWith(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: oldPass,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'Old password',
                        labelText: 'Old password',
                        hintStyle: defaultHintStyle,
                        //border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 15,
                    ),
                    TextField(
                      maxLength: 50,
                      style: defaultHintStyle.copyWith(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: newPass,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'New password',
                        labelText: 'New password',
                        hintStyle: defaultHintStyle,
                        //border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 15,
                    ),
                    TextField(
                      maxLength: 50,
                      style: defaultHintStyle.copyWith(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: confirmNewPass,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(0),
                        hintText: 'Confirm New password',
                        labelText: 'Confirm New password',
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
                onTap: () async {
                  if (oldPass.text.isEmpty ||
                      newPass.text.isEmpty ||
                      confirmNewPass.text.isEmpty) {
                    toast('All fields are required');
                    return;
                  }
                  final user = FirebaseAuth.instance.currentUser;
                  final credential = EmailAuthProvider.credential(
                      email: user!.email!, password: oldPass.text);
                  try {
                    await user.reauthenticateWithCredential(credential);
                    if (newPass.text != confirmNewPass.text) {
                      toast('passwords not matched');
                      return;
                    }
                    if (newPass.text == oldPass.text) {
                      toast('you cann\'t update to same password');
                      return;
                    }
                  } on FirebaseAuthException catch (e) {
                    toast('Wrong old password');
                    return;
                  }
                  settingManger.updatePassword(newPass.text);
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
