import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/screens/profile_screen/profile_screen.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

class LikeListScreen extends StatefulWidget {
  const LikeListScreen(this.uIds, {Key? key}) : super(key: key);
  final List<String> uIds;
  @override
  _LikeListScreenState createState() => _LikeListScreenState();
}

class _LikeListScreenState extends State<LikeListScreen> {
  bool isLoading = false;
  List<UserModel> users = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    for (String uid in widget.uIds) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      users.add(UserModel.fromSnapshot(snapshot));
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget getUserTile(UserModel user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          SlideRight(
            screen: ProfileScreen(
              user: user,
              postModel: StaticManger.homeManger!.postById[user.uid]!,
            ),
          ),
        );
      },
      child: Padding(
        padding: defaultPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.image,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              user.name,
              style: defaultTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              'Likes',
              style: logoTextStyle,
            ),
          ),
          body: users.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => getUserTile(users[index]),
                  itemCount: users.length,
                ),
        ),
        if (isLoading) loadingWidget(),
      ],
    );
  }
}
