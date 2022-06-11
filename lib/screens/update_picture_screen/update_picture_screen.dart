import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/update_picture_screen/update_pic_manger.dart';
import 'package:social_media_app/shared/colors.dart';
import 'package:social_media_app/shared/manger/padding_manger.dart';
import 'package:social_media_app/shared/manger/text_style_manger.dart';
import 'package:social_media_app/widgets/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/picture_model.dart';

enum PicType { profile, cover }

Widget getPicFrame({
  required PictureModel picture,
  required Function onClick,
}) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: () => onClick(),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image(image: CachedNetworkImageProvider(picture.link)),
        if (picture.isSelected)
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              width: 3,
              color: MyColor.blue,
            )),
          )
      ],
    ),
  );
}

class UpdatePictureScreen extends StatefulWidget {
  const UpdatePictureScreen({Key? key, required this.type}) : super(key: key);
  final PicType type;
  @override
  _UpdatePictureScreenState createState() => _UpdatePictureScreenState();
}

class _UpdatePictureScreenState extends State<UpdatePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UpdatePicManger(type: widget.type, context: context),
      builder: (context, child) => Consumer<UpdatePicManger>(
        builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Text(
                    'Update ${widget.type == PicType.profile ? 'Profile' : 'Cover'} Picture',
                    style: logoTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        model.update(context);
                      },
                      child: const Icon(Icons.check),
                    )
                  ],
                ),
                body: model.isLoading == false && model.pictures.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          Icon(
                            Icons.camera_alt,
                            color: MyColor.grey,
                            size: 100.r,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'No Images',
                            style: logoTextStyle.copyWith(
                              color: MyColor.grey,
                            ),
                          ),
                        ],
                      )
                    : GridView.count(
                        padding: defaultPadding,
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.w,
                        mainAxisSpacing: 8.w,
                        children: [
                          for (PictureModel picture in model.pictures)
                            getPicFrame(
                                picture: picture,
                                onClick: () {
                                  setState(() {
                                    for (PictureModel temp in model.pictures) {
                                      temp.isSelected = false;
                                    }
                                    picture.isSelected = true;
                                  });
                                })
                        ],
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => model.upload(),
                  backgroundColor: MyColor.blue,
                  child: const Icon(
                    Icons.add,
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
