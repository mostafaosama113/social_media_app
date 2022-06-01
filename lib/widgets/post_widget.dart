import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/screens/photo_viewer.dart';
import 'package:social_media_app/shared/colors.dart';
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
  const PostWidget(this.postModel, {Key? key}) : super(key: key);
  final PostModel postModel;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  void initState() {
    super.initState();
  }

  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
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
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.postModel.userModel!.image),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postModel.userModel!.name,
                          style: defaultTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          timeago.format(DateTime.parse(widget.postModel.date)),
                          style: defaultHintStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    if (widget.postModel.userId == myUid)
                      InkWell(
                        onTap: () {},
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
              if (widget.postModel.content != null)
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PhotoViewer(widget.postModel.image!)));
                  },
                  child: Image.network(widget.postModel.image!),
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
                      icon: FontAwesomeIcons.solidHeart,
                      // icon: FontAwesomeIcons.heart,
                      title: 'Like',
                      color: MyColor.blue,
                      onClick: () {
                        //todo : like function
                      },
                    ),
                    btn(
                      icon: FontAwesomeIcons.comment,
                      title: 'Comments',
                      color: Colors.black,
                      onClick: () {
                        //todo : comment function
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
