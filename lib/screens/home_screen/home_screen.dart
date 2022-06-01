import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/string_manger.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/new_post_widget.dart';
import 'package:social_media_app/widgets/post_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.userModel, {Key? key}) : super(key: key);
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeManger()..getPosts(),
      builder: (context, child) => Consumer<HomeManger>(
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(color: MyColor.blue),
                  titleSpacing: 0,
                  title: Text(
                    StringManger.appTitle,
                    style: logoTextStyle,
                  ),
                ),
                body: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return newPostWidget(model: userModel, context: context);
                    } else {
                      return PostWidget(model.posts[index - 1]);
                    }
                  },
                  itemCount: 1 + model.posts.length,
                ),
                drawer: Drawer(
                  width: MediaQuery.of(context).size.width * .55,
                  backgroundColor: Colors.white,
                  child: SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 52.r,
                              child: Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userModel.image),
                                  radius: 50.r,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          btnBar(
                            title: 'View profile',
                            icon: FontAwesomeIcons.user,
                            onClick: () {},
                          ),
                          btnBar(
                            title: 'messanger',
                            icon: FontAwesomeIcons.facebookMessenger,
                            onClick: () {},
                          ),
                          btnBar(
                            title: 'Setting',
                            icon: FontAwesomeIcons.barsProgress,
                            onClick: () {},
                          ),
                          btnBar(
                            title: 'Sign out',
                            icon: FontAwesomeIcons.arrowRightFromBracket,
                            onClick: () => model.signOut(context),
                          ),
                        ],
                      ),
                    ),
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

Widget btnBar({
  required String title,
  required IconData icon,
  required Function onClick,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Row(
      children: [
        Icon(
          icon,
          color: MyColor.blue,
        ),
        TextButton(
          onPressed: () => onClick(),
          child: Text(
            title,
            style: defaultTextStyle,
          ),
        ),
      ],
    ),
  );
}
