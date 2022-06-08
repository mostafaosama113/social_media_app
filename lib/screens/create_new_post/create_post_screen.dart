import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home_screen/home_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/static_access/mangers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/widgets/loading_widget.dart';

class CreateNewPostScreen extends StatefulWidget {
  const CreateNewPostScreen({Key? key}) : super(key: key);

  @override
  _CreateNewPostScreenState createState() => _CreateNewPostScreenState();
}

class _CreateNewPostScreenState extends State<CreateNewPostScreen> {
  final HomeManger homeManger = StaticManger.homeManger!;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Create Post',
              style: defaultTextStyle.copyWith(
                color: MyColor.blue,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  //todo : upload post
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: defaultPadding,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              homeManger.user.image,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            homeManger.user.name,
                            style: defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                            border: InputBorder.none),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (true)
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              margin: EdgeInsets.zero,
              child: InkWell(
                onTap: () {
                  //todo : upload photo
                },
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    border: Border.all(color: MyColor.grey),
                    color: Colors.white,
                  ),
                  height: 70,
                  child: Padding(
                    padding: defaultPadding,
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: MyColor.lightBlue,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Add photo',
                          style: defaultTextStyle.copyWith(
                              color: MyColor.lightBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (false) loadingWidget(),
      ],
    );
  }
}
