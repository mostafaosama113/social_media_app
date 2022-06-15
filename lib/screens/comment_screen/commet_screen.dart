import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/comment_bubble.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postModel}) : super(key: key);
  final PostModel postModel;
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool isLoading = false;
  List<CommentModel> comments = [];

  @override
  void initState() {
    super.initState();
    getAllComments();
  }

  void getAllComments() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postModel.postId)
        .collection('comments')
        .orderBy('data')
        .get();
    List<QueryDocumentSnapshot<Object?>> list = snapshot.docs;
    for (QueryDocumentSnapshot element in list) {
      CommentModel model = CommentModel.fromJson(element);
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection('users')
          .doc(model.userId)
          .get();
      model.user = UserModel.fromJson(user);
      comments.add(model);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Text(
              'Comment',
              style: logoTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return commentBubble(comments[index]);
                  },
                  itemCount: comments.length,
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: MyColor.blue,
              ),
              Container(
                height: 45,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Comment',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: 1,
                        color: MyColor.blue,
                      ),
                      InkWell(
                        onTap: () {
                          //todo : submit comment
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                          ),
                          child: Icon(
                            FontAwesomeIcons.paperPlane,
                            color: MyColor.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        if (isLoading) loadingWidget(),
      ],
    );
  }
}
