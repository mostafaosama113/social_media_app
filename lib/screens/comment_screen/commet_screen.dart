import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/comment_screen/comment_manger.dart';
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
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CommentManger(widget.postModel),
      builder: (context, child) => Consumer<CommentManger>(
        builder: (context, model, child) {
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
                        reverse: false,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return commentBubble(
                              context: context,
                              commentModel: model.comments[index],
                              onClick: () => model.deleteComment(
                                    commentModel: model.comments[index],
                                    postModel: widget.postModel,
                                  ));
                        },
                        itemCount: model.comments.length,
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
                                controller: commentController,
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
                                model.addNewComment(commentController);
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
              if (model.isLoading) loadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
