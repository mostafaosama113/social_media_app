import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_drawer.dart';
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
                      return PostWidget(
                        homeManger: model,
                        postModel: model.posts[index - 1],
                      );
                    }
                  },
                  itemCount: 1 + model.posts.length,
                ),
                drawer: homeDrawer(
                    context: context, userModel: userModel, model: model),
              ),
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
