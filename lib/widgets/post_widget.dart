import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/comment_screen/commet_screen.dart';
import 'package:social_media_app/screens/create_new_post/create_post_screen.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/screens/like_list_screen.dart';
import 'package:social_media_app/screens/photo_viewer.dart';
import 'package:social_media_app/screens/profile_screen/profile_screen.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/navigator.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:social_media_app/widgets/post_setting.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget btn({
  required IconData icon,
  required String title,
  required Color color,
  required Function onClick,
}) {
  return Expanded(
    child: InkWell(
      onTap: () => onClick(),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 7.w),
          Text(
            title,
            style: defaultTextStyle.copyWith(color: color, fontSize: 14.sp),
          ),
        ],
      ),
    ),
  );
}

class PostWidget extends StatefulWidget {
  const PostWidget(
      {Key? key,
      required this.postModel,
      this.isActive = true,
      required this.homeManger})
      : super(key: key);
  final PostModel postModel;
  final HomeManger homeManger;
  final bool isActive;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  void initState() {
    super.initState();
    watchComments();
  }

  late StreamSubscription commentStream;
  int commentCounter = 0;
  void watchComments() {
    commentStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postModel.postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      setState(() {
        commentCounter = event.docs.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentStream.cancel();
  }

  void like() {
    bool isLiked = widget.postModel.likes.contains(widget.homeManger.user.uid);
    String uid = widget.homeManger.user.uid;
    if (isLiked) {
      setState(() {
        widget.postModel.likes.remove(uid);
      });
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postModel.postId)
          .collection('likes')
          .doc(uid)
          .delete()
          .catchError((error) {
        toast('Error');
        setState(() {
          widget.postModel.likes.add(uid);
        });
      });
    } else {
      setState(() {
        widget.postModel.likes.add(uid);
      });
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postModel.postId)
          .collection('likes')
          .doc(uid)
          .set({}).catchError((error) {
        toast('Error');
        setState(() {
          widget.postModel.likes.remove(uid);
        });
      });
    }
    if (!widget.isActive) {
      List<PostModel> posts = StaticManger.homeManger!.posts;
      for (PostModel post in posts) {
        if (post.postId == widget.postModel.postId) {
          post = widget.postModel;
        }
      }
      StaticManger.homeManger!.notifyListeners();
    }
  }

  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.postModel.likes.contains(widget.homeManger.user.uid);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Material(
        elevation: 5,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: defaultPadding,
                child: Row(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      enableFeedback: widget.isActive,
                      onTap: () {
                        if (widget.isActive) {
                          Navigator.push(
                              context,
                              SlideRight(
                                  screen: ProfileScreen(
                                user: widget.postModel.userModel!,
                                postModel: widget.homeManger
                                    .postById[widget.postModel.userId]!,
                              )));
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.postModel.userModel!.image),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          enableFeedback: widget.isActive,
                          onTap: () {
                            if (widget.isActive) {
                              Navigator.push(
                                  context,
                                  SlideRight(
                                      screen: ProfileScreen(
                                    user: widget.postModel.userModel!,
                                    postModel: widget.homeManger
                                        .postById[widget.postModel.userId]!,
                                  )));
                            }
                          },
                          child: Text(
                            widget.postModel.userModel!.name,
                            style: defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          timeago.format(
                            DateTime.parse(widget.postModel.date),
                            clock: widget.homeManger.dateTime,
                          ),
                          style: defaultHintStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    if (widget.postModel.userId == myUid)
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 140.h,
                                  child: Column(
                                    children: [
                                      postSetting(
                                        title: 'Edit post',
                                        icon: Icons.edit,
                                        onClick: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            SlideRight(
                                              screen: CreateNewPostScreen(
                                                postModel: widget.postModel,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      postSetting(
                                        title: 'Delete post',
                                        icon: Icons.delete,
                                        onClick: () {
                                          HomeManger manger =
                                              StaticManger.homeManger!;
                                          manger.deletePost(
                                            context,
                                            widget.postModel,
                                            widget.isActive,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Icon(
                          FontAwesomeIcons.caretDown,
                          size: 15.sp,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.postModel.content != null &&
                  widget.postModel.content!.isNotEmpty)
                Padding(
                  padding: defaultPadding,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.postModel.content!,
                      style: defaultTextStyle,
                    ),
                  ),
                ),
              if (widget.postModel.image != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PhotoViewer(widget.postModel.image!)));
                      },
                      child: Image.network(widget.postModel.image!),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.postModel.likes.isNotEmpty)
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        SlideRight(
                          screen: LikeListScreen(widget.postModel.likes),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            '${widget.postModel.likes.length} like',
                            style: defaultHintStyle,
                          ),
                        ),
                      ),
                    ),
                  if (commentCounter != 0)
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        SlideRight(
                          screen: CommentScreen(
                            postModel: widget.postModel,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 5),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            '$commentCounter comments',
                            style: defaultHintStyle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
              Padding(
                padding: defaultPadding,
                child: Row(
                  children: [
                    btn(
                      icon: isLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      title: 'Like',
                      color: isLiked ? MyColor.red : Colors.black,
                      onClick: () => like(),
                    ),
                    btn(
                      icon: FontAwesomeIcons.comment,
                      title: 'Comments',
                      color: Colors.black,
                      onClick: () {
                        Navigator.push(
                          context,
                          SlideRight(
                            screen: CommentScreen(
                              postModel: widget.postModel,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
