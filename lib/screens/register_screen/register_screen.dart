import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/input_field.dart';
import 'package:social_media_app/components/roundbutton.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_screen.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/shared/string_manger.dart';
import '../../components/toast.dart';
import '../../widgets/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController repass = TextEditingController();
  bool isLoading = false;

  void register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (email.text.isEmpty ||
        name.text.isEmpty ||
        pass.text.isEmpty ||
        repass.text.isEmpty) {
      {
        toast('All field are required');
      }
    } else if (pass.text != repass.text) {
      toast('Password not match');
    } else if (pass.text.length < 6) {
      toast('Password to week');
    } else {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then(
        (user) async {
          String uid = user.user!.uid;
          FirebaseFirestore.instance.collection('users').doc(uid).set({
            'name': name.text,
            'image': StringManger.defaultProfileImage,
            'cover': StringManger.defaultProfileCover,
          }).then((value) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushReplacement(
              context,
              SlideRight(
                screen: HomeScreen(
                  UserModel(
                    image: StringManger.defaultProfileImage,
                    cover: StringManger.defaultProfileCover,
                    name: name.text,
                    uid: user.user!.uid,
                  ),
                ),
              ),
            );
          }).catchError((error) {
            setState(() {
              isLoading = false;
            });
            toast(error.message);
          });
        },
      ).catchError(
        (error) {
          toast(error.message);
          setState(() {
            isLoading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  inputType: TextInputType.name,
                  icon: Icons.person,
                  maxLen: 20,
                ),
                InputField(
                  hint: 'Password',
                  controller: pass,
                  inputType: TextInputType.text,
                  icon: Icons.lock,
                  isPass: true,
                  maxLen: 20,
                ),
                InputField(
                  hint: 'Re-Enter Password',
                  controller: repass,
                  inputType: TextInputType.text,
                  icon: Icons.lock,
                  isPass: true,
                  maxLen: 20,
                ),
                RoundButton(title: 'Register', onClick: () => register()),
              ],
            ),
          ),
        ),
        if (isLoading) loadingWidget(),
      ],
    );
  }
}
