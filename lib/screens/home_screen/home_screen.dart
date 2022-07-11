import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/home_screen/home_drawer.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/notification_widget.dart';
import 'package:social_media_app/shared/string_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:social_media_app/widgets/new_post_widget.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.userModel, {Key? key}) : super(key: key) {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  }
  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    showNotification(
      message: message,
    );
  }

  final UserModel userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    super.dispose();
    StaticManger.context.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        HomeManger manger = HomeManger(widget.userModel)..getPosts();
        StaticManger.homeManger = manger;
        StaticManger.userModel = widget.userModel;
        return manger;
      },
      builder: (context, child) => Consumer<HomeManger>(
        builder: (context, model, child) {
          StaticManger.context.value ??= context;
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
                body: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () async => await model.getPosts(),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return newPostWidget(
                            model: widget.userModel, context: context);
                      } else {
                        return PostWidget(
                          homeManger: model,
                          postModel: model.posts[index - 1],
                        );
                      }
                    },
                    itemCount: 1 + model.posts.length,
                  ),
                ),
                drawer: homeDrawer(
                    context: context,
                    userModel: widget.userModel,
                    model: model),
              ),
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
