import 'package:flutter/material.dart';
import 'package:social_media_app/components/input_field.dart';
import 'package:social_media_app/components/roundbutton.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController repass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: defaultPadding,
                  child: Text(
                    'Create New account.',
                    style: logoTextStyle.copyWith(color: Colors.black),
                  ),
                ),
                InputField(
                  hint: 'Email',
                  controller: email,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
                InputField(
                  hint: 'Name',
                  controller: name,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.person,
                  maxLen: 20,
                ),
                InputField(
                  hint: 'Password',
                  controller: pass,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.lock,
                  maxLen: 20,
                ),
                InputField(
                  hint: 'Re-Enter Password',
                  controller: repass,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.lock,
                  maxLen: 20,
                ),
                RoundButton(title: 'Register', onClick: () {}),
              ],
            ),
          ),
        ),
        if (false) loadingWidget(),
      ],
    );
  }
}
