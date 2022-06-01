import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/components/input_field.dart';
import 'package:social_media_app/screens/login_screen/login_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

import '../../shared/roundbutton.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginManger(),
      builder: (context, child) => Consumer<LoginManger>(
        builder: (context, model, child) => Stack(
          children: [
            Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: double.infinity),
                    SizedBox(
                      height: 300.h,
                      child: Lottie.asset(
                        'assets/lottiefiles/hello.json',
                        repeat: false,
                        height: 300.h,
                      ),
                    ),
                    InputField(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                    ),
                    InputField(
                      controller: passwordController,
                      hint: 'Password',
                      isPass: true,
                      icon: Icons.lock,
                    ),
                    RoundButton(
                      title: 'Login',
                      onClick: () => model.login(
                        context,
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    ),
                    Padding(
                      padding: defaultPadding,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Wrap(
                          children: [
                            Text(
                              'don\'t have an account ? ',
                              style: defaultTextStyle,
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                //todo : navigate to register screen
                              },
                              child: Text(
                                'sign up',
                                style: defaultTextStyle.copyWith(
                                  color: MyColor.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (model.isLoading) loadingWidget(),
          ],
        ),
      ),
    );
  }
}
